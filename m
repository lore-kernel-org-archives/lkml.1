Return-Path: <linux-kernel-owner+w=401wt.eu-S935102AbXK3Pt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102AbXK3Pt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbXK3Ptr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:49:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:34675 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097AbXK3Ptq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:49:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,235,1194249600"; 
   d="scan'208";a="283606110"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Date: Fri, 30 Nov 2007 15:48:21 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401052377@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071130105450.GE9941@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
thread-index: AcgzP6qIu/g2piBvRIC0G1+OwREc1QAKGXRw
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org> <20071130105450.GE9941@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <hpa@zytor.com>, <tglx@linutronix.de>,
       <ak@suse.de>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       <markus.t.metzger@gmail.com>
X-OriginalArrivalTime: 30 Nov 2007 15:48:20.0719 (UTC) FILETIME=[6EB76FF0:01C83368]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>yep, i already tried to check how well it integrates to x86.git:

I ported it to scm/linux/kernel/git/x86/linux-2.6-x86.git mm.
I will send out the patch and then look at the below discussion.


>the code does not seem to be layered correctly: i'd suggest to 
>read the 
>discussion between Roland McGrath and Alan Stern on lkml, about kwatch 
>-> hw_breakpoint, to see how a more general debugging framework 
>can/should be built. These things shouldnt be limited to user-space 
>alone, the kernel could probably use hardware tracing even more than 
>user-space could. (because it's a much harder to debug environment)


regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
