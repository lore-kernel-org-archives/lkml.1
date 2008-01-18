Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYARIIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYARIIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYARIII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:08:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44094 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYARIIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:08:07 -0500
Date: Fri, 18 Jan 2008 09:07:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: remove redundant cpu_has_ definitions
Message-ID: <20080118080749.GA16597@elte.hu>
References: <20080118045921.GB974@phobos.i.cabal.ca> <47903376.9050204@zytor.com> <20080118052522.GA1726@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118052522.GA1726@phobos.i.cabal.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Kyle McMartin <kyle@mcmartin.ca> wrote:

> --- a/include/asm-x86/cpufeature.h
> +++ b/include/asm-x86/cpufeature.h
> @@ -195,21 +195,6 @@
>  #undef  cpu_has_centaur_mcr
>  #define cpu_has_centaur_mcr	0
>  
> -#undef  cpu_has_pse
> -#define cpu_has_pse		1
> -
> -#undef  cpu_has_pge
> -#define cpu_has_pge		1
> -
> -#undef  cpu_has_xmm
> -#define cpu_has_xmm		1
> -
> -#undef  cpu_has_xmm2
> -#define cpu_has_xmm2		1
> -
> -#undef  cpu_has_fxsr
> -#define cpu_has_fxsr		1
> -

thanks, applied.

	Ingo
