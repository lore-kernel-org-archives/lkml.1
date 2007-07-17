Return-Path: <linux-kernel-owner+w=401wt.eu-S934312AbXGQTWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbXGQTWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXGQTWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:22:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35371 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbXGQTWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:22:40 -0400
Date: Tue, 17 Jul 2007 21:22:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/sched.c: remove 2 unused exports
Message-ID: <20070717192233.GG26283@elte.hu>
References: <20070712235211.GS3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712235211.GS3492@stusta.de>
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


* Adrian Bunk <bunk@stusta.de> wrote:

> This patch removes the following unused exports:
> - EXPORT_SYMBOL(cond_resched_softirq);
> - EXPORT_SYMBOL_GPL(__wake_up_sync);

these are there for API completeness - their counterparts are exported.

	Ingo
