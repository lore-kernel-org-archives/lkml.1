Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZHQSGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZHQSGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZHQSGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:06:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:62755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbZHQSGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,397,1246863600"; 
   d="scan'208";a="717562413"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Avi Kivity <avi@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Date: Mon, 17 Aug 2009 11:04:46 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: Acodb9X9DoCJS1pfSRmgKawPv9rmpQB8uNQA
Message-ID: <9EECC02A4CC333418C00A85D21E89326B6611E81@azsmsx502.amr.corp.intel.com>
References: <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com>
 <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com>
 <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org>
 <4A850F4A.9020507@redhat.com> <20090814091055.GA29338@cmpxchg.org>
 <20090814095106.GA3345@localhost> <4A856467.6050102@redhat.com>
 <20090815054524.GB11387@localhost>
In-Reply-To: <20090815054524.GB11387@localhost>
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

> Jeff, can you confirm if the mem cgroup's inactive list is small?

Nope.  I have plenty on the inactive anon list, between 13K and 16K pages (i.e. 52M to 64M).

The inactive mapped list is much smaller - 0 to ~700 pages.

The active lists are comparable in size, but larger - 16K - 19K pages for anon and 60 - 450 pages for mapped.

						Jeff

