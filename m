Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZFFA5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZFFA5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 20:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZFFA4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 20:56:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54420
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZFFA4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 20:56:54 -0400
Date: Fri, 05 Jun 2009 17:56:56 -0700 (PDT)
Message-Id: <20090605.175656.95336229.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: subrata@linux.vnet.ibm.com, sachinp@linux.vnet.ibm.com,
       sfr@canb.auug.org.au, greg@kroah.com, linux-kernel@vger.kernel.org,
       Linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org, paulus@samba.org,
       Geert.Uytterhoeven@sonycom.com, geert@linux-m68k.org
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig
 [drivers/staging/comedi/drivers.o]
From: David Miller <davem@davemloft.net>
In-Reply-To: <1244244749.31984.16.camel@pasglop>
References: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
	<1244244749.31984.16.camel@pasglop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n560vh54007746

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sat, 06 Jun 2009 09:32:29 +1000

> 
>> I tried this. But, with some catch. â€˜PAGE_KERNEL_NOCACHEâ€™ seems to be the
>> choice for majority of architectures like frv, m32r, sh, x86, etc, as Geert
>> mentions below. However, i believe POWERPC defines it as â€˜PAGE_KERNEL_NCâ€˜
>> found at arch/powerpc/include/asm/pte-common.h.
>> 
>> Paul/Banjamin,
>> Can you please confirm this ?
> 
> Read my reply to Greg. Why the heck are you trying to map memory
> non-cacheable in the first place ?

I agree, this is extremely fishy.

I guess the issue is that the driver wants consistent DMA memory
but wants to allocate a huge area vmap() style.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
