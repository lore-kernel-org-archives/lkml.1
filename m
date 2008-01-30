Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbYA3Phl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbYA3Phl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYA3Phc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:37:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41099 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbYA3Phb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:37:31 -0500
Date: Wed, 30 Jan 2008 16:37:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix x86_64 duplicated TIF
Message-ID: <20080130153719.GA10709@elte.hu>
References: <20080130145059.GA13000@Krystal> <20080130145549.GA13588@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130145549.GA13588@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> I wonder if this is expected ? (in current 2.6.24-git)
> 
> commit 7e9916040b3020d0f36d68bb7512e3b80b623097
> and commit eee3af4a2c83a97fff107ddc445d9df6fded9ce4
> 
> Both use the same TIF number (25) in thread_info_64.h.

>  #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
> -#define TIF_DS_AREA_MSR	25      /* uses thread_struct.ds_area_msr */
> -#define TIF_BTS_TRACE_TS	26      /* record scheduling event timestamps */
> +#define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
> +#define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */

thanks, applied.

	Ingo
