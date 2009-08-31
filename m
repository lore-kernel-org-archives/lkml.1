Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZHaTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZHaTnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZHaTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:43:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:35270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZHaTnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:43:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,307,1249282800"; 
   d="scan'208";a="489090736"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Date: Mon, 31 Aug 2009 12:43:07 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcoijLeuFH1es+LlR+aUeqAHGWdDTwH5gsBQ
Message-ID: <9EECC02A4CC333418C00A85D21E8932601841832F9@azsmsx502.amr.corp.intel.com>
References: <4A7AAE07.1010202@redhat.com>
 <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost>
 <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost>
 <4A7AD79E.4020604@redhat.com> <20090816032822.GB6888@localhost>
 <4A878377.70502@redhat.com> <20090816045522.GA13740@localhost>
 <9EECC02A4CC333418C00A85D21E89326B6611F25@azsmsx502.amr.corp.intel.com>
 <20090821182439.GN29572@balbir.in.ibm.com>
In-Reply-To: <20090821182439.GN29572@balbir.in.ibm.com>
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

> What do the stats for / from within kvm look like?

Interesting - what they look like is inactive_anon is always zero.  Details below - I took the host numbers at the same time and they are similar to what I reported before.

					Jeff

The fields are inactive_anon, active_anon, inactive_file, active_file - shortly after the data started being collected, I started firefox and an editor thingy.  The data continues as far into the shutdown as it could.

0 10858 13516 3279
0 10872 13516 3286
0 10867 13513 3286
0 11455 13268 3552
0 13068 12871 3949
0 13281 12810 4012
0 13701 12719 4103
0 14133 12631 4191
0 10878 11742 5087
0 10878 11741 5085
0 10878 11741 5085
0 10877 11741 5085
0 10877 11741 5085
0 10878 11741 5085
0 10878 11741 5085
0 10877 11741 5085
0 10905 11741 5085
0 11118 11776 5106
0 11594 14541 5169
0 11084 15314 5248
0 12022 15686 5300
0 12813 16379 5608
0 13614 16744 5915
0 14230 16849 5936
0 14461 16943 5953
0 14706 17412 5967
0 15574 17445 6011
0 15623 17459 6011
0 15596 17461 6015
0 15941 17523 6048
0 16508 17684 6048
0 17095 18154 6056
0 18635 18175 6056
0 18867 18195 6060
0 18972 18195 6060
0 18975 18185 6073
0 19220 18234 6073
0 19809 18276 6076
0 19571 18276 6076
0 19567 18276 6076
0 19588 18276 6076
0 19588 18276 6076
0 19588 18276 6076
0 19589 18276 6076
0 19603 18276 6076
0 19607 18277 6077
0 19600 18277 6077
0 19034 18235 6119
0 19041 18235 6119
0 19040 18233 6121
0 19040 18233 6121
0 18724 18240 6121
0 11674 16376 7977
0 11674 16376 7977
0 11673 16376 7977
0 11708 16376 7977
0 11703 16374 7979
0 11703 16374 7979
0 11702 16374 7979
0 11702 16374 7979
0 11716 16374 7979
0 11716 16374 7979
0 11718 16374 7979
0 11711 16374 7979
0 11811 16413 7986
0 11811 16413 7986
0 11897 16413 7986
0 12247 16434 7986
0 12495 16457 7990
0 12495 16457 7990
0 12491 16457 7990
0 12491 16457 7990
0 12737 16457 7990
0 11844 16457 7990
0 10969 16436 8011
0 9586 16140 8328
0 9209 16253 8333
0 8467 16120 8550
0 7857 16504 8592
0 7215 16467 8681
0 7194 16481 8723
0 7155 16475 8730
