Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYGCNyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYGCNyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYGCNyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:54:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYGCNye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:54:34 -0400
Date: Thu, 3 Jul 2008 15:54:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: move prefill_possible_map calling early
Message-ID: <20080703135421.GA7603@elte.hu>
References: <200806301834.59156.yhlu.kernel@gmail.com> <200807021851.02301.yinghai.lu@sun.com> <200807021854.40729.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807021854.40729.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> call it right after we done with MADT/mptable handling, instead of 
> doing that in setup_per_cpu_areas later... so for_possible_cpu could 
> be used early.

applied to tip/x86/unify-setup - thanks Yinghai,

	Ingo
