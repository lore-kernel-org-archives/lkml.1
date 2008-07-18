Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbYGRP4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbYGRP4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYGRP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:56:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:51950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYGRP4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,211,1215414000"; 
   d="scan'208";a="362743995"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] I/OAT: tcp_dma_copybreak default value dependant on I/OAT version
Date: Fri, 18 Jul 2008 16:55:52 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101D2C62E@swsmsx413.ger.corp.intel.com>
In-Reply-To: <e9c3a7c20807111220q432e712q734e075e6d533e5c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] I/OAT: tcp_dma_copybreak default value dependant on I/OAT version
thread-index: AcjjiyiO61GcNUnnTKOTOXmw5oZl+wFYzd3Q
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jul 2008 15:55:54.0096 (UTC) FILETIME=[C25F8700:01C8E8EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> When NET_DMA is not enabled this breaks the build.  Also, given that
> NET_DMA is only beneficial on architectures with i/o coherent caches
> this fix up should be done directly in the driver, not passed up to
> the common core.

I have modified it in patchset v2.

> 
> Regards,
> Dan

Thanks,
Maciej
