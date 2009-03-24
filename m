Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbZCXKel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbZCXKel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZCXKec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:34:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbZCXKeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:34:31 -0400
Date: Tue, 24 Mar 2009 11:34:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
Message-ID: <20090324103417.GA30579@elte.hu>
References: <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop> <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop> <20090324091742.GB6605@elte.hu> <1237886559.25315.60.camel@penberg-laptop> <20090324093103.GA19463@elte.hu> <20090324093424.GA26935@elte.hu> <20090324094605.GA20937@elte.hu> <20090324101232.GA26228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090324101232.GA26228@elte.hu>
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


64-bit defconfig:

In file included from include/linux/slub_def.h:14,
                 from include/linux/slab.h:154,
                 from include/linux/percpu.h:6,
                 from include/linux/rcutree.h:37,
                 from include/linux/rcupdate.h:61,
                 from include/linux/tracepoint.h:19,
                 from include/linux/module.h:20,
                 from include/linux/crypto.h:22,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:5:
include/trace/kmemtrace.h:24: error: expected ‘)’ before ‘(’ token
include/trace/kmemtrace.h:31: error: expected ‘)’ before ‘(’ token
include/trace/kmemtrace.h:38: error: expected ‘)’ before ‘(’ token
include/trace/kmemtrace.h:46: error: expected ‘)’ before ‘(’ token
include/trace/kmemtrace.h:54: error: expected ‘)’ before ‘(’ token
include/trace/kmemtrace.h:57: error: expected ‘)’ before ‘(’ token
In file included from include/linux/slab.h:154,
                 from include/linux/percpu.h:6,
                 from include/linux/rcutree.h:37,
                 from include/linux/rcupdate.h:61,
                 from include/linux/tracepoint.h:19,
                 from include/linux/module.h:20,
                 from include/linux/crypto.h:22,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:5:
include/linux/slub_def.h: In function ‘kmalloc_large’:
include/linux/slub_def.h:236: error: implicit declaration of function ‘trace_kmalloc’
include/linux/slub_def.h: In function ‘kmalloc_node’:
include/linux/slub_def.h:296: error: implicit declaration of function ‘trace_kmalloc_node’
3.65user 0.62system 0:02.86elapsed 149%CPU (0avgtext+0avgdata 0maxresident)k

