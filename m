Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbZDQMB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbZDQMB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZDQMBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:01:15 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50856 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZDQMBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VS8mvqOpwrIwtGGV464lertiwXg707Llj+i760f0lStKEyh4nK3TOrru/T/o4ZFbtk
         vfA00d4mkEWFT67TYK9OY482oN1rYjGhAoq2aPV6xoihbTSlcCnabYy/M6o6/mrLTIPB
         6DIoe75TPCXmqGJEJutJ+WpAzrLfNSsclpt4w=
MIME-Version: 1.0
In-Reply-To: <129600E5E5FB004392DDC3FB599660D792A39C27@irsmsx504.ger.corp.intel.com>
References: <a4423d670904090536j71be609csf2c32be3ed9cfe1e@mail.gmail.com>
	 <a4423d670904150539w1a4fe05ake75ce2aea4538eab@mail.gmail.com>
	 <e9c3a7c20904151027xdf617fbh64fcb5618e195a71@mail.gmail.com>
	 <129600E5E5FB004392DDC3FB599660D792A39C27@irsmsx504.ger.corp.intel.com>
Date: Fri, 17 Apr 2009 16:01:06 +0400
Message-ID: <a4423d670904170501l7cf935a6mf8dbe69e166b8099@mail.gmail.com>
Subject: Re: 2.6.30-rc1: ioatdma: DMA-API: device driver frees DMA memory with 
	wrong function
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/17 Sosnowski, Maciej <maciej.sosnowski@intel.com>:
> Dan Williams wrote:
>> On Wed, Apr 15, 2009 at 5:39 AM, Alexander Beregalov
>> <a.beregalov@gmail.com> wrote:
>>> 2009/4/9 Alexander Beregalov <a.beregalov@gmail.com>:
>>>> ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>>> ioatdma 0000:00:08.0: setting latency timer to 64
>>>> ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine found, 4 channels,
>>>> device version 0x12, driver version 3.64
>>>>  alloc irq_desc for 33 on cpu 0 node 0
>>>>  alloc kstat_irqs on cpu 0 node 0
>>>> ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
>>>> ------------[ cut here ]------------
>>>> WARNING: at lib/dma-debug.c:565 check_unmap+0x2f6/0x6a0()
>>>> Hardware name: PowerEdge 1950
>>>> ioatdma 0000:00:08.0: DMA-API: device driver frees DMA memory with
>>>> wrong function [device address=0x000000007f76f800] [size=2000 bytes] [map
>>>> ped as single] [unmapped as page]
>>>
>>> The problem still persists.
>>
>> Thanks for the report Alexander.  Maciej and I are looking into a fix.
>>
>> Regards,
>> Dan
>
> Hi Alexander,
>
> Could you check if the following patch helps?

Hi Maciej.

No, unfortunately it does not help. The same warning message.
