Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZHQImY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZHQImY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZHQImX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:42:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389AbZHQImW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:42:22 -0400
Date: Mon, 17 Aug 2009 10:42:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Reinhard Tartler <siretart@tauware.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix typo
	s/CONFIG_CPU_HOTPLUG/CONFIG_HOTPLUG_CPU/
Message-ID: <20090817084201.GA5877@elte.hu>
References: <rwuzl9y975c.fsf@faui48a.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rwuzl9y975c.fsf@faui48a.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Reinhard Tartler <siretart@tauware.de> wrote:

> In ./arch/*/Kconfig, this Kconfig symbol is defined as 
> HOTPLUG_CPU, and never as CPU_HOTPLUG
> 
> Signed-off-by: Reinhard Tartler <siretart@tauware.de>
> ---
>  kernel/smp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index ad63d85..94188b8 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -57,7 +57,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  			return NOTIFY_BAD;
>  		break;
>  
> -#ifdef CONFIG_CPU_HOTPLUG
> +#ifdef CONFIG_HOTPLUG_CPU
>  	case CPU_UP_CANCELED:
>  	case CPU_UP_CANCELED_FROZEN:

Already fixed upstream by:

69dd647: generic-ipi: fix hotplug_cfd()

	Ingo
