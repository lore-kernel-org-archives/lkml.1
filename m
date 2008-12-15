Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYLOVtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYLOVtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbYLOVtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:49:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:20342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbYLOVtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:49:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,226,1228118400"; 
   d="scan'208";a="474214025"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2008 13:50:05 -0800
Subject: RE: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
 remap_pfn_range and vm_insert_pfn
Thread-Topic: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
 remap_pfn_range and vm_insert_pfn
Thread-Index: AclPXfMhx6On1dDbSIa6A6ZjJPtTzwPoNiWQ
Message-ID: <7E82351C108FA840AB1866AC776AEC464338C11E@orsmsx505.amr.corp.intel.com>
References: <20081126002157.475142000@intel.com>
In-Reply-To: <20081126002157.475142000@intel.com>
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


Ingo,

Haven't seen any comments on the patches here. Can you push these patches along to tip.

Thanks,
Venki

>-----Original Message-----
>From: Pallipadi, Venkatesh
>Sent: Tuesday, November 25, 2008 4:22 PM
>To: akpm@linux-foundation.org; npiggin@suse.de;
>hugh@veritas.com; mingo@elte.hu; hpa@zytor.com; tglx@linutronix.de
>Cc: rdreier@cisco.com; jeremy@goop.org;
>jbarnes@virtuousgeek.org; arjan@infradead.org; linux-kernel@;
>Siddha, Suresh B
>Subject: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
>remap_pfn_range and vm_insert_pfn
>
>Followup for the patches posted earlier here:
>http://marc.info/?l=linux-kernel&m=122653213110404&w=2
>
>Drivers use mmap followed by pgprot_* and remap_pfn_range or
>vm_insert_pfn,
>in order to export reserved memory to userspace. Currently,
>such mappings are
>not tracked and hence not kept consistent with other mappings
>(/dev/mem,
>pci resource, ioremap) for the sme memory, that may exist in
>the system.
>
>The following patchset adds x86 PAT attribute tracking and
>untracking for
>pfnmap related APIs.
>
>First three patches in the patchset are changing the generic
>mm code to fit
>in this tracking. Last four patches are x86 specific to make
>things work
>with x86 PAT code. The patchset aso introduces
>pgprot_writecombine interface,
>which gives writecombine mapping when enabled, falling back to
>pgprot_noncached otherwise.
>
>
>--
>
>
