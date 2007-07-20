Return-Path: <linux-kernel-owner+w=401wt.eu-S935721AbXGTWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935721AbXGTWHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbXGTWHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:07:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:26227 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbXGTWHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,564,1175497200"; 
   d="scan'208";a="268749085"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 20 Jul 2007 15:07:20 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32903446008@orsmsx414.amr.corp.intel.com>
In-Reply-To: <1a297b360707201459s57fb4778m2be80e4c2b825b2c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
thread-index: AcfLGS90xDkH3VcbS0q199q81b7YwQAAQg0A
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Manu Abraham" <abraham.manu@gmail.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: "Roland Dreier" <rdreier@cisco.com>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <jeff@garzik.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 22:07:21.0741 (UTC) FILETIME=[587B43D0:01C7CB1A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok. Thanks for clearing it up. So the idea would be that if
> pci_enable_msix() for "n" number of messages failed, then 
> settle down for 1 message, which is equivalent to MSI mode

And if that fails to acquire the one vector for whatever reason (MSI
isn't enabled, or something is buggy in your chipset), fail back to
legacy interrupts.

Cheers,
-PJ Waskiewicz
