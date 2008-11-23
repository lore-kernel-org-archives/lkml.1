Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYKWGK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYKWGK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 01:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYKWGKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 01:10:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:35994 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750801AbYKWGKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 01:10:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,653,1220252400"; 
   d="scan'208";a="466324744"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'mingo@elte.hu'" <mingo@elte.hu>
Date: Sat, 22 Nov 2008 22:10:05 -0800
Subject: RE: [PATCH] IA64: fix VT-d dma_mapping_error
Thread-Topic: [PATCH] IA64: fix VT-d dma_mapping_error
Thread-Index: AclMwRk2LoDs6XEPTKGo613obrhMeAAcDEaQ
Message-ID: <A6AD88C3F2289247BE726C37303E1EB88EAB5850@orsmsx505.amr.corp.intel.com>
References: <20081122215822A.fujita.tomonori@lab.ntt.co.jp>
	<A6AD88C3F2289247BE726C37303E1EB88EAB57E1@orsmsx505.amr.corp.intel.com>
 <20081123014037A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081123014037A.fujita.tomonori@lab.ntt.co.jp>
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

>Hmm, intel_dma_mapping_error is used to test only the value that
>intel_map_single() returns. If intel_map_single() returns a non-zero
>dma address, it belongs to hwdev's domain. So intel_dma_mapping_error
>can simply return 1 (failure) if the dma_addr is zero.

Then there is no usage of hwdev which is one of two parameters in intel_dma_mapping_error?

Maybe checking dma_addr only is good enough for the function? At least it's fast to check errors.

Thanks.

-Fenghua
