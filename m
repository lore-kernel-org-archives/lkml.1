Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYA2Vze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYA2Vze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYA2VzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:55:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:62330 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYA2VzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:55:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,271,1199692800"; 
   d="scan'208";a="255739063"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: kernel BUG at drivers/block/cciss.c:1260! (with recent  linux-2.6  tree)
Date: Tue, 29 Jan 2008 13:53:58 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC7575C5@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080129213526.GE15220@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel BUG at drivers/block/cciss.c:1260! (with recent  linux-2.6  tree)
Thread-Index: AchivuDqI3jvmlblRaWOExOUngxs+wAAmC1A
References: <20080129182217.GK12400@plap3.qlogic.org> <20080129182833.GG15220@kernel.dk> <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk> <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk> <20080129210837.GA21785@plap3.qlogic.org> <20080129211634.GB15220@kernel.dk> <20080129212435.GC15220@kernel.dk> <1FE6DD409037234FAB833C420AA843EC757564@orsmsx424.amr.corp.intel.com> <20080129213526.GE15220@kernel.dk>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <mike.miller@hp.com>, <k-ueda@ct.jp.nec.com>, <j-nomura@ce.jp.nec.com>
X-OriginalArrivalTime: 29 Jan 2008 21:53:59.0630 (UTC) FILETIME=[741C96E0:01C862C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Will try this next.
>
> Should work even better since it avoids a lock and copy, but please do
> test if you have the time.

That one works too (survived two full builds at "make -j32" on the 16-way
system).

Thanks for the quick turnaround.

-Tony
