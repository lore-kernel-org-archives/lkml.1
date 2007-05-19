Return-Path: <linux-kernel-owner+w=401wt.eu-S1764855AbXESXVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764855AbXESXVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761042AbXESXVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:21:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:47677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761019AbXESXVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:21:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/vaAgdvOLv9DDBunyAcGs3fw3a6XKh97ElMzWYV8
	mKfgYDz1ASVUPC
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
From: Mike Galbraith <efault@gmx.de>
To: Diego Calleja <diegocg@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <20070519223603.8d70cd6e.diegocg@gmail.com>
References: <464F57DD.2000309@tmr.com>
	 <20070519223603.8d70cd6e.diegocg@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sun, 20 May 2007 01:21:36 +0200
Message-Id: <1179616896.12125.20.camel@RockBox.Denison.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 22:36 +0200, Diego Calleja wrote:
> El Sat, 19 May 2007 16:02:37 -0400, Bill Davidsen <davidsen@tmr.com> escribió:
> 
> > The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for 
> > your viewing pleasure. The only "tuned" result was with sd, since what I 
> > observed was so bad using the default settings. If any scheduler 
> > developers would like me to try other tunings or new versions let me know.
> 
> How useful is glxgears as benchmark here? The X.org people has been saying
> for ages that "glxgears is not a benchmark". Some people (at least on ubuntu)
> even patched it so that if you want to get FPS numbers, you need to pass the
> "-iacknowledgethatthistoolisnotabenchmark" option. There's a good page
> explaining why at http://wiki.cchtml.com/index.php/Glxgears_is_not_a_Benchmark
> 
> I realize that it may be OK for scheduler testing, but maybe it'd be more
> interesting to test other kind of 3d benchmark tools.

The most interesting thing about graphics to me is the effect that
massive bus blasting could have on time measurement.  Generally, cpu
schedulers really want to keep track of time,.. but there's no telling
when some IO controller may blast you right off the bus?

	-Mike

