Return-Path: <linux-kernel-owner+w=401wt.eu-S1763429AbXIUT7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763429AbXIUT7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762551AbXIUT7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:59:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:3314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762515AbXIUT7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:59:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="300303264"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86_64: potential critical issue with quicklists and page table pages
Date: Fri, 21 Sep 2007 12:59:20 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A027C22D4@scsmsx411.amr.corp.intel.com>
In-reply-to: <Pine.LNX.4.64.0709211249330.18088@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86_64: potential critical issue with quicklists and page table pages
Thread-Index: Acf8iZDiHV6qq8dBSrChMeeyw34WRQAABN3A
References: <20070921180742.GH20863@linux-os.sc.intel.com> <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org> <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org> <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org> <Pine.LNX.4.64.0709211221560.17698@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0709211235220.16478@woody.linux-foundation.org> <Pine.LNX.4.64.0709211249330.18088@schroedinger.engr.sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <ak@suse.de>,
       <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
X-OriginalArrivalTime: 21 Sep 2007 19:59:21.0632 (UTC) FILETIME=[E6CDE200:01C7FC89]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The quicklists have a long history and this bug has therefore also been in 
> IA64 for a long time and it also likely exists on sparc64, sh and sh64. We 
> need the patch that I posted to fix the other platforms. And with this fix 
> there would be nothing amiss on x86_64 either.

IA64 doesn't do a pgd>pud>pmd>pte table walk in h/w.  The VHPT leaps
straight to the pte page (through the virtual mapping of the VHPT). So
this wasn't a problem for IA64.

-Tony
