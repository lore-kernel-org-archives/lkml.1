Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXDZGww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXDZGww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbXDZGwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:52:51 -0400
Received: from iabervon.org ([66.92.72.58]:2103 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXDZGwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:52:51 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 02:52:50 EDT
Date: Thu, 26 Apr 2007 02:46:08 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070426040806.GJ3468@stusta.de>
Message-ID: <Pine.LNX.4.64.0704260133271.28708@iabervon.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Apr 2007, Adrian Bunk wrote:

> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release:
> 14

I count 13. (v2) had 15 items, of which 2 were subsequently fixed or found 
to be inapplicable.

> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release with patches available at the time of the 2.6.21 
> release [1]:
> 3

The -stable team can presumably take care of these in 2.6.21.1, right? 
That leaves 10 that need developer attention.

 John Stultz seems to be taking care of 3 of them.

 Oliver Neukum has 1.

 2 are particular drivers (ali_pata and rtl8139, according to the 
 reports).

 2 seem to be ACPI-related; at least one has a candidate patch now.

 1 seems to be an ALSA problem.

 1 is STD and being debugged.

It looks like all of the known regressions are being worked on, and 
getting fixes in for them is -stable material at this point. Furthermore, 
it doesn't look to me like anyone who is needed for dealing with these 
regressions is trying to get stuff into the 2.6.22 merge window.

I think it's clear that this is the right point for Linus to start the 
2.6.22 cycle and leave the rest of the 2.6.21 work to the -stable team, 
who are the experts of taking care of this sort of stuff. Furthermore, it 
seems like -rc testers at this point have found everything in 2.6.21-rc 
they're going to, so, again, it's time for new regressions. Personally, I'd 
vote for having Linus leave off at 2.6.X-final, and have 2.6.X be the 
first -stable release of the series, where the remaining known regressions 
get fixed, but that's an issue of nomenclature, not development process.

I think you've allowed for a well-tested 2.6.21, and a good chance of a 
2.6.21.1 or .2 with no known regressions against 2.6.20, which seems to me 
like you succeeded as far as everything except making Linus a release 
engineer.

	-Daniel
*This .sig left intentionally blank*
