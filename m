Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYGZLQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYGZLQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 07:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYGZLQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 07:16:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36239 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbYGZLQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 07:16:39 -0400
Date: Sat, 26 Jul 2008 13:16:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Jason Yeh <jason.yeh@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Oprofile Multiplexing Patch
Message-ID: <20080726111626.GL25890@elte.hu>
References: <1216847153-28435-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216847153-28435-2-git-send-email-robert.richter@amd.com>
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


> From: Jason Yeh <jason.yeh@amd.com>

> diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
> index 56b4757..e641545 100644
> --- a/arch/x86/oprofile/op_model_p4.c
> +++ b/arch/x86/oprofile/op_model_p4.c
> @@ -701,6 +701,8 @@ static void p4_shutdown(struct op_msrs const * const msrs)
>  struct op_x86_model_spec const op_p4_ht2_spec = {
>  	.num_counters = NUM_COUNTERS_HT2,
>  	.num_controls = NUM_CONTROLS_HT2,
> +	.num_hardware_counters = NUM_COUNTERS_HT2,
> +	.num_hardware_controls = NUM_CONTROLS_HT2,

is there any further change needed for Intel CPUs to benefit from 
multiplexing too, up to the max of 32 controls? (AFAICS it should work 
as-is, correct?)

	Ingo
