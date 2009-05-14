Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZENT1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZENT1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZENT1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:27:25 -0400
Received: from www.tglx.de ([62.245.132.106]:45788 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZENT1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:27:24 -0400
Date: Thu, 14 May 2009 21:26:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] sched, timers: simplify calc_load and avoid cpu
 iteration loop
In-Reply-To: <20090514172328.GA25691@sgi.com>
Message-ID: <alpine.LFD.2.00.0905142126040.3561@localhost.localdomain>
References: <20090514105915.973318588@linutronix.de> <20090514172328.GA25691@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Dimitri Sivanich wrote:

> I ran this patchset on a 64p ia64 machine and latency-wise it looks good.  I can't really speak for the loadavg calculation.

I did some comparisons vs. the old implementation and it looks pretty
much the same. Thanks for testing,

     tglx
