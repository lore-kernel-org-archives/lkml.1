Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZANIBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZANIBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZANIBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:01:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZANIBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:01:30 -0500
Date: Wed, 14 Jan 2009 09:01:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@home.goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: fix build error in kernel/sched_rt.c when
	RT_GROUP_SCHED && !SMP
Message-ID: <20090114080111.GC18649@elte.hu>
References: <20090113014333.GA23448@elte.hu> <20090113023345.32433.28954.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113023345.32433.28954.stgit@dev.haskins.net>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> +#define dec_rt_group(rt_se, rt_rq) do { } while (0)

Please dont _ever_ introduce new CPP macros into core kernel code, and if 
you see existing once, please fix them to be proper C inline functions. 
(there's a few other new macros in your patchset)

	Ingo
