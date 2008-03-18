Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYCRAiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYCRAiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYCRAin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:38:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:50533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYCRAim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:38:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,515,1199692800"; 
   d="scan'208";a="356306527"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Date: Mon, 17 Mar 2008 17:36:15 -0700
Message-ID: <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Thread-Index: AciIiOn/+TmaaHxGQ4O/mypTuuh/ggABpzbg
References: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1FE6DD409037234FAB833C420AA843ECD412F8@orsmsx424.amr.corp.intel.com> <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Luck, Tony" <tony.luck@intel.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 18 Mar 2008 00:36:16.0575 (UTC) FILETIME=[139C7CF0:01C88890]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > % ./hackbench 130 process 500
> > 2.6.25-rc5:     works well
> > 2.6.25-rc5-mm1: doesn't finish >12 hour
>cpu: Itanium2 x8
>mem: 8GB(4GB x2 node)

On Itanium2x8 w/ 8GB on 1 node, All of 2.6.24, 2.6.25-rc5 and
2.6.25-rc5-mm1 shows same "out of memory" within one minute. I haven't
seen spinlock lockup issue yet.

Thanks.

-Fenghua
