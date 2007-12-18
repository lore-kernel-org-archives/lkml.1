Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXLRMNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXLRMNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXLRMM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:12:59 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:33218 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbXLRMM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:12:58 -0500
X-IronPort-AV: E=Sophos;i="4.24,179,1196661600"; 
   d="scan'208";a="482394372"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
Date: Tue, 18 Dec 2007 17:42:52 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CAE2AB34@blrx3m10.blr.amer.dell.com>
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CAE2AB33@blrx3m10.blr.amer.dell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
Thread-Index: AchBKW3/9ncwQZNoR/qzEoLiMcHEkAAMhCtwAAO8u1A=
References: <12954112.1197908230928.JavaMail.root@wombat.diezmil.com> <476743F0.8090609@gmail.com> <46A00B48CC54E4468EF6911F877AC4CAE2AB33@blrx3m10.blr.amer.dell.com>
From: <Shyam_Iyer@Dell.com>
To: <Shyam_Iyer@Dell.com>, <htejun@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Dec 2007 12:12:53.0283 (UTC) FILETIME=[50CCBF30:01C8416F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>ata1.00: XXX DMA address 202275000 is above 32bit

Tejun-I find the allocation always above 32bit with the following tests
-

1) kernel-2.6.24-rc5 + the 32 bit limiting patch that you provided in a
previous posting.
2) vanilla-2.6.24-rc5.

But I don't find the DMA allocation above 32bit in the kernel logs when
I apply my patch on the vanilla-2.6.24-rc5 kernel.

-Shyam
