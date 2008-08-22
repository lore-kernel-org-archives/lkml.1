Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbYHVCY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbYHVCY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYHVCYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:24:47 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:34548 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYHVCYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:24:46 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: netdev@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Fri, 22 Aug 2008 05:23:28 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200808220457.40892.denys@visp.net.lb>
In-Reply-To: <200808220457.40892.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808220523.28242.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008, Denys Fedoryshchenko wrote:

Most significant event types where i notice getnstimeofday at top of list.

Additions:
Counted MEMORY_REQUESTS events (Memory requests by type) with a unit mask of 
0x01 (Requests to non-cacheable (UC) memory) count 5000
samples  %        samples  %        symbol name
129      31.0843  596      31.1879  getnstimeofday
54       13.0120  251      13.1345  __napi_schedule
36        8.6747  178       9.3145  default_idle
34        8.1928  164       8.5819  irq_entries_start
23        5.5422  143       7.4830  __do_softirq

and
CPU: AMD64 processors, speed 2193.74 MHz (estimated)
Counted INTERRUPTS_MASKED_CYCLES events (Cycles with interrupts masked (IF=0)) 
with a unit mask of 0x00 (No unit mask) count 5000
samples  %        symbol name
630015   62.4741  getnstimeofday
28634     2.8394  get_next_timer_interrupt
23279     2.3084  __slab_alloc
15775     1.5643  schedule
14765     1.4641  __slab_free
11154     1.1061  native_read_tsc
10953     1.0861  kmem_cache_alloc
10918     1.0827  tick_nohz_stop_sched_tick
10752     1.0662  update_wall_time
10430     1.0343  net_rx_action
10220     1.0134  __do_softirq
9895      0.9812  __update_sched_clock
