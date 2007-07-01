Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXGAJE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXGAJE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 05:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXGAJEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 05:04:21 -0400
Received: from 1wt.eu ([62.212.114.60]:3238 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbXGAJEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 05:04:20 -0400
Date: Sun, 1 Jul 2007 11:00:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070701090029.GB19045@1wt.eu>
References: <20070622220202.GA16872@elte.hu> <20070630210649.GA13186@1wt.eu> <20070701083102.GA4499@elte.hu> <20070701084501.GA10548@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701084501.GA10548@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Jul 01, 2007 at 10:45:01AM +0200, Ingo Molnar wrote:
> could you check whether your current v18 CFS tree has the fix below 
> included? I discovered it right after having released v18 so i updated 
> the v18 files in place - but maybe you downloaded an early version? I 
> thought it's relatively harmless, that it would only affect SCHED_IDLE 
> tasks, but maybe it affects nice +19 tasks too on your box!

Good catch, it was the cause of the problem. I've just applied
your fix below and rebuilt and the system behaves perfectly now.

Thanks very much !
Willy

