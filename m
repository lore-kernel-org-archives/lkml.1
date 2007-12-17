Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbXLQN11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbXLQN11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbXLQN1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:27:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:4384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759939AbXLQN1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:27:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,176,1196668800"; 
   d="scan'208";a="298439668"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 1/5] x86, ptrace: remove bad comment
Date: Mon, 17 Dec 2007 13:25:55 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444011B4B2D@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071215072937.GB12110@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/5] x86, ptrace: remove bad comment
thread-index: Acg+7E5hKG26NXMcRTGf50Sl2YBGdQBnPfwQ
References: <20071214174858.A20475@sedona.ch.intel.com> <20071215072937.GB12110@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>
X-OriginalArrivalTime: 17 Dec 2007 13:25:57.0041 (UTC) FILETIME=[5B4F6210:01C840B0]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Samstag, 15. Dezember 2007 08:30

>another detail: shouldnt this be structured so that the APIs are 
>introduced in kernel/ptrace.c, and that the architecture offers the 
>mechanism. (which would thus be ptrace-independent) This would 
>also open 
>these APIs up to kernel-internal use and to be used by other 
>architectures.

Isn't this best done once we actually have at least one other
architecture?

The DS interface should be fine for kernel and user trace on x86, but it
may not be the best interface for other architectures.

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

