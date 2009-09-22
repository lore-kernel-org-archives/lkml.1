Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZIVUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZIVUtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZIVUtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:49:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:34029 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbZIVUta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,433,1249282800"; 
   d="scan'208";a="552840096"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Sep 2009 13:49:32 -0700
Subject: RE: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
	percpu and drop the old one
Thread-Topic: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
	percpu and drop the old one
Thread-Index: Aco7XQHoshjCJG79TD652cfgIyS8vgAaKYnA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E29CCA8E@orsmsx505.amr.corp.intel.com>
References: <1253605214-23210-1-git-send-email-tj@kernel.org>
 <20090922081631.GD1475@elte.hu>
In-Reply-To: <20090922081631.GD1475@elte.hu>
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

> Contig memory model was verified with ski emulator.  Discontig and
> sparse models were verified on a 4-way SGI altix machine.  I've run
> percpu stress test module for quite a while on the machine.

Ski must have missed something.  I just tried to boot this on a
"tiger_defconfig" kernel[1] and it panic'd early in boot.  I'll need
to re-connect my serial console to get the useful part of the
panic message ... what's on the VGA console isn't very helpful :-(

-Tony

[1] uses contig.c
