Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbXKDTEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbXKDTEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXKDTEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:04:13 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56069 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750753AbXKDTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:04:13 -0500
Date: Sun, 4 Nov 2007 20:03:48 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: duplicated include files
Message-ID: <20071104190348.GN12045@stusta.de>
References: <Pine.LNX.4.64.0711041229580.27153@localhost.localdomain> <20071104100724.518cf6c9.randy.dunlap@oracle.com> <Pine.LNX.4.64.0711041334590.5541@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711041334590.5541@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 01:37:31PM -0500, Robert P. J. Day wrote:
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


BTW:  "make includecheck" already does the same...


> rday


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

