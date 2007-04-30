Return-Path: <linux-kernel-owner+w=401wt.eu-S1946139AbXD3QWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946139AbXD3QWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946108AbXD3QWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:22:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50085 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423577AbXD3QWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:22:19 -0400
Date: Mon, 30 Apr 2007 21:59:59 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       Kasper Sandberg <lkml@metanurb.dk>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070430162959.GF24350@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070428152539.GA21601@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428152539.GA21601@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 05:25:39PM +0200, Ingo Molnar wrote:
> i'm pleased to announce release -v7 of the CFS scheduler patchset. (The 
> main goal of CFS is to implement "desktop scheduling" with as high 
> quality as technically possible.)

+unsigned int sysctl_sched_granularity __read_mostly = 2000000;

Any reason why this tunable can't be 64-bit?

-- 
Regards,
vatsa
