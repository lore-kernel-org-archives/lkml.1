Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZELPRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZELPRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZELPRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:17:10 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:50830 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZELPRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BN21xFO9Ly0pqcOxnHNo9twYklDnqPU6nW2fFmPyK0jA1biW6u786dQcVXxrsSYrHG
         6/vavlKvVM3yFSJ7picy+668g8MgYNzMQCDK7yRFL2oY7fMiYnJ2X/HTFwCro8lqxel3
         mCbo9XQkgrkuAoXzGTtCcwstcqudVRvpRoGqM=
MIME-Version: 1.0
In-Reply-To: <20090512103236.GC11714@elte.hu>
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org>
	 <20090511082834.GD5636@elte.hu> <4A087F35.2000903@kernel.org>
	 <20090511213755.GB21232@elte.hu> <4A08ACD3.2070401@kernel.org>
	 <20090512103236.GC11714@elte.hu>
Date: Tue, 12 May 2009 08:17:07 -0700
Message-ID: <86802c440905120817j5d102aa2i43e7d8f8f8ba10b2@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce io_apic_irq_attr -v2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 3:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> +                             irq_attr->ioapic     = apic;
>> +                             irq_attr->ioapic_pin = mp_irqs[i].dstirq;
>> +                             irq_attr->trigger    = irq_trigger(i);
>> +                             irq_attr->polarity   = irq_polarity(i);
>
>> +                             irq_attr->ioapic     = apic;
>> +                             irq_attr->ioapic_pin = mp_irqs[i].dstirq;
>> +                             irq_attr->trigger    = irq_trigger(i);
>> +                             irq_attr->polarity   = irq_polarity(i);
>
> Shouldnt this be factored out ino a helper function?
>
set_io_apic_irq_attr()?

YH
