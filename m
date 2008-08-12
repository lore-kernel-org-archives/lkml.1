Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbYHLUry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbYHLUry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYHLUrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:47:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:18251 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYHLUrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,197,1217833200"; 
   d="scan'208";a="428647223"
From: "Luck, Tony" <tony.luck@intel.com>
To: Simon Horman <horms@verge.net.au>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Aug 2008 13:47:37 -0700
Subject: RE: [patch] IA64: make rsvd_region and num_rsvd_regions static
Thread-Topic: [patch] IA64: make rsvd_region and num_rsvd_regions static
Thread-Index: Acj24bdaneHLKc6LRyCcv3dIB1ktMwF2rSAA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA30844AEFB@orsmsx505.amr.corp.intel.com>
References: <20080805095739.GA12078@verge.net.au>
In-Reply-To: <20080805095739.GA12078@verge.net.au>
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

> rsvd_region and num_rsvd_regions are only accessed in
> arch/ia64/kernel/setup.c, so they should be static.

Are you looking at -mm or linux-next?  In my tree I see:

arch/ia64/mm/contig.c:  for (i = 0; i < num_rsvd_regions; i++) {
arch/ia64/mm/contig.c:          range_end   = min(end, rsvd_region[i].start & PAGE_MASK);
arch/ia64/mm/contig.c:          free_start = PAGE_ALIGN(rsvd_region[i].end);

-Tony
