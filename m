Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbZFMOt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbZFMOt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZFMOtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:49:25 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55722 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZFMOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:49:22 -0400
Date: Sat, 13 Jun 2009 10:47:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: references to non-existent header files under include/linux
In-Reply-To: <20090613134947.GA30053@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0906131042440.17932@localhost>
References: <alpine.LFD.2.00.0906130932570.16165@localhost> <20090613134947.GA30053@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009, Sam Ravnborg wrote:

> On Sat, Jun 13, 2009 at 09:35:42AM -0400, Robert P. J. Day wrote:
> >
> >   again, since this output is fairly short, this is a list of
> > references throughout the source tree of the form:
> >
> >   #include <linux/whatever>
> >
> > where there does not appear to be any such header file.  might be some
> > false positives but i'm not going to agonize over it.
> >
> >
> > === Missing: include/linux/bounds.h ===
> > include/linux/mmzone.h:18:#include <linux/bounds.h>
> > include/linux/page-flags.h:11:#include <linux/bounds.h>
> bounds.h is generated.
>
> > === Missing: include/linux/compile.h ===
> > arch/x86/boot/version.c:17:#include <linux/compile.h>
> > init/version.c:9:#include <linux/compile.h>
> compile.h is generated.

  which i would have recognized if i hadn't been reduced to drinking
decaf this morning.  *sigh*.

> The rest looks like real bugs.
> Please submit patches to fix them up.

  these days, i'm more partial to just doing the scan and, when the
official time comes, passing off the results to the various subsystem
maintainers, only because sometimes it's not immediately obvious what
the correct fix is.

  maybe it's a typo, maybe it's a partial feature commit where the
code should include the header file but the header file is yet to be
added, maybe it's part of code that is no longer even being compiled
due to changes in #ifdef's or Kconfig files, maybe it's for a
non-intel arch that i'm not set up to test, maybe ... anyway, you get
the idea.  and, in some cases, when the subsystem maintainer takes a
look at it, it might be that that single incorrect line represents a
much larger issue that only that maintainer should deal with.

  in short, i'll just be lazy and whine, and let others do the actual
fixing.  :-)

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
