Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXDXPGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXDXPGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXDXPGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:06:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:27132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbXDXPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233074958:sNHT28353878"
Date: Fri, 20 Apr 2007 12:26:31 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070420192630.GB5475@linux-os.sc.intel.com>
References: <20070418175017.GA5250@elte.hu> <20070418212645.GU2986@holomorphy.com> <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 12:24:17PM -0700, Christoph Lameter wrote:
> On Wed, 18 Apr 2007, William Lee Irwin III wrote:
> 
> > 
> > Mark the runqueues ____cacheline_aligned_in_smp to avoid false sharing.
> 
> False sharing for a per cpu data structure? Are we updating that 
> structure from other processors?

yes. during a remote process wakeup.
