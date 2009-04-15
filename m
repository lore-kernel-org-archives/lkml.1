Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbZDOMjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbZDOMjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbZDOMjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:39:21 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34843 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbZDOMjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=DN4OHZAfOjZMhr7G5yQMOV7Xstdm20RM48nUi/fV2BRsmFDFrHT8q28/LR6VBTRAwh
         kDCTe878Qt6EAKRovbLzrA1orWtFr1J/aXQ18DDtfGamfi5YiE/Q9fCC+m3mIT0M9a5A
         H6hPALestz7jE66jRLfK3hSP/EYNcG5d3sk78=
MIME-Version: 1.0
In-Reply-To: <a4423d670904090536j71be609csf2c32be3ed9cfe1e@mail.gmail.com>
References: <a4423d670904090536j71be609csf2c32be3ed9cfe1e@mail.gmail.com>
Date: Wed, 15 Apr 2009 16:39:17 +0400
Message-ID: <a4423d670904150539w1a4fe05ake75ce2aea4538eab@mail.gmail.com>
Subject: Re: 2.6.30-rc1: ioatdma: DMA-API: device driver frees DMA memory with 
	wrong function
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com,
       maciej.sosnowski@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/9 Alexander Beregalov <a.beregalov@gmail.com>:
> ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ioatdma 0000:00:08.0: setting latency timer to 64
> ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine found, 4 channels,
> device version 0x12, driver version 3.64
>  alloc irq_desc for 33 on cpu 0 node 0
>  alloc kstat_irqs on cpu 0 node 0
> ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
> ------------[ cut here ]------------
> WARNING: at lib/dma-debug.c:565 check_unmap+0x2f6/0x6a0()
> Hardware name: PowerEdge 1950
> ioatdma 0000:00:08.0: DMA-API: device driver frees DMA memory with
> wrong function [device address=0x000000007f76f800] [size=2000 bytes]
> [map
> ped as single] [unmapped as page]

The problem still persists.
