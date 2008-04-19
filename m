Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbYDSMdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbYDSMdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 08:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYDSMdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 08:33:07 -0400
Received: from mail-gw3.adaptec.com ([162.62.93.58]:46204 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbYDSMdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 08:33:05 -0400
Cc: "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Message-Id: <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: aacraid broken in git
Date: Sat, 19 Apr 2008 08:33:02 -0400
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is ACPI disabling the interrupt? Maybe do bisects on the ACPI  
subsystem as well.

Sincerely -- Mark Salyzyn

On Apr 18, 2008, at 9:55 PM, Yinghai Lu wrote:

> 4/18 2.6-git got
>
> Calling initcall 0xffffffff80f10f97: aac_init+0x0/0x95()
> Adaptec aacraid driver 1.1-5[2455]-ms
> ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNEB] -> GSI 18 (level,  
> low) -> IRQ
> 18
> PCI: Enabling bus mastering for device 0000:04:00.0
> PCI: Setting latency timer of device 0000:04:00.0 to 64
> AAC0: kernel 5.2-0[15594]
> AAC0: monitor 5.2-0[15594]
> AAC0: bios 5.2-0[15594]
> AAC0: serial AA0009
> AAC0: Non-DASD support enabled.
> AAC0: 64bit support enabled.
> AAC0: 64 Bit DAC enabled
> aac_fib_free, XferState != 0, fibptr = 0xffff8108232e0000, XferState  
> = 0x810ad
> ACPI: PCI interrupt for device 0000:04:00.0 disabled
> aacraid: probe of 0000:04:00.0 failed with error -4
> initcall 0xffffffff80f10f97: aac_init+0x0/0x95() returned 0.
> initcall 0xffffffff80f10f97 ran for 286 msecs: aac_init+0x0/0x95()
>
>
> Linux LBSuse 2.6.25-x86-latest.git-01659-g1f8551e #106 SMP Fri Apr 18
> 18:24:39 PDT 2008 x86_64 x86_64 x86_64 GNU/Linux
>
> YH

