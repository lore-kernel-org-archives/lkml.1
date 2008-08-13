Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYHMUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYHMUMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYHMUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:12:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:13994 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYHMUME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:12:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,203,1217833200"; 
   d="scan'208";a="428966464"
From: "Luck, Tony" <tony.luck@intel.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 13 Aug 2008 13:11:45 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj9eun6JMSj3yA+Tp6TYXSH/55H4AABX/IQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3084A65FD@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
 <57C9024A16AD2D4C97DC78E552063EA30844B26C@orsmsx505.amr.corp.intel.com>
 <20080813162553.GA5720@elte.hu> <20080813192909.GA31685@us.ibm.com>
In-Reply-To: <20080813192909.GA31685@us.ibm.com>
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

> Well Peter's patch was tested-by me, so I know it fixes the problem on
> the box I have access to, I'm verifying that -rc3 is ok.
>
> Tony, would you like me to test your patch in isolation (reverting
> c1955a3d4762e7a9bf84035eb3c4886a900f0d15) to see if it also fixes it?

It would be nice to know ... I expect that you'll see crazy numbers
for the timestamps on the first few printk()s without Peter's fix (I
did on my system).

-Tony
