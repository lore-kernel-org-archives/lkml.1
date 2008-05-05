Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYEEG0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYEEG0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYEEGZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:25:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYEEGZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:25:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,436,1204531200"; 
   d="scan'208";a="241983604"
Content-class: urn:content-classes:message
Subject: RE: [patch] x86, ptrace: in-kernel BTS interface
Date: Mon, 5 May 2008 07:25:53 +0100
MIME-Version: 1.0
Message-ID: <029E5BE7F699594398CA44E3DDF5544401D10FF3@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080430160611.GD20451@one.firstfloor.org>
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: in-kernel BTS interface
thread-index: Aciq2z8mcU4vf10UQV+Xecprf4pO3ADnWYFQ
References: <20080430135440.A359@sedona.ch.intel.com> <20080430130305.GC20451@one.firstfloor.org> <029E5BE7F699594398CA44E3DDF5544401CE236A@swsmsx413.ger.corp.intel.com> <20080430160611.GD20451@one.firstfloor.org>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <andi-suse@firstfloor.org>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 05 May 2008 06:25:49.0163 (UTC) FILETIME=[DC1373B0:01C8AE78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Mittwoch, 30. April 2008 18:06

>> >I'm not quite sure on the kernel interface. How would a in kernel
>> >subsystem use it for tracing itself for example?
>> 
>> The task parameter would be current.
>> 
>> Apart from that, you would use it the same way it is used in
>> arch/x86/kernel/ptrace.c.
>
>Hmm, sounds a little too complicated. Surely that could be easier?

Actually, it's just a bts_request() followed by a bts_configure() call.

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

