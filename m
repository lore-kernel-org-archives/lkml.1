Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYIHEiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYIHEiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 00:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYIHEiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 00:38:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:2260 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYIHEiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 00:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MjkKtF/r0xidm/wqLfNf/bp+zCg1lP1Ug+vpntg78cqquwG7pDpwmfHleZyu4Zpbc9
         cPucD/OEBcxOLMnqZ/AXPDwYYGKR2HIZdYMHA6wEdj8KrtfU+x0PE91XGrhVjA3sTbjr
         qRkSfc6xzoqXtoAg7HcG8nmZ8rN7ABrqTZQuE=
Message-ID: <86802c440809072138u19ac9beax183d4e69c3a895ee@mail.gmail.com>
Date: Sun, 7 Sep 2008 21:38:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
Cc: "Ingo Molnar" <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, macro@linux-mips.org
In-Reply-To: <aa79d98a0809072120y388ecd17vf461c98dd788f983@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080904183748.950151853@gmail.com>
	 <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo>
	 <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo>
	 <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo>
	 <20080906131217.GA4910@elte.hu>
	 <86802c440809071724i35a1e26frb01c401bee693ad@mail.gmail.com>
	 <aa79d98a0809072120y388ecd17vf461c98dd788f983@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 9:20 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Mon, Sep 8, 2008 at 4:24 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Sat, Sep 6, 2008 at 6:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>
>>>> By changing printout form we are able to shrink code a bit.
>>>>
>>>> Former printout example:
>>>>
>>>>       init IO_APIC IRQs
>>>>        IO-APIC (apicid-pin) 1-1, 1-2, 1-3 not connected.
>>>>        IO-APIC (apicid-pin) 2-1, 2-2, 2-3 not connected.
>>>>
>>>> New printout example:
>>>>
>>>>       init IO_APIC IRQs
>>>>        1-1 1-2 1-3 (apicid-pin) not connected
>>>>        2-1 2-2 2-3 (apicid-pin) not connected
>>>
>>> applied to tip/irq/sparseirq - thanks Cyrill.
>>
>> got
>>  0-16<7> 0-17<7> 0-18<7> 0-19<7> 0-20<7> 0-21<7> 0-22<7> 0-23<7>
>> (apicid-pin) not connected
>>  1-0<7> 1-1<7> 1-2<7> 1-3<7> 1-4<7> 1-5<7> 1-6<7> 1-7<7> 1-8<7> 1-9<7>
>> 1-10<7> 1-11<7> 1-12<7> 1-13<7> 1-14<7> 1-15<7> 1-16<7> 1-17<7>
>> 1-18<7> 1-19<7> 1-20<7> 1-21<7> 1-22<7> 1-23<7> (apicid-pin) not
>> connected
>>
>> can you remove the extra <7>?
>>
>> YH
>>
>
> Btw Yinghai, do you really have a machine with that many unconnected pins?

Yes

recent change in sparseirq, we only init irq [0,16) at that point. so
pins on other io apic controller all unconnected...

YH
