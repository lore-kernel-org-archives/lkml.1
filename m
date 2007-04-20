Return-Path: <linux-kernel-owner+w=401wt.eu-S2993117AbXDTTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993117AbXDTTik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993319AbXDTTik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:38:40 -0400
Received: from holomorphy.com ([66.93.40.71]:49017 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993117AbXDTTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:38:40 -0400
Date: Fri, 20 Apr 2007 12:38:56 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070420193856.GC2986@holomorphy.com>
References: <20070418175017.GA5250@elte.hu> <20070418212645.GU2986@holomorphy.com> <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com> <20070420192906.GB2986@holomorphy.com> <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, Apr 20, 2007 at 12:24:17PM -0700, Christoph Lameter wrote:
>>> False sharing for a per cpu data structure? Are we updating that 
>>> structure from other processors?

On Fri, 20 Apr 2007, William Lee Irwin III wrote:
>> Primarily in the load balancer, but also in wakeups.

On Fri, Apr 20, 2007 at 12:33:13PM -0700, Christoph Lameter wrote:
> That is fairly rare I think. What other variables that are also writtten 
> frequently would cause false sharing?

I wrote that backward, sorry. Cross-CPU wakeups' frequency depend
heavily on the workload. Probably the only other case I can think of
is io_schedule() but that's not really significant.

I'm not really convinced it's all that worthwhile of an optimization,
essentially for the same reasons as you, but presumably there's a
benchmark result somewhere that says it matters. I've just not seen it.


-- wli
