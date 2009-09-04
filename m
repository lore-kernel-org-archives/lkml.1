Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZIDUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZIDUGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbZIDUGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:06:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:39296 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbZIDUG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,334,1249282800"; 
   d="scan'208";a="547913885"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
CC: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Date: Fri, 4 Sep 2009 13:06:28 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcosOvcRmPGETVeJSdKuTHDWtdPQvQBX3SEg
Message-ID: <9EECC02A4CC333418C00A85D21E8932601841D4A66@azsmsx502.amr.corp.intel.com>
References: <4A846581.2020304@redhat.com>
 <20090813211626.GA28274@cmpxchg.org> <4A850F4A.9020507@redhat.com>
 <20090814091055.GA29338@cmpxchg.org> <20090814095106.GA3345@localhost>
 <4A856467.6050102@redhat.com> <20090815054524.GB11387@localhost>
 <9EECC02A4CC333418C00A85D21E89326B6611E81@azsmsx502.amr.corp.intel.com>
 <20090818022609.GA7958@localhost>
 <9EECC02A4CC333418C00A85D21E893260184184010@azsmsx502.amr.corp.intel.com>
 <20090903020452.GA9474@localhost>
In-Reply-To: <20090903020452.GA9474@localhost>
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

Stupid question - what in your patch allows a text page get kicked out to the inactive list after you've given it an extra pass through the active list?

					Jeff
