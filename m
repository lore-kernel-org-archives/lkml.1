Return-Path: <linux-kernel-owner+w=401wt.eu-S1764245AbXGaWi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764245AbXGaWi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXGaWis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:38:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:65528 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbXGaWiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:38:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,205,1183359600"; 
   d="scan'208";a="272849843"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: "Add support for vector domain" breaks boot on x355
Date: Tue, 31 Jul 2007 15:38:39 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A020E40A6@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070731221356.GA31324@us.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "Add support for vector domain" breaks boot on x355
Thread-Index: AcfTwBgNKWrLCAB0RCu1v4cgpwPsgwAAx1iA
From: "Luck, Tony" <tony.luck@intel.com>
To: "Nishanth Aravamudan" <nacc@us.ibm.com>, <isimatu.yasuaki@jp.fujitsu.com>
Cc: <kaneshige.kenji@jp.fujitsu.com>, <torvalds@linux-foundation.org>,
       <ryhodges@us.ibm.com>, <linux-ia64@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 31 Jul 2007 22:38:40.0900 (UTC) FILETIME=[8B176C40:01C7D3C3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The following commit (4994be1b3fe9120c88022ff5c0c33f6312b17adb) broke
> Linus' Tree between 2.6.22-git15 and 2.6.22-git16 on a 2-node 8-way x455
> (Madison procs). Thanks to Ryan Hodges for bisecting down to this
> commit.

Thanks for taking the time to do the git bisect to identify the problem commit.

Can you give some more details on the breakage please?  Does the system
hang or panic?  How far does it get through the boot process?  Are there
any suspicious looking differences in the console output before getting
to the failure point?

-Tony
