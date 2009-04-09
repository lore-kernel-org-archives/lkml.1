Return-Path: <linux-kernel-owner+w=401wt.eu-S935840AbZDIQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935840AbZDIQts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935952AbZDIQsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:48:46 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:47675 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935876AbZDIQso convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:48:44 -0400
X-BigFish: VPS-9(zz1432R1805M19c2kzz1202hzzz32i6bh43j)
X-WSS-ID: 0KHUEOL-01-8Z4-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Enable GART-IOMMU only after setting up protection methods
Date: Thu, 9 Apr 2009 11:48:29 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AF68@sausexmb4.amd.com>
In-Reply-To: <86802c440904082144m54e2dba5n6c89624481fb5fa1@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Enable GART-IOMMU only after setting up protection methods
Thread-Index: Acm4zdVgvBUmhGneQviXXvru34TM2gAZQrGQ
References: <200903171457.25582.mark.langsdorf@amd.com> <200904081608.55746.mark.langsdorf@amd.com> <86802c440904082144m54e2dba5n6c89624481fb5fa1@mail.gmail.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
CC: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
X-OriginalArrivalTime: 09 Apr 2009 16:48:30.0026 (UTC) FILETIME=[02EBFAA0:01C9B933]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > AMD has tested this patch and seen no adverse effects.
> 
> how about system with AGP card and more than 4g system RAM?

Tested on an Iwill DK8X 2P system with 8 GB of DRAM.
 
> also it seems flush_gart() in init_k8_gatt() and gart_iommu_init()
> could be removed?

Possibly, but I'd rather be cautious than not.

-Mark Langsdorf
Operating System Research Center
AMD

