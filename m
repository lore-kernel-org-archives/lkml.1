Return-Path: <linux-kernel-owner+w=401wt.eu-S941352AbXGTQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941352AbXGTQdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765064AbXGTQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:53995 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934884AbXGTQda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,563,1175497200"; 
   d="scan'208";a="270781941"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/7] I/OAT: Split PCI startup from DMA handling code
Date: Fri, 20 Jul 2007 09:33:20 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02B81665@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070720105307.GB10631@pazke.donpac.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/7] I/OAT: Split PCI startup from DMA handling code
Thread-Index: AcfKvDDOwhH7DHavRfyiAi4jZLuGxwALygXw
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Andrey Panin" <pazke@donpac.ru>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <jeff@garzik.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 16:33:20.0871 (UTC) FILETIME=[AF312F70:01C7CAEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Panin [mailto:pazke@donpac.ru] 
>
>Why this driver lacks MODULE_DEVICE_TABLE() ? Is it 
>intentionaly omitted ?

Hmmm - good catch.  It has been missing for a long time in the code.
I'll double check with the original developer to see if it was left out
on purpose and probably add it in a later patch.

Thanks,
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
