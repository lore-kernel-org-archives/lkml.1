Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYFSJ67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYFSJ67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYFSJ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:58:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40197 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYFSJ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:58:49 -0400
Date: Thu, 19 Jun 2008 11:58:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] typo CONFIX -> CONFIG
Message-ID: <20080619095830.GE15228@elte.hu>
References: <1213657148-5263-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213657148-5263-1-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> ---
>  arch/x86/kernel/nmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 07cf17f..3775463 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -69,7 +69,7 @@ static inline unsigned int get_nmi_count(int cpu)
>  
>  static inline int mce_in_progress(void)
>  {
> -#if defined(CONFIX_X86_64) && defined(CONFIG_X86_MCE)
> +#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)

applied to tip/x86/nmi - thanks Glauber. [ Someone's been reading too 
many Goscinny comics ;) ]

	Ingo
