Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYHMAhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYHMAhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYHMAhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:37:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:44013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYHMAho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,198,1217833200"; 
   d="scan'208";a="606281701"
From: "Luck, Tony" <tony.luck@intel.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>, "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Tue, 12 Aug 2008 17:37:28 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj2at7Jtigh5owSRxKVSd3V/B4bJQGcWw7w
Message-ID: <57C9024A16AD2D4C97DC78E552063EA30844B26C@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
In-Reply-To: <20080804194646.GA17390@us.ibm.com>
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

> I'm happy to test any better patches.

Linus just took a patch from my tree that should solve this
once and for all for ia64.

commit 10617bbe84628eb18ab5f723d3ba35005adde143
Author: Tony Luck <tony.luck@intel.com>
Date:   Tue Aug 12 10:34:20 2008 -0700

    [IA64] Ensure cpu0 can access per-cpu variables in early boot code


When you get a chance please test with your config against this
tree just to confirm that this is fixed.

Thanks

-Tony
