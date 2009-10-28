Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZJ1Hb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZJ1Hb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932602AbZJ1Hb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:31:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbZJ1Hbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:31:55 -0400
Date: Wed, 28 Oct 2009 08:31:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-ID: <20091028073145.GD6353@elte.hu>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028181443.50a09dbb.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> In file included from arch/x86/include/asm/smp.h:13,
>                  from arch/x86/include/asm/mmzone_64.h:12,
>                  from arch/x86/include/asm/mmzone.h:4,
>                  from include/linux/mmzone.h:783,
>                  from include/linux/gfp.h:4,
>                  from include/linux/kmod.h:22,
>                  from include/linux/module.h:13,
>                  from arch/x86/kernel/apic/apic_noop.c:14:
> arch/x86/include/asm/apic.h: In function 'default_apicid_to_cpu_present':
> arch/x86/include/asm/apic.h:591: warning: the frame size of 8192 bytes is larger than 2048 bytes
> 
> It may not have been caused by the tip tree, but I can't find what 
> changed to cause this and a commit from the tip tree has exposed it 
> (9844ab11c763bfed9f054c82366b19dcda66aca9 "x86, apic: Introduce the 
> NOOP apic driver").

That commit is very simple. Are you sure it's not GCC bogosity?

	Ingo
