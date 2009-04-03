Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZDCJRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZDCJRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZDCJQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:16:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:18725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZDCJQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:16:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="678442765"
From: "Han, Weidong" <weidong.han@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>
CC: IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 17:15:40 +0800
Subject: [patch 0/2] decouple interrupt remapping from x2apic
Thread-Topic: [patch 0/2] decouple interrupt remapping from x2apic
Thread-Index: Acm0PMH7dlQmL8NOTR21DCqOhDN+vA==
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7C3A5@pdsmsx503.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current interrupt remapping is only enabled when x2apic is enabled. In fact, interrupt remapping can be used without x2apic. 

This patchset decouples interrupt remapping from x2apic, and then interrupt remapping can be used without x2apic.

Regards,
Weidong