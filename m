Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbXGYMtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbXGYMtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762572AbXGYMt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:49:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXGYMt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:49:26 -0400
Date: Wed, 25 Jul 2007 14:49:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/3] SCHED: Generic hooks for trapping task preemption
Message-ID: <20070725124911.GC6841@elte.hu>
References: <11853673872732-git-send-email-avi@qumranet.com> <11853673871109-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11853673871109-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> This adds a general mechanism whereby a task can request the scheduler 
> to notify it whenever it is preempted or scheduled back in.  This 
> allows the task to swap any special-purpose registers like the fpu or 
> Intel's VT registers.

ok, this looks very clean, i've added it to my scheduler tree. You've 
tested this with KVM, on both 32-bit and 64-bit, correct?

	Ingo
