Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbXKDSrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbXKDSrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXKDSrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:47:12 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:29606 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbXKDSrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:47:10 -0500
Date: Sun, 4 Nov 2007 10:46:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: duplicated include files
Message-Id: <20071104104620.1216721d.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0711041334590.5541@localhost.localdomain>
References: <Pine.LNX.4.64.0711041229580.27153@localhost.localdomain>
	<20071104100724.518cf6c9.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0711041334590.5541@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007 13:37:31 -0500 (EST) Robert P. J. Day wrote:

> On Sun, 4 Nov 2007, Randy Dunlap wrote:
> 
> > On Sun, 4 Nov 2007 12:31:38 -0500 (EST) Robert P. J. Day wrote:
> >
> > >
> > >   given the recent patches to remove duplicated #include preprocessor
> > > directives in source files, let it be known that there are a number of
> > > them:
> > >
> > >   http://www.crashcourse.ca/wiki/index.php/Duplicate_include_files
> > >
> > > help yourself.
> >
> > Could you make the tool (script?) available also, please?
> 
> trust me, it's not a script i'm particularly proud of:
> 
> ===========================
> #!/bin/sh
> 
> DIR=${1-*}              # by default, all directories
> 
> for cf in $(find ${DIR} -name *.c) ; do
>         echo ${cf}
>         grep "#include" $cf | sort | uniq -c | grep -v 1
> done | grep -B1 "#include" | grep -v -- "--"
> ===========================
> 
>   on the bright side, it took about 90 seconds to write, but i won't
> be winning any awards for style.
> 
>   i'll add it to the web page.

Thanks!

---
~Randy
