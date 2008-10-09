Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYJIW6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYJIW6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYJIW5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:57:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:52734 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYJIW5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vEcbAIQDjR3QPdS5FySStw02OYr/kEbjEImB7bhY+JBgtsO3iLxNG21P4dWwSbKtZG
         rw5xCDyAbKIjXgmiR4k2Zjq8FlYuQpfsvUVtPRZOe8rN2gZAs7khx8VCFuimpTBDRboN
         HU5lEi/h5BXk89sYEhA0Ev8MUOUYjd5sYqYkg=
Message-ID: <9c9fda240810091557j529495d5q284a8ab0e0d752dd@mail.gmail.com>
Date: Fri, 10 Oct 2008 07:57:51 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: apgmoorthy <moorthy.apg@samsung.com>,
       "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
Cc: linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
       dedekind@infradead.org
In-Reply-To: <000b01c92215$ae62d4e0$3dd66c6b@sisodomain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Disposition: inline
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
	 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
	 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
	 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
	 <1222404711.5012.5.camel@sauron>
	 <A09E9029F2344F78959A3E36179C468E@sisodomain.com>
	 <1222417176.5012.17.camel@sauron>
	 <000b01c92215$ae62d4e0$3dd66c6b@sisodomain.com>
X-Google-Sender-Auth: 8bc0540e2768f554
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m99Mw8dq022506

Hi,
I want to merge it if there are no objection.
David, please commit it at MTD tree.
Thank you,Kyungmin Park.
On Mon, Sep 29, 2008 at 6:28 PM, apgmoorthy <moorthy.apg@samsung.com> wrote:>> Hi David,>>   Please do comment on this patch.>>   "Not to expose whole OOB" suggestion by Kyungmin should be fine , but> looking for your suggestion.>> With Regards> Gangheyamoorthy.A.P>> -----Original Message-----> From: Artem Bityutskiy [mailto:dedekind@infradead.org]> Sent: Friday, September 26, 2008 1:50 PM> To: Amit Kumar Sharma> Cc: Kyungmin Park; apgmoorthy; linux-mtd@lists.infradead.org; Kyungmin Park;> lkml; David Woodhouse> Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.>>> On Fri, 2008-09-26 at 13:31 +0530, Amit Kumar Sharma wrote:>> Hi Artem>>>> we have following erro message  if we maintain 64 bytes>> eccpos.>>>> /flash_eraseall -j /dev/mtd4>> ./flash_eraseall: /dev/mtd4: unable to get NAND oobinfo>>>> ./nandwrite -j /dev/mtd2 /jffs2.img>> MEMSETOOBSEL: Inappropriate ioctl for device>>>> but i think as OneNAND has hw ecc controller so Jffs2 will>> not face any problem>> still i think mtd should consider for 128 bytes eccpos for>> 4K page size.>> Well, anyway, in Linux ABI is a holy cow, you cannot change it.> That is a tough rule. Old user-space binaries have to always> works.>> Thus you may do one of:> 1. Invent a new ioctl for 4KiB page NANDs> 2. Add sysfs support> 3. Just do not expose whole OOB as Kyungmin suggested>> But I think assume dwmw2 would need to comment on this and> tell which approach would agree on.>> --> Best regards,> Artem Bityutskiy (âÉÔÀÃËÉÊ áÒÔ£Í)>>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
