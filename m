Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYGCXsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYGCXsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYGCXr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:47:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:62646 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYGCXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=r8/4BonaiENGfLNAa2M5KtCxW23dVANmytj6In2YP1Vq206SQlpo7/etmgxBcaLwPL
         bki6mC2ATBgq7OKNnHZcjRn5LBdAeVCKXPoDINYccXge9n6BpXqYkBq3LyE6SBl8GVB5
         Ffa9IxdmULQf/rs/snry8yQ2nuN+RXCuSeDmg=
Message-ID: <e9c3a7c20807031647n36687828r8d5a7e5e64723bd1@mail.gmail.com>
Date: Thu, 3 Jul 2008 16:47:48 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] dmatest: Simple DMA memcpy test client
Cc: linux-kernel@vger.kernel.org, "Haavard Skinnemoen" <hskinnemoen@atmel.com>
In-Reply-To: <1214396359-5776-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214396359-5776-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Google-Sender-Auth: b6a3a5c8d1178ba7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 5:19 AM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
>
> This client tests DMA memcpy using various lengths and various offsets
> into the source and destination buffers. It will initialize both
> buffers with a repeatable pattern and verify that the DMA engine copies
> the requested region and nothing more. It will also verify that the
> bytes aren't swapped around, and that the source buffer isn't modified.
>
> The dmatest module can be configured to test a specific device, a
> specific channel. It can also test multiple channels at the same time,
> and it can start multiple threads competing for the same channel.
>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
>

Applied, with your fix included.  It is a nice little framework and
can hopefully grow support for xor and the other operations.

Thanks,
Dan
