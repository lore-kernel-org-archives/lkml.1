Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXEGQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXEGQMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXEGQMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:12:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965254AbXEGQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:12:45 -0400
Date: Mon, 7 May 2007 09:11:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Esben Nielsen <nielsen.esben@googlemail.com>
cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <Pine.LNX.4.64.0705071311040.14011@frodo.shire>
Message-ID: <alpine.LFD.0.98.0705070905330.3802@woody.linux-foundation.org>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
 <20070506082911.GA32644@elte.hu> <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705071311040.14011@frodo.shire>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 May 2007, Esben Nielsen wrote:
> 
> I would hate to tell mission control for Mankind's first mission to another
> star to reboot every 200 years because "there is no need to worry about it."

I'd like to put it another way:

 - if your mission to another star *depends* on every single piece of 
   complex equipment staying up with zero reboots for 200+ years, you have 
   some serious technology problems.

In other words: your argument is populist, and totally silly.

Trust me, if you are going to another star, you'd better have the 
capabilities to handle bugs. You'd better have multiple fail-over etc.

A notion of "robustness" cannot and must not hinge on "no bugs". That's 
unrealistic.

> As a matter of principle an OS should never need a reboot (with exception for
> upgrading). If you say you have to reboot every 200 years, why not every 100?
> Every 50? .... Every 45 days (you know what I am referring to :-) ?

There's something of a difference between 45 days and 292 years.

I'm not saying we can't get there, but worrying about it in the current 
state is just stupid. It's not just looking at the trees and not seeing 
the forest, it's looking at one *leaf*, and missing the forest.

And quite frankly, if you work for NASA and are aiming for the stars, 
you'd better not be that person who looks at one leaf and cannot see the 
forest around you. That's the kind of thing that makes you miss the 
difference between miles and kilometers.

		Linus
