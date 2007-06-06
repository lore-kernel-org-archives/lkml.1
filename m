Return-Path: <linux-kernel-owner+w=401wt.eu-S1764241AbXFFLcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764241AbXFFLcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXFFLce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:32:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34612 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXFFLce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:32:34 -0400
Date: Wed, 6 Jun 2007 13:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: maximilian attems <max@stro.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] Kconfig.debug DEBUG_PREEMPT dependency
Message-ID: <20070606113227.GA2373@elte.hu>
References: <20070606105314.GD32083@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606105314.GD32083@stro.at>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* maximilian attems <max@stro.at> wrote:

> allow to set DEBUG_PREEMPT on PREEMPT_BKL, but !PREEMPT purpose is to 
> get bonus of debug_smp_processor_id().

hm, have you tested this? In the case of !PREEMPT there will be _lots_ 
of places that use smp_processor_id() but where the preempt_count() wont 
be elevated - causing false positive warnings.

	Ingo
