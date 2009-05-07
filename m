Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbZEGQz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbZEGQz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZEGQzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:55:12 -0400
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:56643 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751845AbZEGQzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:55:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VU5NzCk6c/6/GwoQctYAePd6Kq54E4CIcwwXprVdFgH9Q7B/iBJyBK0dVFdrSrKD9tTaDkdG1JLUhLLMt7KHQ4gc9vLnkvOlLw+GE/xXAvgsP8NvKZ/CEXagUwYaR7yn;
Date: Thu, 7 May 2009 09:52:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 7/7] x86/pci: update pirq_enable_irq to setup io apic
 routing -v2
Message-ID: <20090507095256.7f87fb42@jbarnes-g45>
In-Reply-To: <20090507141222.GI481@elte.hu>
References: <4A01C35C.7060207@kernel.org>
	<4A01C46E.8000501@kernel.org>
	<20090507141222.GI481@elte.hu>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 16:12:22 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > 
> > so we could set io apic routing only when enable device irq.
> > 
> > also could make setup_IO_APIC_irqs and setup_ioapic_dest only handle
> > first ioapic...
> > 
> > v2: remove one one not needed style change.
> >     merge the patch only setup io_apic for acpi on in
> > setup_IO_APIC_irqs
> > 
> > [ Impact: make mptable irq enable more like acpi is used, and
> > numa_irq_desc could get correct node when acpi=off ]
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/kernel/apic/io_apic.c |  148
> > ++++++++++++++++++++---------------------
> > arch/x86/pci/irq.c             |   84 ++++++++--------------- 2
> > files changed, 103 insertions(+), 129 deletions(-)
> 
> Jesse, did this patch have your Acked-by?

Yeah, both of them are fine with me.  Ultimately you get to keep any
broken pieces from io_apic changes anyway, right? :)

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
