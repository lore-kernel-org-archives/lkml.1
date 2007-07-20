Return-Path: <linux-kernel-owner+w=401wt.eu-S1763862AbXGTVN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763862AbXGTVN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXGTVNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:13:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:21210 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXGTVNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,564,1175497200"; 
   d="scan'208";a="252934014"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 20 Jul 2007 14:13:15 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02B81AAF@orsmsx418.amr.corp.intel.com>
In-Reply-To: <adair8ec0u3.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Thread-Index: AcfLBxS196L/ag1eS8yT1lqCWWrkVgACvHtg
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <jeff@garzik.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 21:13:15.0525 (UTC) FILETIME=[C9960350:01C7CB12]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier [mailto:rdreier@cisco.com] 
>
>OK, let's try to avoid going off into the weeds here.  In the context
>of the specific patch that this thread started with, is there any
>point in having both "msix-single-vector" and "msi" interrupt support?

Some versions of this hardware support MSI-X and not MSI.  If it can't
get all the MSI-X interrupts, it will try a single interrupt before
fallign all the way down to Legacy interrupts.  Basically, if we can
only get one interrupt, we'd still like to use the MSI-X mechanics if
possible.  If totally out of the question, then we'll use legacy.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
