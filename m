Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbXIGPLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbXIGPLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXIGPLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:11:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:36582 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310AbXIGPLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,221,1186383600"; 
   d="scan'208";a="128074254"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm] [RFC] IOAT: Add support for version 2 of ioatdma device
Date: Fri, 7 Sep 2007 08:11:19 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02FF07A6@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070907084322.GA10837@shadowen.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm] [RFC] IOAT: Add support for version 2 of ioatdma device
thread-index: AcfxKzEXpwx7RO2RTmW+0QcW8jLeuwANgRVA
References: <20070906170712.7444.34573.stgit@localhost.localdomain> <20070907084322.GA10837@shadowen.org>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Sep 2007 15:11:19.0552 (UTC) FILETIME=[58194000:01C7F161]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Andy Whitcroft [mailto:apw@shadowen.org] 
>
>Those two look suspect to checkpatch, and I have to agree with it.
>
>WARNING: Trailing semicolon indicates no statements, indent implies
>otherwise
>#346: FILE: drivers/dma/ioat_dma.c:168:
>+               if (--cnt == 0);
>+                       break;
>WARNING: Trailing semicolon indicates no statements, indent implies
>otherwise
>#363: FILE: drivers/dma/ioat_dma.c:188:
>+               if (--cnt == 0);
>+                       break;
>
>-apw
>

Ouch - how did I miss those?  Thanks!

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
