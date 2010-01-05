Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990Ab0AEQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0AEQJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845Ab0AEQJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:09:50 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:48372 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754819Ab0AEQJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:09:49 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] drivers/mtd/nand/gpio.c: use resource_size()
Date: Tue, 5 Jan 2010 11:09:46 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902089250@mi8nycmail19.Mi8.com>
In-Reply-To: <1262292881.3181.5632.camel@macbook.infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/mtd/nand/gpio.c: use resource_size()
Thread-Index: AcqKW4LlbV1IbPdVSCicqD4CKMsB9ADxaWcg
References: <BD79186B4FD85F4B8E60E381CAEE19090200EA54@mi8nycmail19.Mi8.com> <1262292881.3181.5632.camel@macbook.infradead.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
X-OriginalArrivalTime: 05 Jan 2010 16:09:46.0956 (UTC) FILETIME=[8035E0C0:01CA8E21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o05GAX16007992

On Thursday, December 31, 2009 1:55 PM, David Woodhouse wrote:
> On Mon, 2009-12-14 at 16:30 -0500, H Hartley Sweeten wrote:
>> 
>> -       release_mem_region(res0->start, res0->end - res0->start + 1);
>> +       release_mem_region(res0->start, resouce_size(res0)); 
>
> That's not going to compile. I fixed it up.

Oops.. Sorry about that. Thanks for fixing.

> Every patch in this batch failed to apply cleanly with git-am, too --
> there was something odd about the whitespace at the end of each one.

I had the same issue with some patches I sent to David Miller.  I think
it's finally resolved.  My mailer was screwing with the last line in the
message.  Sorry about that.

Do you need me to resubmit the series?

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
