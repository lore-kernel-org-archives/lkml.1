Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZD0KQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZD0KQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZD0KQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:16:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60424 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZD0KQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KcnocDe6WPBF2N/39bCQG1qgoU+Vx3rCcGbQqJl8jluFTQCEl9OhY7U/AFznixfcuV
         9NcFntdNTza3AINzNXsk4C9QGKLT+7RnkEewkaUEsXAOu6FvF3L6/Rm9JP4ViHRSGZwo
         nFN7U6B60bGC2YUYAZPeFCjS06G6x2jC80/Z8=
MIME-Version: 1.0
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>
References: <20090424183517.GB23140@ovro.caltech.edu>
	 <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>
Date: Mon, 27 Apr 2009 18:16:19 +0800
X-Google-Sender-Auth: b4b39bf4bbd72578
Message-ID: <2a27d3730904270316u6c06eafeja75f6e9e5c83ed29@mail.gmail.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
From: Li Yang <leoli@freescale.com>
To: Liu Dave-R63238 <DaveLiu@freescale.com>
Cc: Ira Snyder <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 5:09 PM, Liu Dave-R63238 <DaveLiu@freescale.com> wrote:
>> By default, the Freescale 83xx DMA controller uses the PCI Read Line
>> command when reading data over the PCI bus. Setting the
>> controller to use the PCI Read Multiple command instead allows the
>> controller to read much larger bursts of data, which provides a
> drastic
>> speed increase.
>
> IIRC, the default for 83xx DMA controller uses the PCI mem read
> command, not mem read line.
>
> You are assuming the PCI memory space is prefetchable( no side effect)
> for DMA.
> Is it possible that DMA is from non-prefetchable memory space?

I guess it's not reasonable to use DMA from non-prefetchable memory.
So it's up to the driver which uses the DMA engine to prevent from
using DMA API on non-prefetchable memory.

- Leo
