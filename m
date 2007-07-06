Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbXGFU5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbXGFU5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbXGFU5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:57:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:48358 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759907AbXGFU5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:57:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,509,1175497200"; 
   d="scan'208";a="247382133"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 10/10] Scheduler profiling - Use immediate values
Date: Fri, 6 Jul 2007 13:57:03 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB5419485015CC9E1@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070706200325.GD8174@one.firstfloor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 10/10] Scheduler profiling - Use immediate values
Thread-Index: AcfACLkHrb3aQfSCRwKty03PktUpDQABv9eQ
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Jul 2007 20:57:04.0243 (UTC) FILETIME=[34DFA430:01C7C010]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I found that memory latency is difficult to measure in modern x86
> CPUs because they have very clever prefetchers that can often
> outwit benchmarks.

A pointer-chasing program that accesses a random sequence of addresses
usually can produce a good estimate on memory latency. Also, prefetching
can be turned off in BIOS or by modifying the MSRs.
 
> Another trap on P4 is that RDTSC is actually quite slow and
synchronizes
> the CPU; that can add large measurement errors.
> 
> -Andi

The cost can be amortized if the portion of memory accesses is long
enough.

  tong
