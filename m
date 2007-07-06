Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbXGFRuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbXGFRuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763687AbXGFRud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:50:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:60890 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762667AbXGFRuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,509,1175497200"; 
   d="scan'208";a="247328417"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 10/10] Scheduler profiling - Use immediate values
Date: Fri, 6 Jul 2007 10:50:30 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB5419485015CC88A@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <p73vecx21um.fsf@bingen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 10/10] Scheduler profiling - Use immediate values
Thread-Index: Ace/vaf9txiIk825QE2MkLuHwaYp3wAOBgkQ
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Jul 2007 17:50:31.0668 (UTC) FILETIME=[25943B40:01C7BFF6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Also cache misses in this situation tend to be much more than 48
cycles
> (even an K8 with integrated memory controller with fastest DIMMs is
> slower than that)  Mathieu probably measured an L2 miss, not a load
from
> RAM.
> Load from RAM can be hundreds of ns in the worst case.
> 

The 48 cycles sounds to me like a memory load in an unloaded system, but
it is quite low. I wonder how it was measured...

  tong
