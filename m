Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZATHZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZATHZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZATHZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:25:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41850 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZATHZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:25:12 -0500
Date: Tue, 20 Jan 2009 08:24:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH] cpuset: fix possible deadlock in
	async_rebuild_sched_domains
Message-ID: <20090120072451.GB16426@elte.hu>
References: <497540BE.4070408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497540BE.4070408@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3245]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miao Xie <miaox@cn.fujitsu.com> wrote:

> Lockdep reported some possible circular locking info when we tested 
> cpuset on NUMA/fake NUMA box.

I have applied your original patch to tip/sched/urgent two days ago, 
thanks!

	Ingo
