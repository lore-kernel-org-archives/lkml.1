Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXKDSjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXKDSjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXKDSi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:38:56 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39934 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbXKDSi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:38:56 -0500
Date: Sun, 4 Nov 2007 13:37:31 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: duplicated include files
In-Reply-To: <20071104100724.518cf6c9.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0711041334590.5541@localhost.localdomain>
References: <Pine.LNX.4.64.0711041229580.27153@localhost.localdomain>
 <20071104100724.518cf6c9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007, Randy Dunlap wrote:

> On Sun, 4 Nov 2007 12:31:38 -0500 (EST) Robert P. J. Day wrote:
>
> >
> >   given the recent patches to remove duplicated #include preprocessor
> > directives in source files, let it be known that there are a number of
> > them:
> >
> >   http://www.crashcourse.ca/wiki/index.php/Duplicate_include_files
> >
> > help yourself.
>
> Could you make the tool (script?) available also, please?

trust me, it's not a script i'm particularly proud of:

===========================
#!/bin/sh

DIR=${1-*}              # by default, all directories

for cf in $(find ${DIR} -name *.c) ; do
        echo ${cf}
        grep "#include" $cf | sort | uniq -c | grep -v 1
done | grep -B1 "#include" | grep -v -- "--"
===========================

  on the bright side, it took about 90 seconds to write, but i won't
be winning any awards for style.

  i'll add it to the web page.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
