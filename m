Return-Path: <linux-kernel-owner+w=401wt.eu-S941459AbXGTQfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941459AbXGTQfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939521AbXGTQfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:35:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:12542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939090AbXGTQfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,563,1175497200"; 
   d="scan'208";a="270782469"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 6/7] DCA: Add Direct Cache Access driver
Date: Fri, 20 Jul 2007 09:35:29 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02B8166D@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070719.175237.07458467.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 6/7] DCA: Add Direct Cache Access driver
Thread-Index: AcfKaEVt8JIU4wY4QWmq5I6mYAxWQwAg58Hw
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "David Miller" <davem@davemloft.net>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <jeff@garzik.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 16:35:29.0526 (UTC) FILETIME=[FBE06160:01C7CAEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller [mailto:davem@davemloft.net] 
>
>> +static spinlock_t dca_lock;
> ...
>> +	spin_lock_init(&dca_lock);
>
>It's easier to use DEFINE_SPINLOCK().
>

Thanks - I'll adjust that in a future patch.
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
