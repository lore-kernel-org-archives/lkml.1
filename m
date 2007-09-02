Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbXIBOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbXIBOrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 10:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXIBOrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 10:47:10 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3456 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbXIBOrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 10:47:09 -0400
Date: Sun, 2 Sep 2007 16:47:33 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <1188694367.11196.42.camel@dhcp193.mvista.com>
Message-ID: <Pine.LNX.4.64.0709021634370.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
 <1188694367.11196.42.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 1 Sep 2007, Daniel Walker wrote:

> Out of curiosity I was reviewing your patch .. Since you create
> kernel/sched_norm.c as a copy of kernel/sched_fair.c it was hard to see
> what had changed .. So I re-diffed your patch to eliminate
> kernel/sched_norm.c and just make the changes to kernel/sched_fair.c .. 

I mainly did it this way to avoid annoying conflicts. I also started with 
a copy where I threw out everything but a basic skeleton and than just 
copied the stuff I needed.

> > (1)	time = sum_{t}^{T}(time_{t})
> > (2)	weight_sum = sum_{t}^{T}(weight_{t})
> 
> I read your description, but I was distracted by this latex style
> notation .. Could you walk through in english what these two equation
> are doing ..

T is the number of tasks, so the first is the sum of the time every task 
gets over a period of time and the second is the sum of all weights of 
each task.

bye, Roman
