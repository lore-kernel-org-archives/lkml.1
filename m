Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXJBE5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXJBE5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 00:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXJBE4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 00:56:51 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:51752 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbXJBE4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 00:56:50 -0400
Message-ID: <4701CF78.5020802@kolumbus.fi>
Date: Tue, 02 Oct 2007 07:56:24 +0300
From: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       David Bahi <dbahi@novell.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710012341.53169.ak@suse.de> <alpine.LFD.0.9999.0710012349160.20478@localhost.localdomain> <200710020007.09864.ak@suse.de> <alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 2 Oct 2007, Andi Kleen wrote:
>   
>>> OTOH, the accounting hook would allow us to remove the IRQ#0 -> CPU#0
>>> restriction. Not sure whether it's worth the trouble.
>>>       
>> Some SIS chipsets hang the machine when you migrate irq 0 to another
>> CPU. It's better to keep that Also I wouldn't be surprised if there are some
>> other assumptions about this elsewhere.
>>
>> Ok in theory it could be done only on SIS, but that probably would really
>> not be worth the trouble
>>     
>
> Agreed.
>
> I just got a x8664-hrt report, where I found the following oddity:
>
>  0:       1197     172881   IO-APIC-edge      timer
>
> That's one of those infamous AMD C1E boxen. Strange, all my systems have 
> IRQ#0 on CPU#0 and nowhere else. Any idea ?
>
> 	tglx
>
>   
Here I have with stock FC7 (2.6.22.9-91) kernel :
 0:     107835  133459760   IO-APIC-edge      timer

Processor:
vendor_id    : AuthenticAMD
cpu family    : 15
model        : 107
model name    : AMD Athlon(tm) 64 X2 Dual Core Processor 4000+
stepping    : 1
cpu MHz        : 2109.721
cache size    : 512 KB

MB:
Asus M2N-E (NF570)

--Mika


