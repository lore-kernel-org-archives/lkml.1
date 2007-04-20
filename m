Return-Path: <linux-kernel-owner+w=401wt.eu-S1767213AbXDTTdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767213AbXDTTdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767223AbXDTTdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:33:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43985 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767213AbXDTTdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:33:23 -0400
Date: Fri, 20 Apr 2007 12:33:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
In-Reply-To: <20070420192906.GB2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com>
References: <20070418175017.GA5250@elte.hu> <20070418212645.GU2986@holomorphy.com>
 <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com>
 <20070420192906.GB2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, William Lee Irwin III wrote:

> On Wed, 18 Apr 2007, William Lee Irwin III wrote:
> >> 
> >> Mark the runqueues ____cacheline_aligned_in_smp to avoid false sharing.
> 
> On Fri, Apr 20, 2007 at 12:24:17PM -0700, Christoph Lameter wrote:
> > False sharing for a per cpu data structure? Are we updating that 
> > structure from other processors?
> 
> Primarily in the load balancer, but also in wakeups.

That is fairly rare I think. What other variables that are also writtten 
frequently would cause false sharing?


