Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbXE2RrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbXE2RrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXE2RrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:47:18 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbXE2RrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:47:17 -0400
Date: Tue, 29 May 2007 10:47:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
In-Reply-To: <29495f1d0705291006o1f812ce2n25fa962c222e0b45@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0705291044220.26602@woody.linux-foundation.org>
References: <465C566E.4030009@rtr.ca>  <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
  <465C5C16.7020001@rtr.ca>
 <29495f1d0705291006o1f812ce2n25fa962c222e0b45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Nish Aravamudan wrote:
> 
> git bisect start drivers/usb ? Should only bisect over commits
> affecting any paths you give it.

Yes, but see the caveat in my other email. You need to have git-1.5.1 or 
newer to have this work (it will *mostly* work in older versions, but 
older versions have a terminating problem, so while it actually does the 
bisection correctly, it will screw up at the very end unless all commits 
in the final range are "dense" in that they all trigger in those 
pathnames).

> The man-page is pretty good. There used to be
> http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt,
> but it's 404 now...

That file got folded into the user manual, so it doesn't exist as a 
stand-alone thing any more.

		Linus
