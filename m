Return-Path: <linux-kernel-owner+w=401wt.eu-S2993163AbXCJClY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993163AbXCJClY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 21:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993161AbXCJClY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 21:41:24 -0500
Received: from waste.org ([66.93.16.53]:59217 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993165AbXCJClX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 21:41:23 -0500
Date: Fri, 9 Mar 2007 20:26:56 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070310022656.GQ10394@waste.org>
References: <20070309053931.GA10459@waste.org> <200703101228.38923.kernel@kolivas.org> <20070310014230.GP10394@waste.org> <200703101320.23125.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703101320.23125.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 01:20:22PM +1100, Con Kolivas wrote:
> Progress at last! And without any patches! Well those look very reasonable to 
> me. Especially since -j5 is a worst case scenario.

Well that's with a noyield patch and your sched_tick fix.

> But would you say it's still _adequate_ with ccache considering you
> only have 1/6th cpu left for X? With and without ccache it's quite a
> different workload so they will behave differently.

No, I don't think 1/6th is being left for X in the ccache case so I
think there's a bug lurking here. My memload, execload, and forkload
test cases did better even with X niced.

To confirm, I've just run 15 instances of memload with unniced Xorg
and it performs better than make -j 5 with ccache.

If I have some time tomorrow, I'll try to do a straight -mm1 to mm2
comparison with different loads.

-- 
Mathematics is the supreme nostalgia of our time.
