Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbYGVHIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbYGVHIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYGVHHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:07:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52123 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbYGVHHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:07:53 -0400
Date: Tue, 22 Jul 2008 09:07:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
Message-ID: <20080722070734.GA16085@elte.hu>
References: <200807211836.27282.yhlu.kernel@gmail.com> <200807212208.22116.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807212208.22116.yhlu.kernel@gmail.com>
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

> so remove uv, x2apic related code from genapic_64.c to their specific 
> genapic files
> 
> v2: fix compiling when CONFIG_ACPI is not set

applied to tip/x86/x2apic - thanks Yinghai.

> +static struct genapic *apic_probe[] __initdata = {
> +	&apic_x2apic_uv_x,
> +	&apic_x2apic_phys,
> +	&apic_x2apic_cluster,
> +	&apic_physflat,
> +	NULL,
> +};

very nice generalization!

	Ingo
