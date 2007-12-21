Return-Path: <linux-kernel-owner+w=401wt.eu-S1765180AbXLUAGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765180AbXLUAGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759647AbXLUAGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:06:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51174 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbXLUAGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:06:01 -0500
Date: Fri, 21 Dec 2007 01:05:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071221000534.GA5128@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org> <20071220234759.GA29776@elte.hu> <20071220160203.f940f088.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220160203.f940f088.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 21 Dec 2007 00:47:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > it needs to be found out why the preempt_count suddenly went to zero. Is 
> > task struct corruption out of question?
> 
> Strictly we shouldn't care - we _know_ we've already hit a kernel bug 
> and who knows, perhaps that buggy code did an unbalanced 
> preempt_disable().  So make the oops code more robust.
> 
> otoh, we don't want to be hiding a bug.  What piece of code guarantees 
> that we ender the oops code with preemption disabled?

i looked at the patch you sent - and there the proof was in the sections 
i quoted.

	Ingo
