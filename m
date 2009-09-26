Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbZIZMoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbZIZMoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZIZMoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:44:13 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:50571 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZIZMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:44:12 -0400
Date: Sat, 26 Sep 2009 08:44:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how best to report results of my kernel tree scanning scripts?
In-Reply-To: <1253968675.4568.3.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0909260841530.19382@localhost>
References: <alpine.LFD.2.00.0909260811470.19017@localhost> <1253968675.4568.3.camel@ht.satnam>
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

On Sat, 26 Sep 2009, Jaswinder Singh Rajput wrote:

> Hello Robert,
>
> On Sat, 2009-09-26 at 08:16 -0400, Robert P. J. Day wrote:
> > since the merge window appears to be ready to close fairly soon(?),
> > i'm prepping to run my scanning scripts once again to identify (among
> > other things):
> >
> >   * unused Kconfig CONFIG variables
> >   * references to CONFIG_ variables that don't even exist (both in
> >     source files and Makefiles)
> >   * references to non-existent header files
> >
> > and bunches of other things.  i'm open as to the best way to post the
> > results, since different people have different opinions.
> >
> >   and, no, i can't just submit patches since, in many cases, i have no
> > idea what the fix should be (if any) -- that's the kind of decision
> > best left to the respective subsystem maintainers.
> >
> >   thoughts?  this is where i put the old output:
> >
> > http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup
> >
>
> Thanks for reporting these results, I will try to fix them and submit
> patches with Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>

  keep in mind that those are *old* results (although, of course, some
of it will still be relevant).  i'll update those pages as soon as
-rc1 is out.  unsurprisingly, some of that is historical cruft that's
been around a *looooong* time.  very little of it represents actual
breakage but, occasionally, those scans will reveal actual typoes.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
