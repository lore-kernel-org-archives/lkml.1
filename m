Return-Path: <linux-kernel-owner+w=401wt.eu-S938133AbYD1VVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938133AbYD1VVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935206AbYD1VV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:21:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:26957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbYD1VVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,718,1199692800"; 
   d="scan'208";a="239094294"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ARCH: Fix 32-bit x86 MSI-X allocation leakage
Date: Mon, 28 Apr 2008 14:21:26 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32904F9ED1F@orsmsx414.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.1.10.0804282313040.3261@apollo.tec.linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ARCH: Fix 32-bit x86 MSI-X allocation leakage
Thread-Index: AcipdRSWMzixYLU0S9u7jF7v1/RHmwAAIE3A
References: <20080426005850.7098.77479.stgit@scrappy.jf.intel.com> <alpine.LFD.1.10.0804282216570.3261@apollo.tec.linutronix.de> <D5C1322C3E673F459512FB59E0DDC32904F9EC8C@orsmsx414.amr.corp.intel.com> <alpine.LFD.1.10.0804282313040.3261@apollo.tec.linutronix.de>
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, <netdev@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2008 21:21:23.0415 (UTC) FILETIME=[CF4B5E70:01C8A975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, that makes sense. I just did not get the context out of 
> your commit log. Adding the commit which caused the trouble 
> to the commit log makes it easier to understand. So the 
> problem is unrelated to the merger, it's caused by a patch 
> which was pending against the i386 tree around the time of 
> the merger and which was converted to the merge tree.

That's my miss for not including the specific context.  I will try to be
better about that in the future.  I do appreciate the interest though to
make sure it's specifically understood when this bug was introduced.

Cheers,

-PJ Waskiewicz
