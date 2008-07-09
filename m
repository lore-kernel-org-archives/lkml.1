Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYGIIpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYGIIpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYGIIpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:45:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYGIIpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:45:33 -0400
Date: Wed, 9 Jul 2008 10:45:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: not overmap than end in init_memory_mapping -
	64bit
Message-ID: <20080709084512.GA4694@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <20080709073844.GB30428@elte.hu> <20080709083425.GA23952@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709083425.GA23952@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > applied to tip/x86/core, thanks Yinghai.
> 
> found an early boot crash on a testbox:

ah - this crash gets fixed by the "x86: make max_pfn cover acpi table 
below 4g" RFC fix you posted in the other thread.

So the overmapping change made the problem more prominent. (But the 
problem was pre-existing with certain memory layouts - as witnessed by 
the other thread.)

I've flipped around these two commits to help bisection.

	Ingo
