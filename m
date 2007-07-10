Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXGJSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXGJSlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762076AbXGJSlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:41:35 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:64067 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763170AbXGJSle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tE3Osy6n2qaPZbQic94bOAw2hhIxUSmm7BmCsaH4QxUPL0Q5rTVkIi32P9XwIT6XawnhlF3d+klagQ57tltnGTUSU2OCiOOJUAn0judCMZa21yjk/EGRmvByN6lorSuhUEX9x6vas26Hc/6uZOX1jRB0Q/Nuv1BV1nBzOOCJFcQ=
Message-ID: <e9c3a7c20707101141m17e313e2k99be5b7197edc910@mail.gmail.com>
Date: Tue, 10 Jul 2007 11:41:32 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <wei.zhang@freescale.com>
Subject: Re: [PATCH 3/4] Extend the DMA-engine API.
Cc: akpm@linux-foundation.org, paulus@samba.org, galak@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <11840607111926-git-send-email-wei.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11840607111926-git-send-email-wei.zhang@freescale.com>
X-Google-Sender-Auth: 4924806d4e63465e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Zhang Wei <wei.zhang@freescale.com> wrote:
> Add channel wait queue and transfer callback dma_xfer_callback().
> If the DMA controller and driver support interrupt, when the
> transfer is finished, it will wakeup the wait queue
> and call the callback function of the channel.
>
> Add dma_async_raw_xfer() to API and device_raw_xfer() to struct dma_device
> for RAW physical address DMA transfer, which will be used at transfer
> between I/O address and memory address.
>

Please review the async_tx API patch series[1], it should meet your
needs.  What you call "raw" mode support is now default for the
dmaengine driver interface.  I plan to request that this series be
merged for 2.6.23.

Regards,
Dan

[1]http://marc.info/?l=linux-raid&w=2&r=1&s=md-accel&q=b
