Return-Path: <linux-kernel-owner+w=401wt.eu-S932636AbXB0KQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbXB0KQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932851AbXB0KQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:16:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbXB0KQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:16:10 -0500
Date: Tue, 27 Feb 2007 11:08:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 04/26] Xen-paravirt_ops: Add pagetable accessors to pack and unpack pagetable entries
Message-ID: <20070227100850.GA10827@elte.hu>
References: <20070227081337.434798469@goop.org> <20070227081630.311681690@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227081630.311681690@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.1.7
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4016]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> ===================================================================
> --- a/arch/i386/kernel/vmlinux.lds.S
> +++ b/arch/i386/kernel/vmlinux.lds.S
> @@ -21,6 +21,9 @@
>  #include <asm/page.h>
>  #include <asm/cache.h>
>  #include <asm/boot.h>
> +
> +#undef ENTRY
> +#undef ALIGN

hm, what's this? The reason is not documented.

> +#ifdef CONFIG_PARAVIRT
> +/* After pte_t, etc, have been defined */
> +#include <asm/paravirt.h>
> +#endif

hm - there's already a CONFIG_PARAVIRT conditional in 
asm-i386/paravirt.h.

	Ingo
