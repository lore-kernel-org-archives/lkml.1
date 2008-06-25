Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYFYSL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYFYSL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYFYSLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:11:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:65501 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYFYSLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=AzCwxhHd5kF4ptNaVOZyBbhCoK5RGHJ5nD2YxsMJ6ZqJXblDWBtarm92XS18PVCSjD
         wZ92fb87eG2+qVaZiQXX9xF6DTWNiW76DVcBQjSJxe8azrEKtlAeMaLPtlRDD1fc3q4r
         kgZdcwepM7omAksor5ghSq1FeMa+htpMmIcw0=
Message-ID: <e9c3a7c20806251111o7f1ef626xeb9f43d9cbfb3b4e@mail.gmail.com>
Date: Wed, 25 Jun 2008 11:11:47 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] dmaengine: Couple DMA channels to their physical DMA device
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>
In-Reply-To: <1214395723-5657-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214395723-5657-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Google-Sender-Auth: 6a74c411716e31f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 5:08 AM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
>
> Set the 'parent' field of channel class devices to point to the
> physical DMA device initialized by the DMA engine driver.
>
> This allows drivers to use chan->dev.parent for syncing DMA buffers
> and adds a 'device' symlink to the real device in
> /sys/class/dma/dmaXchanY.
>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---

Thanks, applied to async_tx/next

--
Dan
