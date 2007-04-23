Return-Path: <linux-kernel-owner+w=401wt.eu-S1161523AbXDWMhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161523AbXDWMhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161526AbXDWMhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:37:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52977 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161523AbXDWMhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:37:11 -0400
Date: Mon, 23 Apr 2007 14:36:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423123658.GA15716@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <3d8471ca0704230520w5f395747v2bfb121f7f891f32@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0704230520w5f395747v2bfb121f7f891f32@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> 2007/4/23, Ingo Molnar <mingo@elte.hu>:
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> +#include "sched_stats.h"
> +#include "sched_rt.c"
> +#include "sched_fair.c"
> +#include "sched_debug.c"
> 
> Index: linux/kernel/sched_stats.h
> ===================================================================
> --- /dev/null
> +++ linux/kernel/sched_stats.h
> 
> These look unnatural if it were to be included in mainline.

agreed - these will likely be separate modules - i just wanted to have 
an easy way of sharing infrastructure between sched.c and these.

	Ingo
