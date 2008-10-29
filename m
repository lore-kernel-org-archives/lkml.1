Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYJ2Kx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYJ2Kx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYJ2Kxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:53:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYJ2Kxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:53:50 -0400
Date: Wed, 29 Oct 2008 11:53:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: cleanup for alloc_rt/fair_sched_group()
Message-ID: <20081029105342.GB15981@elte.hu>
References: <490826DA.2060802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490826DA.2060802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Remove checking parent == NULL. It won't be NULLL, because we dynamically
> create sub task_group only, and sub task_group always has its parent.
> (root task_group is statically defined)
> 
> Also replace kmalloc_node(GFP_ZERO) with kzalloc_node().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |   26 ++++++++++++--------------
>  1 files changed, 12 insertions(+), 14 deletions(-)

applied to tip/sched/core, thanks!

	Ingo
