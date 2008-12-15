Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYLOHIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYLOHIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 02:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYLOHIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 02:08:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35750 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYLOHIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 02:08:00 -0500
Message-ID: <49460249.8020801@jp.fujitsu.com>
Date: Mon, 15 Dec 2008 16:07:53 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: MSI messages
References: <49438290.1080502@gmail.com> <20081214081210.GC13371@colo.lackof.org>
In-Reply-To: <20081214081210.GC13371@colo.lackof.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Sat, Dec 13, 2008 at 01:38:24PM +0400, Manu Abraham wrote:
>> Hi,
>>
>> I am wondering how to handle this:
>>
>> Does the kernel somehow handle MSI message readback from the PCI config space 
>> for the MSI message as described in 6.8.1 of the PCI Bus specification 2.3 or 
>> does a device specific driver have to read the Message Address and Data ?
>>
>> To put it short: i am wondering how i should read the MSI messages.
> 
> The "message" is actually mapped to an the interrupt vector by the core
> generic interrupt handling code in the kernel.
> 
> A "GSI" (Generic Sys Interrupt?) is associated with each entry in
> the MSI-X table. Driver then calls request_irq() to bind an interrupt
> handler to each GSI. So the driver never directly sees the "message".
> 

I think "GSI (Global System Interrupt)" is for identifying the I/O
APIC pin among multiple I/O APICs. Maybe you wanted to mean the
interrupt number managed by kernel (frequently called "IRQ")?
Or am I misunderstanding something?

Thanks,
Kenji Kaneshige

