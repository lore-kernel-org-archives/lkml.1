Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbXLMQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbXLMQMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbXLMQMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:12:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:6280 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbXLMQMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:12:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,162,1196668800"; 
   d="scan'208";a="436868341"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: x86, ptrace: support for branch trace store(BTS)
Date: Thu, 13 Dec 2007 16:06:15 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401187085@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071213130814.GC28340@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86, ptrace: support for branch trace store(BTS)
thread-index: Acg9iUL+TBkmgnUAQpCHzXICUyBu4gAAfTgA
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com> <20071211145301.GA19427@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com> <20071212110330.GD1611@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D6DC@swsmsx413.ger.corp.intel.com> <20071213102939.GS8977@elte.hu> <029E5BE7F699594398CA44E3DDF5544401186D54@swsmsx413.ger.corp.intel.com> <20071213130814.GC28340@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       "Alan Stern" <stern@rowland.harvard.edu>
X-OriginalArrivalTime: 13 Dec 2007 16:06:16.0940 (UTC) FILETIME=[17907AC0:01C83DA2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Donnerstag, 13. Dezember 2007 14:08

>> Are you OK with this?
>
>this sounds a lot more flexible to me. Please, once it looks 
>good to all 

I will implement the ptrace ABI and the man pages and send them out for
review (I'll return -EOPNOTSUPP a few times) tomorrow.
I'll add support for the overflow signal in a later patch, once I
figured out how to do it.


>of us also extend LTP's ptrace bits with unit tests for these API 
>additions. (Cc: such LTP bits to subrata@linux.vnet.ibm.com)

I need to look into this. This will take some time, as well.

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

