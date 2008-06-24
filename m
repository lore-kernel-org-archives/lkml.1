Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYFXRmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYFXRmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYFXRm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:42:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:44677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbYFXRm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:42:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,697,1204531200"; 
   d="scan'208";a="401455865"
From: "Luck, Tony" <tony.luck@intel.com>
To: Julia Lawall <julia@diku.dk>,
       "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 24 Jun 2008 10:42:22 -0700
Subject: RE: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Thread-Topic: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Thread-Index: AcjV02r92Re9xBMoSreFnBqpQcF2TAATd5jg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3062D2438@orsmsx505.amr.corp.intel.com>
References: <Pine.LNX.4.64.0806241021360.26777@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0806241021360.26777@ask.diku.dk>
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

> As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
> alloc_bootmem and related functions never return NULL and always return a
> zeroed region of memory.  Thus a NULL test or memset after calls to these
> functions is unnecessary.

There is no commit b1fceac2b9e04d278316b2faddf276015fc06e3b in Linus' tree.

In addition the current alloc_bootmem() is a macro that uses __alloc_bootmem
which most defintely can return NULL.

Is this against -mm or linux-next?

-Tony
