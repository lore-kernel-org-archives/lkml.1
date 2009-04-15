Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbZDOR17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbZDOR17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZDOR1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:27:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:7912 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZDOR1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MqMm5wqnufyJfcrFa0T47L6C2EzoC5rqfzQ+aIdM3HavawMtPuyOnyeIPKHxd4xMQL
         nhzNpsv1lOfQTkv7NBO48chpsEebe+wT8wqmVn3G4zZGuUJfLMtu/OS97fYU1Da0kshL
         Ya8QDF7FdpkKKiroR3hIly9+TLWsS5eEvF5qA=
MIME-Version: 1.0
In-Reply-To: <a4423d670904150539w1a4fe05ake75ce2aea4538eab@mail.gmail.com>
References: <a4423d670904090536j71be609csf2c32be3ed9cfe1e@mail.gmail.com>
	 <a4423d670904150539w1a4fe05ake75ce2aea4538eab@mail.gmail.com>
Date: Wed, 15 Apr 2009 10:27:48 -0700
X-Google-Sender-Auth: d09a5f216314f0f4
Message-ID: <e9c3a7c20904151027xdf617fbh64fcb5618e195a71@mail.gmail.com>
Subject: Re: 2.6.30-rc1: ioatdma: DMA-API: device driver frees DMA memory with 
	wrong function
From: Dan Williams <dan.j.williams@intel.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, maciej.sosnowski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 5:39 AM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> 2009/4/9 Alexander Beregalov <a.beregalov@gmail.com>:
>> ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> ioatdma 0000:00:08.0: setting latency timer to 64
>> ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine found, 4 channels,
>> device version 0x12, driver version 3.64
>>  alloc irq_desc for 33 on cpu 0 node 0
>>  alloc kstat_irqs on cpu 0 node 0
>> ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
>> ------------[ cut here ]------------
>> WARNING: at lib/dma-debug.c:565 check_unmap+0x2f6/0x6a0()
>> Hardware name: PowerEdge 1950
>> ioatdma 0000:00:08.0: DMA-API: device driver frees DMA memory with
>> wrong function [device address=0x000000007f76f800] [size=2000 bytes]
>> [map
>> ped as single] [unmapped as page]
>
> The problem still persists.

Thanks for the report Alexander.  Maciej and I are looking into a fix.

Regards,
Dan
