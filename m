Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYA2VdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYA2VdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbYA2Vcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:32:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:57491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbYA2Vcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:32:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,271,1199692800"; 
   d="scan'208";a="294135308"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: kernel BUG at drivers/block/cciss.c:1260! (with recent  linux-2.6  tree)
Date: Tue, 29 Jan 2008 13:32:44 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC757564@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080129212435.GC15220@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel BUG at drivers/block/cciss.c:1260! (with recent  linux-2.6  tree)
Thread-Index: AchivXi9vvKPdxgVSsKmKqkc7Lbd2gAAMFug
References: <20080129180242.GZ15220@kernel.dk> <20080129180537.GA15220@kernel.dk> <20080129182217.GK12400@plap3.qlogic.org> <20080129182833.GG15220@kernel.dk> <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk> <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk> <20080129210837.GA21785@plap3.qlogic.org> <20080129211634.GB15220@kernel.dk> <20080129212435.GC15220@kernel.dk>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <mike.miller@hp.com>, <k-ueda@ct.jp.nec.com>, <j-nomura@ce.jp.nec.com>
X-OriginalArrivalTime: 29 Jan 2008 21:32:44.0897 (UTC) FILETIME=[7C4FC510:01C862BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Ah crap, I see the problem, nioc is most often equal to rioc. Dang.
>> Please try this bandaid, will push a real fix now.

Patches arriving faster than I can test :-) ... The bandaid appears to
be working (no hang yet).

> This is way cleaner.

Will try this next.

-Tony
