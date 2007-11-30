Return-Path: <linux-kernel-owner+w=401wt.eu-S935292AbXK3Pwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbXK3Pwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762273AbXK3Pwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:52:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:65351 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbXK3Pwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:52:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,235,1194249600"; 
   d="scan'208";a="329406456"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Date: Fri, 30 Nov 2007 15:45:31 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF554440105236A@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200711301134.04719.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
thread-index: AcgzPVCg4Ww33dqcQ9OdxVPQ5HVYEAAJh8JQ
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org> <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com> <200711301134.04719.ak@suse.de>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <ak@suse.de>, <tglx@linutronix.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       <markus.t.metzger@gmail.com>
X-OriginalArrivalTime: 30 Nov 2007 15:45:30.0513 (UTC) FILETIME=[09441010:01C83368]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Not yet. We are talking to internal teams regarding gdb support.
>
>But you already have reasonably realistic test code right?

I wrote a small program to talk to ptrace and look at the trace of small
sample programs to test the patch. I do this on P4 32bit and Core2
64bit.

Our debugger team has a prototype implementation for their debugger. But
that will not be available for some time.

I hope that we get gdb support, soon, but that would take a while 
if I had to do it.


>e.g. I'm still feeling a bit uneasy about that global sysctl
>embedded in the interface.

I added a ptrace command to query for the maximal buffer size and moved
the macro to ptrace_bts.h.
I am not sure how much flexibility is actually needed, here. I would
expect
the trace to be very useful near its tail, but unmanageable when it gets
too big.
I would rather add flexibility when and where it is needed.


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
