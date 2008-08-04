Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbYHDUiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbYHDUiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763311AbYHDUiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:38:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:47033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762208AbYHDUiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:38:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,306,1215414000"; 
   d="scan'208";a="425897401"
From: "Luck, Tony" <tony.luck@intel.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>, "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 4 Aug 2008 13:37:52 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj2at7Jtigh5owSRxKVSd3V/B4bJQABsMcg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com>
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

> Bisection on an x455 (2-node IA64) showed that commit
> 27ec4407790d075c325e1f4da0a19c56953cce23 (sched: make cpu_clock()
> globally synchronous) broke booting.

I'd bet resonable sums of money that we are (once again) accessing
per-cpu variables in code before ia64 has a chance to initialize
things so that they can actually work. :-(

-Tony
