Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYI2JZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYI2JZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYI2JZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:25:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYI2JZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:25:42 -0400
Date: Mon, 29 Sep 2008 14:58:02 +0530
From: apgmoorthy <moorthy.apg@samsung.com>
Subject: RE: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
In-reply-to: <1222417176.5012.17.camel@sauron>
To: "'David Woodhouse'" <dwmw2@infradead.org>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>, linux-mtd@lists.infradead.org,
       "'lkml'" <linux-kernel@vger.kernel.org>, dedekind@infradead.org
Message-id: <000b01c92215$ae62d4e0$3dd66c6b@sisodomain.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Mailer: Microsoft Office Outlook 11
Content-type: text/plain; charset=koi8-r
Content-transfer-encoding: 8BIT
Thread-index: AckfsKkwJ68cddOERoKsr6o1e9elJgCZDN3g
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
 <1222404711.5012.5.camel@sauron>
 <A09E9029F2344F78959A3E36179C468E@sisodomain.com>
 <1222417176.5012.17.camel@sauron>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

   Please do comment on this patch. 

   "Not to expose whole OOB" suggestion by Kyungmin should be fine , but
looking for your suggestion.

With Regards
Gangheyamoorthy.A.P

-----Original Message-----
From: Artem Bityutskiy [mailto:dedekind@infradead.org] 
Sent: Friday, September 26, 2008 1:50 PM
To: Amit Kumar Sharma
Cc: Kyungmin Park; apgmoorthy; linux-mtd@lists.infradead.org; Kyungmin Park;
lkml; David Woodhouse
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.


On Fri, 2008-09-26 at 13:31 +0530, Amit Kumar Sharma wrote:
> Hi Artem
> 
> we have following erro message  if we maintain 64 bytes 
> eccpos.
> 
> /flash_eraseall -j /dev/mtd4
> ./flash_eraseall: /dev/mtd4: unable to get NAND oobinfo
> 
> ./nandwrite -j /dev/mtd2 /jffs2.img
> MEMSETOOBSEL: Inappropriate ioctl for device
> 
> but i think as OneNAND has hw ecc controller so Jffs2 will 
> not face any problem
> still i think mtd should consider for 128 bytes eccpos for 
> 4K page size.

Well, anyway, in Linux ABI is a holy cow, you cannot change it.
That is a tough rule. Old user-space binaries have to always
works.

Thus you may do one of:
1. Invent a new ioctl for 4KiB page NANDs
2. Add sysfs support
3. Just do not expose whole OOB as Kyungmin suggested

But I think assume dwmw2 would need to comment on this and
tell which approach would agree on.

-- 
Best regards,
Artem Bityutskiy (‚…‘¿√À…  ·“‘£Õ)

