Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZJ1TIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZJ1TIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZJ1TIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:08:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35980 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZJ1TIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ovnQabYJ488mV13JDTZViNCVpwiYeHit7qL2JbzLiWcIkY2MHMKjmpQPdFZGQx6VL1
         fvfBDIFsYgKDtcn4YQQ1Aqr3PuWtG0b3bQCr3kY8oq0ckwD+lQbpu8+3g1HOQuWmsZOS
         GS7ZzcfDUneIfwtaCY9oFlM3c+alchA//LXcY=
MIME-Version: 1.0
In-Reply-To: <1256743153-17252-1-git-send-email-linus.walleij@stericsson.com>
References: <1256743153-17252-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 28 Oct 2009 12:08:40 -0700
X-Google-Sender-Auth: dd2eadefef2c069d
Message-ID: <e9c3a7c20910281208w54ddc859wb650f6527dae2d08@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add COH 901 318 DMA driver platform config for U300 
	v3
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 8:19 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
[..]
> +#define flags_memcpy_config (COH901318_CX_CFG_CH_DISABLE | \
> +                       COH901318_CX_CFG_RM_MEMORY_TO_MEMORY | \
> +                       COH901318_CX_CFG_LCR_DISABLE | \
> +                       COH901318_CX_CFG_TC_IRQ_ENABLE | \
> +                       COH901318_CX_CFG_BE_IRQ_ENABLE)
> +#define flags_memcpy_lli_chained (COH901318_CX_CTRL_TC_ENABLE | \
> +                       COH901318_CX_CTRL_BURST_COUNT_32_BYTES | \
> +                       COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS | \
> +                       COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE | \
> +                       COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS | \
> +                       COH901318_CX_CTRL_DST_ADDR_INC_ENABLE | \
> +                       COH901318_CX_CTRL_MASTER_MODE_M1RW | \
> +                       COH901318_CX_CTRL_TCP_DISABLE | \
> +                       COH901318_CX_CTRL_TC_IRQ_DISABLE | \
> +                       COH901318_CX_CTRL_HSP_DISABLE | \
> +                       COH901318_CX_CTRL_HSS_DISABLE | \
> +                       COH901318_CX_CTRL_DDMA_LEGACY | \
> +                       COH901318_CX_CTRL_PRDD_SOURCE)
> +#define flags_memcpy_lli (COH901318_CX_CTRL_TC_ENABLE | \
> +                       COH901318_CX_CTRL_BURST_COUNT_32_BYTES | \
> +                       COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS | \
> +                       COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE | \
> +                       COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS | \
> +                       COH901318_CX_CTRL_DST_ADDR_INC_ENABLE | \
> +                       COH901318_CX_CTRL_MASTER_MODE_M1RW | \
> +                       COH901318_CX_CTRL_TCP_DISABLE | \
> +                       COH901318_CX_CTRL_TC_IRQ_DISABLE | \
> +                       COH901318_CX_CTRL_HSP_DISABLE | \
> +                       COH901318_CX_CTRL_HSS_DISABLE | \
> +                       COH901318_CX_CTRL_DDMA_LEGACY | \
> +                       COH901318_CX_CTRL_PRDD_SOURCE)
> +#define flags_memcpy_lli_last (COH901318_CX_CTRL_TC_ENABLE | \
> +                       COH901318_CX_CTRL_BURST_COUNT_32_BYTES | \
> +                       COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS | \
> +                       COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE | \
> +                       COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS | \
> +                       COH901318_CX_CTRL_DST_ADDR_INC_ENABLE | \
> +                       COH901318_CX_CTRL_MASTER_MODE_M1RW | \
> +                       COH901318_CX_CTRL_TCP_DISABLE | \
> +                       COH901318_CX_CTRL_TC_IRQ_ENABLE | \
> +                       COH901318_CX_CTRL_HSP_DISABLE | \
> +                       COH901318_CX_CTRL_HSS_DISABLE | \
> +                       COH901318_CX_CTRL_DDMA_LEGACY | \
> +                       COH901318_CX_CTRL_PRDD_SOURCE)

You go through the hassle of defining these flag combination sets...

> +               .param.config = COH901318_CX_CFG_CH_DISABLE |
> +                               COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
> +                               COH901318_CX_CFG_LCR_DISABLE |
> +                               COH901318_CX_CFG_TC_IRQ_ENABLE |
> +                               COH901318_CX_CFG_BE_IRQ_ENABLE,

...but then don't use them to cut down on the line count in the
definition of these parameters?

--
Dan
