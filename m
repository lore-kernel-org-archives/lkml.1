Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966190Ab0B0Lfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 06:35:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46849 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965891Ab0B0Lfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 06:35:36 -0500
Date: Sat, 27 Feb 2010 12:35:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Enable NMI on all cpus on UV
Message-ID: <20100227113529.GA21756@elte.hu>
References: <20100217165049.GA26331@sgi.com>
 <20100222103853.GA14522@elte.hu>
 <20100225172447.GC27785@sgi.com>
 <20100226092252.GJ15885@elte.hu>
 <20100226164912.GA24439@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226164912.GA24439@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> Attached is a patch that cleans up Ingo's nits.

Applied, thanks Russ!

>  		nodeid = early_get_nodeid();
>  		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
> +		x86_platform.nmi_init =  uv_nmi_init;

I did a "s/ / /" here.

	Ingo
