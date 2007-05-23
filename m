Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbXEWRod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbXEWRod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbXEWRoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:44:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:5173 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbXEWRoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:44:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,570,1170662400"; 
   d="scan'208";a="231319132"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Wed, 23 May 2007 10:44:16 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01882BFD@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070522234314.54081817.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: AcedBwFmoKSjsR0+SUaKO0YySaBg5AAWl1gA
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "David Chinner" <dgc@sgi.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 23 May 2007 17:44:17.0851 (UTC) FILETIME=[FC9748B0:01C79D61]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Saw this when running strace -f on a script on 2.6.21 on ia64:
> > 
> > BUG: sleeping function called from invalid context at kernel/fork.c:385
> > in_atomic():1, irqs_disabled():0
    ... snip ...
> > I could reproduce it via 'strace -f sleep 1'
> > 
>
> I'd say this is specific to ia64.   Someone would have spotted it on
> x86 by now.

I tried the "strace -f sleep 1" on 2.6.22-rc2, and I didn't see this "BUG"
there.  Can you try your other test cases on the latest kernel.  If it has
already been fixed we can see about identifying the patch for possible backport
to 2.6.21.stable

-Tony
