Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbYFDRUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbYFDRUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYFDRUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:20:04 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:55420 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYFDRUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:20:03 -0400
X-IronPort-AV: E=Sophos;i="4.27,590,1204520400"; 
   d="scan'208";a="54636789"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to becopied to
Date: Wed, 4 Jun 2008 18:20:52 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D01FB8036@limkexm3.ad.analog.com>
In-Reply-To: <1212598723.32207.130.camel@pmac.infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to becopied to
Thread-Index: AcjGZEpWE+wBxq7DRwG9Ml7v/U2dFQAArqxA
References: <1211021526-24076-1-git-send-email-cooloney@kernel.org> <8A42379416420646B9BFAC9682273B6D0183AE38@limkexm3.ad.analog.com> <386072610805190253g42d47d81w794b3c14c15aa890@mail.gmail.com> <1212598723.32207.130.camel@pmac.infradead.org>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "David Woodhouse" <dwmw2@infradead.org>, "Bryan Wu" <cooloney@kernel.org>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
       <mike@steroidmicros.com>
X-OriginalArrivalTime: 04 Jun 2008 17:19:59.0674 (UTC) FILETIME=[3798A1A0:01C8C667]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Bryan sent an incremental update patch, some time ago.
See below ...

Regards,
Michael

From: Michael Hennerich <michael.hennerich@analog.com>

remove duplicate code.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/devices/m25p80.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index b10649b..7f89b54 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -122,8 +122,6 @@ static int write_sr(struct m25p *flash, u8 val)
 	flash->command[0] = OPCODE_WRSR;
 	flash->command[1] = val;
 
-	spi_write(flash->spi, flash->command, 2);
-
 	return spi_write(flash->spi, flash->command, 2);  }
 
--
1.5.5

>-----Original Message-----
>From: David Woodhouse [mailto:dwmw2@infradead.org]
>Sent: Mittwoch, 4. Juni 2008 18:59
>To: Bryan Wu
>Cc: Hennerich, Michael; linux-mtd@lists.infradead.org; linux-
>kernel@vger.kernel.org; mike@steroidmicros.com
>Subject: Re: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to
>becopied to
>
>On Mon, 2008-05-19 at 17:53 +0800, Bryan Wu wrote:
>>
>> >
>> > I just noticed that write_sr contains a duplicated spi_write.
>> > Bryan sends out a new patch.
>> >
>>
>>
>> No problem, it is my fault. I should review the patch carefully.
>
>Was there a new patch coming?
>
>--
>dwmw2
