Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZJ2Mj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZJ2Mj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZJ2MjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:39:25 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60216 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZJ2MjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QAbPv8qh0HTujPoA9eBIqcK6W77vg77GGF871asPN8xD8VhuQVmtNVx4JXz0Yq9eqC
         LGmWCPw5aifWZe9WdLlM0ZqCJ9pDSropijReR95lOncXeBwNIPGFAFaJI1OJhXA2F1V7
         dghFw978L2YJYoiSY1eRzx4avSJmVsP4SPmsw=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c20910281208w54ddc859wb650f6527dae2d08@mail.gmail.com>
References: <1256743153-17252-1-git-send-email-linus.walleij@stericsson.com>
	 <e9c3a7c20910281208w54ddc859wb650f6527dae2d08@mail.gmail.com>
Date: Thu, 29 Oct 2009 13:39:27 +0100
Message-ID: <63386a3d0910290539y1fb39cefj92bee7b37fe062a1@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add COH 901 318 DMA driver platform config for U300 
	v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/28 Dan Williams <dan.j.williams@intel.com>:

> On Wed, Oct 28, 2009 at 8:19 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> [..]
>> +#define flags_memcpy_config (COH901318_CX_CFG_CH_DISABLE | \
>> +                       COH901318_CX_CFG_RM_MEMORY_TO_MEMORY | \
>> +                       COH901318_CX_CFG_LCR_DISABLE | \
>> +                       COH901318_CX_CFG_TC_IRQ_ENABLE | \
>> +                       COH901318_CX_CFG_BE_IRQ_ENABLE)
>> +#define flags_memcpy_lli_chained (COH901318_CX_CTRL_TC_ENABLE | \
>> +                       COH901318_CX_CTRL_BURST_COUNT_32_BYTES | \
>> +                       COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS | \
>> +                       COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE | \
>> +                       COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS | \
>> +                       COH901318_CX_CTRL_DST_ADDR_INC_ENABLE | \
>> +                       COH901318_CX_CTRL_MASTER_MODE_M1RW | \
>> +                       COH901318_CX_CTRL_TCP_DISABLE | \
>> +                       COH901318_CX_CTRL_TC_IRQ_DISABLE | \
>> +                       COH901318_CX_CTRL_HSP_DISABLE | \
>> +                       COH901318_CX_CTRL_HSS_DISABLE | \
>> +                       COH901318_CX_CTRL_DDMA_LEGACY | \
>> +                       COH901318_CX_CTRL_PRDD_SOURCE)
>> +#define flags_memcpy_lli (COH901318_CX_CTRL_TC_ENABLE | \
>> +                       COH901318_CX_CTRL_BURST_COUNT_32_BYTES | \
>> +                       COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS | \
>> +                       COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE | \
>> +                       COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS | \
>> +                       COH901318_CX_CTRL_DST_ADDR_INC_ENABLE | \
>> +                       COH901318_CX_CTRL_MASTER_MODE_M1RW | \
>> +                       COH901318_CX_CTRL_TCP_DISABLE | \
>> +                       COH901318_CX_CTRL_TC_IRQ_DISABLE | \
>> +                       COH901318_CX_CTRL_HSP_DISABLE | \
>> +                       COH901318_CX_CTRL_HSS_DISABLE | \
>> +                       COH901318_CX_CTRL_DDMA_LEGACY | \
>> +                       COH901318_CX_CTRL_PRDD_SOURCE)
>> +#define flags_memcpy_lli_last (COH901318_CX_CTRL_TC_ENABLE | \
>> +                       COH901318_CX_CTRL_BURST_COUNT_32_BYTES | \
>> +                       COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS | \
>> +                       COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE | \
>> +                       COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS | \
>> +                       COH901318_CX_CTRL_DST_ADDR_INC_ENABLE | \
>> +                       COH901318_CX_CTRL_MASTER_MODE_M1RW | \
>> +                       COH901318_CX_CTRL_TCP_DISABLE | \
>> +                       COH901318_CX_CTRL_TC_IRQ_ENABLE | \
>> +                       COH901318_CX_CTRL_HSP_DISABLE | \
>> +                       COH901318_CX_CTRL_HSS_DISABLE | \
>> +                       COH901318_CX_CTRL_DDMA_LEGACY | \
>> +                       COH901318_CX_CTRL_PRDD_SOURCE)
>
> You go through the hassle of defining these flag combination sets...
>
>> +               .param.config = COH901318_CX_CFG_CH_DISABLE |
>> +                               COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
>> +                               COH901318_CX_CFG_LCR_DISABLE |
>> +                               COH901318_CX_CFG_TC_IRQ_ENABLE |
>> +                               COH901318_CX_CFG_BE_IRQ_ENABLE,
>
> ...but then don't use them to cut down on the line count in the
> definition of these parameters?

We do, look further below:

+       {
+               .number = U300_DMA_GENERAL_PURPOSE_0,
+               .name = "GENERAL 00",
+               .priority_high = 0,
+
+               .param.config = flags_memcpy_config,
+               .param.ctrl_lli_chained = flags_memcpy_lli_chained,
+               .param.ctrl_lli = flags_memcpy_lli,
+               .param.ctrl_lli_last = flags_memcpy_lli_last,
+       },

Only the general purpose channels support memcpy and these are all set
up the same way (for accelerating memcpy() operations).

The rest of the channels are, mem -> io, io -> mem, io -> io and the io
(device DMA) configurations are individual and varies greatly with
hardware. For some currently unused hardware we haven't even defined
the proper flags yet, and e.g. changing the burst size of an individual
channel without affecting the rest is something a developer is very
likely to do.

Linus Walleij
