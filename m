Return-Path: <linux-kernel-owner+w=401wt.eu-S936197AbXGTVKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197AbXGTVKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbXGTVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:10:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:11772 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbXGTVKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:10:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,564,1175497200"; 
   d="scan'208";a="108339779"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 20 Jul 2007 14:10:35 -0700
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F023E842F@orsmsx411.amr.corp.intel.com>
In-Reply-To: <adair8ec0u3.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
thread-index: AcfLBxSfe9f1MBNMR6Cl+g2U3e2twQACwjXA
From: "Leech, Christopher" <christopher.leech@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
       <jeff@garzik.org>, "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 21:10:37.0096 (UTC) FILETIME=[6B27AA80:01C7CB12]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> OK, let's try to avoid going off into the weeds here.  In the context
> of the specific patch that this thread started with, is there any
> point in having both "msix-single-vector" and "msi" interrupt support?

This driver supports some chipsets that do MSI, and some that do MSI-X,
but none that can do both.

- Chris
