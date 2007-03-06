Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXCFAd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXCFAd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933611AbXCFAd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:33:59 -0500
Received: from mail08.syd.optusnet.com.au ([211.29.132.189]:58458 "EHLO
	mail08.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933605AbXCFAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:33:58 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free   interactive cpu scheduler
Date: Tue, 6 Mar 2007 11:18:44 +1100
User-Agent: KMail/1.9.5
Cc: jos poortvliet <jos@mijnkamer.nl>, ck@vds.kolivas.org,
       Gene Heskett <gene.heskett@gmail.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
References: <200703041800.53360.kernel@kolivas.org> <200703041708.54953.jos@mijnkamer.nl> <45ECA239.5000306@tmr.com>
In-Reply-To: <45ECA239.5000306@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061118.44616.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 10:05, Bill Davidsen wrote:
> jos poortvliet wrote:
> > Well, imho his current staircase scheduler already does a better job
> > compared to mainline, but it won't make it in (or at least, it's not
> > likely). So we can hope this WILL make it into mainline, but I wouldn't
> > count on it.
>
> Wrong problem, what is really needed is to get CPU scheduler choice into
> mainline, just as i/o scheduler finally did. Con has noted that for some
> loads this will present suboptimal performance, as will his -ck patches,
> as will the default scheduler. Instead of trying to make ANY one size
> fit all, we should have a means to select, at runtime, between any of
> the schedulers, and preferably to define an interface by which a user
> can insert a new scheduler in the kernel (compile in, I don't mean
> plugable) with clear and well defined rules for how that can be done.

Been there, done that. Wli wrote the infrastructure for plugsched; I took his 
code and got it booting and ported 3 or so different scheduler designs. It 
allowed you to build as few or as many different schedulers into the kernel 
and either boot the only one you built into your kernel, or choose a 
scheduler at boot time. That code got permavetoed by both Ingo and Linus. 
After that I gave up on that code and handed it over to Peter Williams who 
still maintains it. So please note that I pushed the plugsched barrow 
previously and still don't think it's a bad idea, but the maintainers think 
it's the wrong approach.

RSDL is my attempt to create a cpu scheduler to try to do everything well 
instead of some things perfectly, to be best fit when trying to shoehorn it 
into any environment. 

-- 
-ck
