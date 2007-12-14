Return-Path: <linux-kernel-owner+w=401wt.eu-S1764715AbXLNT6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764715AbXLNT6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762717AbXLNT6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:58:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:62429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbXLNT6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:58:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,169,1196668800"; 
   d="scan'208";a="439311831"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-9"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] drivers/dma/ioat_dma.c: inlining failed
Date: Fri, 14 Dec 2007 11:53:28 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03A18730@orsmsx418.amr.corp.intel.com>
In-Reply-To: <200712142144.47310.caglar@pardus.org.tr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/dma/ioat_dma.c: inlining failed
Thread-Index: Acg+idb+d/Udm7S7SViCEOk17A5TfQAAJi+g
References: <200712142144.47310.caglar@pardus.org.tr>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: <caglar@pardus.org.tr>, <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 14 Dec 2007 19:53:28.0746 (UTC) FILETIME=[FF2AC0A0:01C83E8A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: S.Çaðlar Onur [mailto:caglar@pardus.org.tr] 
>Sent: Friday, December 14, 2007 11:45 AM
>To: linux-kernel@vger.kernel.org
>Cc: Nelson, Shannon
>Subject: [PATCH] drivers/dma/ioat_dma.c: inlining failed
>
>Hi;
>
>After commit 7bb67c14fd3778504fb77da30ce11582336dfced, Linus's 
>git tree gaves following compiliation error with gcc-3.4.6. 
>Following patch solves this issue for me;
>
>
>[...]
>  CC [M]  drivers/dma/ioat.o
>  CC [M]  drivers/dma/ioat_dma.o
>drivers/dma/ioat_dma.c: In function `ioat1_tx_submit':
>drivers/dma/ioat_dma.c:177: sorry, unimplemented: inlining 
>failed in call to '__ioat1_dma_memcpy_issue_pending': function 
>body not available
>drivers/dma/ioat_dma.c:268: sorry, unimplemented: called from here
>make[2]: *** [drivers/dma/ioat_dma.o] Hata 1
>make[1]: *** [drivers/dma] Hata 2
>make: *** [drivers] Hata 2
>
>Signed-off-by: S.Çaðlar Onur <caglar@pardus.org.tr>
[...]

Yep.  I posted a similar patch with a couple more tweaks after a month ago after Andrew's comments, which hasn't yet moved from -mm to Linus' tree.  See http://lkml.org/lkml/2007/11/16/336

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
