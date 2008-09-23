Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbYIWLad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbYIWLad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYIWLaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:30:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:40403 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYIWLaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:30:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,452,1217833200"; 
   d="scan'208";a="339497135"
Content-class: urn:content-classes:message
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [patch] x86, ptrace: void dopiness
Date: Tue, 23 Sep 2008 12:30:17 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF55444027827AD@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080922120743.GF14301@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: void dopiness
Thread-Index: Ackcq+e6kioxmbGQTw6CXKsm1UUHygAwz7bQ
References: <20080919145250.A6000@sedona.ch.intel.com> <20080922115058.GB14301@elte.hu> <029E5BE7F699594398CA44E3DDF5544402781F00@swsmsx413.ger.corp.intel.com> <20080922120743.GF14301@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <markus.t.metzger@gmail.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, "Roland McGrath" <roland@redhat.com>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-OriginalArrivalTime: 23 Sep 2008 11:30:18.0344 (UTC) FILETIME=[C199FE80:01C91D6F]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Montag, 22. September 2008 14:08
>To: Metzger, Markus T

>> The void-cast is intentional in both cases.
>> 
>> I thought it a question of style, i.e. that we don't want void casts 
>> just like we want NULL instead of 0.
>
>ok.
>
>But you could mark ds_release_bts() as a __must_check 
>function, in that 
>case the (void) has functional aspects as well: the kernel build will 
>complain if a return value is ignored unintentionally.

Wouldn't every non-void function be __must_check?

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

