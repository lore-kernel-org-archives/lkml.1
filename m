Return-Path: <linux-kernel-owner+w=401wt.eu-S1763075AbYD3MnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763075AbYD3MnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYD3MnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:43:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:7596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbYD3MnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:43:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,728,1199692800"; 
   d="scan'208";a="276451453"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] x86, ptrace: in-kernel BTS interface
Date: Wed, 30 Apr 2008 13:43:20 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF5544401CE20DA@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080430052631.3d182670.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: in-kernel BTS interface
Thread-Index: AciqvZQQwLYNR9I+Q0eJlxfKrfFdQQAAMAtw
References: <20080430135440.A359@sedona.ch.intel.com> <20080430052631.3d182670.akpm@linux-foundation.org>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <andi-suse@firstfloor.org>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <mtk.manpages@gmail.com>, <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 30 Apr 2008 12:43:05.0991 (UTC) FILETIME=[BC9C8970:01C8AABF]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Mittwoch, 30. April 2008 14:27
>To: Metzger, Markus T

>> Provide an in-kernel interface to Branch Trace Store and 
>implement the
>> ptrace user interface on top of it.
>> 
>> Fix a few bugs that were detected during the perfmon2 adaptation to
>> the DS interface by Stephane Eranian.
>> 
>> The ptrace implementation becomes a rather thin layer that only
>> forwards requests.
>> 
>> The BTS interface may later be morphed into a utrace interface for
>> execution trace, or it may be used to implement such a utrace
>> interface on top of it.
>
>This appears to be against a version of x86-ptrace-pebs-support
>which I don't have.
>
>I dropped everything - let's start again.

That was against x86.git#latest.

Do you want me to send patches against some other git? Which one?

You complained about the size of the patch. If we start over, I could
split it into 3 pieces, one for each layer.


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

