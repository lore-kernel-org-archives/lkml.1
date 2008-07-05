Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYGEP1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYGEP1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYGEP1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:27:30 -0400
Received: from ihemail2.lucent.com ([135.245.0.35]:39805 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYGEP13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:27:29 -0400
Message-ID: <00ae01c8deb3$913522b0$01fca8c0@microsof60b8d6>
From: "Gavin Shan" <gshan@alcatel-lucent.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
References: <008101c8deaa$52cf19d0$01fca8c0@microsof60b8d6> <20080705081737.5bc17450@infradead.org>
Subject: Re: Tough Issue: kernel instruction corruption
Date: Sat, 5 Jul 2008 23:26:57 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m65FRffq028997

>> Hello, I'm faced a tough issue recently: instructions of kernel
>> were corrupted. There has 2 PCI buses on my board and lots
>> of PCI devices with DMA capabality involved. I'm suspecting
>> the kernel instructions were corrupted by DMA operations driving
>> by those PCI devices with DMA capabality. 
>> 
>> Anybody have tried to protect kernel instructions from this case
>> or have any ideas to protect kernel text section?
> 
> if you have a modern Intel board, you can enable the IOMMU on it that
> will protect the kernel text (well, all of memory) from rogue DMA.
> PPC generally has similar capabilities, as do some IBM x86 chipsets.

PPC is used now and PPC doesn't have 2 kinds of MMUs. I don't know much
about IOMMU. Is it part of CPU?

> 
> Without an IOMMU it's basically impossible to protect against such DMA.

I did a google with "instruction"+"corruption"+"DMA" and found one matched
patent. And I go through the datasheet of PCI chips on my board, unfortunately,
the PCI chip didn't supply address protection from vager DMA.

http://www.freepatentsonline.com/y2005/0182862.html

> 
> -- 
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
