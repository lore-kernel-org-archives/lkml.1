Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYCQQRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYCQQRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYCQQR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:17:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:36852 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYCQQR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:17:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,513,1199692800"; 
   d="scan'208";a="219590697"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Date: Mon, 17 Mar 2008 09:09:15 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECD410F3@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080317204810.7B4F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Thread-Index: AciIJbY6BasOwI92S5uRluvB5preDgAIrG4g
References: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080317204810.7B4F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       <linux-ia64@vger.kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 17 Mar 2008 16:09:16.0128 (UTC) FILETIME=[3F9CA600:01C88849]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> seto-san teach me method of more investigate.
> and I found the root cause is contained by following patch.
>
>   [IA64] Multiple outstanding ptc.g instruction support

Thank you very much for your testing, and for isolating the
cause of this regression.

> 2.6.25-rc5:     works well
> 2.6.25-rc5-mm1: doesn't finish >12 hour

How long does hackbench take to complete on 2.6.25-rc5?
Does -mm1 hang completely?  Or is it making slow progress?

> Could you please revert that patch from ia64?

I'll revert it while I investigate the cause of this
problem and try to find a way to avoid this problem.

> I dislike its strong regression.

Me too!

-Tony
