Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbXDPRXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbXDPRXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXDPRXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:23:06 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:58403 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXDPRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:23:04 -0400
Message-ID: <4623B0C2.7080806@nortel.com>
Date: Mon, 16 Apr 2007 11:22:10 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Williams <pwil3058@bigpond.net.au>
CC: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au>
In-Reply-To: <4622CC30.6030707@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2007 17:22:14.0513 (UTC) FILETIME=[C6892E10:01C7804B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:

> To my mind scheduling 
> and load balancing are orthogonal and keeping them that way simplifies 
> things.

Scuse me if I jump in here, but doesn't the load balancer need some way 
to figure out a) when to run, and b) which tasks to pull and where to 
push them?

I suppose you could abstract this into a per-scheduler API, but to me at 
least these are the hard parts of the load balancer...

Chris
