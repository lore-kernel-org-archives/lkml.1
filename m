Return-Path: <linux-kernel-owner+w=401wt.eu-S1030853AbXDTTYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853AbXDTTYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030977AbXDTTYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:24:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43382 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030853AbXDTTYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:24:20 -0400
Date: Fri, 20 Apr 2007 12:24:17 -0700 (PDT)
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
In-Reply-To: <20070418212645.GU2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com>
References: <20070418175017.GA5250@elte.hu> <20070418212645.GU2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, William Lee Irwin III wrote:

> 
> Mark the runqueues ____cacheline_aligned_in_smp to avoid false sharing.

False sharing for a per cpu data structure? Are we updating that 
structure from other processors?
