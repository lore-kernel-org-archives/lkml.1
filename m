Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYCZRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYCZRGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbYCZRGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:06:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:43326 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbYCZRGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:06:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,559,1199692800"; 
   d="scan'208";a="540414731"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: larger default page sizes...
Date: Wed, 26 Mar 2008 10:05:16 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE9E7AC@orsmsx424.amr.corp.intel.com>
In-reply-to: <29495f1d0803260854j46d37eedrc0927af226b3b8c8@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: larger default page sizes...
Thread-Index: AciPW5kaTHwmg/O7SBy/ezEKZyE0DgABsbQQ
References: <18408.29107.709577.374424@cargo.ozlabs.ibm.com> <20080324.211532.33163290.davem@davemloft.net> <18408.59112.945786.488350@cargo.ozlabs.ibm.com> <20080325.163240.102401706.davem@davemloft.net> <1FE6DD409037234FAB833C420AA843ECE9E2CA@orsmsx424.amr.corp.intel.com> <29495f1d0803260854j46d37eedrc0927af226b3b8c8@mail.gmail.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Cc: "David Miller" <davem@davemloft.net>, <paulus@samba.org>,
       <clameter@sgi.com>, <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       <torvalds@linux-foundation.org>, <agl@us.ibm.com>,
       "Mel Gorman" <mel@csn.ul.ie>
X-OriginalArrivalTime: 26 Mar 2008 17:05:19.0928 (UTC) FILETIME=[924F8B80:01C88F63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's not entirely true. We have a dynamic pool now, thanks to Adam
> Litke [added to Cc], which can be treated as a high watermark for the
> hugetlb pool (and the static pool value serves as a low watermark).
> Unless by hugepages you mean something other than what I think (but
> referring to a 2M size on x86 imples you are not). And with the
> antifragmentation improvements, hugepage pool changes at run-time are
> more likely to succeed [added Mel to Cc].

Things are better than I thought ... though the phrase "more likely
to succeed" doesn't fill me with confidence.  Instead I imagine a
system where an occasional spike in memory load causes some memory
fragmentation that can't be handled, and so from that point many of
the applications that relied on huge pages take a 10% performance
hit.  This results in sysadmins scheduling regular reboots to unjam
things. [Reminds me of the instructions that came with my first
flatbed scanner that recommended rebooting the system before and
after each use :-( ]

> I feel like I should promote libhugetlbfs here.

This is also better than I thought ... sounds like some really
good things have already happened here.

-Tony
