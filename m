Return-Path: <linux-kernel-owner+w=401wt.eu-S934137AbXG0AqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137AbXG0AqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759334AbXG0AqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:46:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:31212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbXG0AqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:46:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,585,1175497200"; 
   d="scan'208";a="271135302"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Fix uninitialized local variable "covered" in i386 acpi-cpufreq driver
Date: Thu, 26 Jul 2007 17:46:08 -0700
Message-ID: <79E93560F4A5FD42BB769DAAF8BEF62A021BB08C@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070726171608.474eaf82.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix uninitialized local variable "covered" in i386 acpi-cpufreq driver
Thread-Index: AcfP41psCD8ZBVFXQpKSdCaVWEVbBQABA5oA
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
X-OriginalArrivalTime: 27 Jul 2007 00:46:09.0796 (UTC) FILETIME=[861F9440:01C7CFE7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> How's that for a one-liner? ;)

>- the return value from acpi_cpufreq_early_init() gets ignored,
>  so the module will still load, but won't work.

>- Once that is fixed, the test for !acpi_perf_data[cpu] in
>  acpi_cpufreq_cpu_init() can be removed.

We will modify code in those places.
