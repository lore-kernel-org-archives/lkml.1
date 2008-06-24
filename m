Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYFXV4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYFXV4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYFXVzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:55:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:7196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYFXVzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,698,1204531200"; 
   d="scan'208";a="299165533"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Tue, 24 Jun 2008 14:59:18 -0700
Subject: RE: [PATCH 0/7] x86: pat.c: reserve_memtype strip down
Thread-Topic: [PATCH 0/7] x86: pat.c: reserve_memtype strip down
Thread-Index: AcjTD5OVPVQhyev/QE24cAoE1tctKwDNa4LA
Message-ID: <7E82351C108FA840AB1866AC776AEC46064E2C2C@orsmsx505.amr.corp.intel.com>
References: <20080620195503.GB4105@alberich.amd.com>
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
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


Thanks for all the cleanup patches. Overall we have lesser number of lines of code which is a nice bonus.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

>-----Original Message-----
>From: Andreas Herrmann [mailto:andreas.herrmann3@amd.com]
>Sent: Friday, June 20, 2008 12:55 PM
>To: Ingo Molnar; H. Peter Anvin; Thomas Gleixner
>Cc: linux-kernel@vger.kernel.org; Pallipadi, Venkatesh;
>Siddha, Suresh B
>Subject: [PATCH 0/7] x86: pat.c: reserve_memtype strip down
>
>This patch set will (first of all) cleanup reserve_memtype a little
>bit to make it easier to read and maintain.
>
>(... and hopefully it doesn't break anything.;-)
>
>Overall diffstat is
>
> arch/x86/mm/ioremap.c  |    2
> arch/x86/mm/pat.c      |  263
>++++++++++++++++---------------------------------
> include/asm-x86/e820.h |    1
> 3 files changed, 93 insertions(+), 173 deletions(-)
>
>Instead of sending one large patch I broke it down into several pieces
>to make it easier to review.
>
>Patches are against today's tip/x86/pat (v2.6.26-rc6-107-gdd0c7c4).
>Please apply.
>
>
>Thanks,
>
>Andreas
>
>
>
