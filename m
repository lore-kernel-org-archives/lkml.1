Return-Path: <linux-kernel-owner+w=401wt.eu-S1765044AbXGaQkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765044AbXGaQkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbXGaQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:40:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:61177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbXGaQkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:40:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="256942892"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] flush icache before set_pte take6. [3/4] add montecito brand name
Date: Tue, 31 Jul 2007 09:39:58 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A020E3B04@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070731114007.b3c62cd3.kamezawa.hiroyu@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] flush icache before set_pte take6. [3/4] add montecito brand name
Thread-Index: AcfTG/gWKA+Yg8kdS2mJgvPcbqpYNAAdCuHw
From: "Luck, Tony" <tony.luck@intel.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       <Zoltan.Menyhart@bull.net>, "Christoph Lameter" <clameter@sgi.com>
X-OriginalArrivalTime: 31 Jul 2007 16:40:00.0097 (UTC) FILETIME=[6FB17D10:01C7D391]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

+		} else if (family == 0x20)
+			memcpy(brand, "Montecito", 10);

NAK.

We don't really have names for the different cpu families. "Montecito"
is definitely not the right string to apply here (Montvale will also
have family == 0x20).  The old McKinley/Madison strings are intended
to provide some information for old processors where PAL did not
support PAL_BRAND_INFO.  All new cpus (from Montecito onward) will
support this PAL call, so there should be no need to add more code to
make names out of [family,model] tuples.

-Tony
