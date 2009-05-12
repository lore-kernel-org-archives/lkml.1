Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbZELKdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbZELKdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZELKdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:33:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZELKde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:33:34 -0400
Date: Tue, 12 May 2009 12:32:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce io_apic_irq_attr -v2
Message-ID: <20090512103236.GC11714@elte.hu>
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org> <20090511082834.GD5636@elte.hu> <4A087F35.2000903@kernel.org> <20090511213755.GB21232@elte.hu> <4A08ACD3.2070401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A08ACD3.2070401@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> +				irq_attr->ioapic     = apic;
> +				irq_attr->ioapic_pin = mp_irqs[i].dstirq;
> +				irq_attr->trigger    = irq_trigger(i);
> +				irq_attr->polarity   = irq_polarity(i);

> +				irq_attr->ioapic     = apic;
> +				irq_attr->ioapic_pin = mp_irqs[i].dstirq;
> +				irq_attr->trigger    = irq_trigger(i);
> +				irq_attr->polarity   = irq_polarity(i);

Shouldnt this be factored out ino a helper function?

	Ingo
