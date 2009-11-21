Return-Path: <linux-kernel-owner+w=401wt.eu-S1751606AbZKUIJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbZKUIJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 03:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZKUIJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 03:09:41 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53886 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZKUIJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 03:09:40 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911182141060.24119@localhost.localdomain>
References: <20091117224852.846805939@linutronix.de> <20091117224916.566205413@linutronix.de> 
	<20091118175523.GA12857@b07421-ec1.am.freescale.net> <alpine.LFD.2.00.0911182141060.24119@localhost.localdomain>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 21 Nov 2009 01:01:41 -0700
X-Google-Sender-Auth: 4c53110d82234d84
Message-ID: <fa686aa40911210001u699031a0h2b3818b68c212d69@mail.gmail.com>
Subject: Re: [patch 06/13] powerpc: Fixup last users of irq_chip->typename
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Scott Wood <scottwood@freescale.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 1:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 18 Nov 2009, Scott Wood wrote:
>> On Tue, Nov 17, 2009 at 10:50:53PM +0000, Thomas Gleixner wrote:
>> > Index: linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
>> > ===================================================================
>> > --- linux-2.6.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
>> > +++ linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
>> > @@ -69,7 +69,7 @@ static void pq2ads_pci_unmask_irq(unsign
>> >  }
>> >
>> >  static struct irq_chip pq2ads_pci_ic = {
>> > -   .typename = "PQ2 ADS PCI",
>> > +   .name = "PQ2 ADS PCI",
>> >     .name = "PQ2 ADS PCI",
>> >     .end = pq2ads_pci_unmask_irq,
>> >     .mask = pq2ads_pci_mask_irq,
>>
>> Duplicate ".name"...
>
> Darn.

Other than that, looks good to me.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
