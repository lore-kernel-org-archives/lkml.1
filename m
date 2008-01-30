Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYA3MxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYA3MxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYA3MxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:53:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:33935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbYA3MxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:53:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,277,1199692800"; 
   d="scan'208";a="294321787"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: ptrace API extensions for BTS
Date: Wed, 30 Jan 2008 12:52:40 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444014A581D@swsmsx413.ger.corp.intel.com>
In-Reply-To: <7c86c4470801300301n426f3ab4n94419db3a5553936@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ptrace API extensions for BTS
thread-index: AchjL7cvNVKGHzaJTOGPcb5RRD2S9wABy0Dw
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com> <20080130072557.EC73C26F9A7@magilla.localdomain> <029E5BE7F699594398CA44E3DDF55444014A55DD@swsmsx413.ger.corp.intel.com> <7c86c4470801300301n426f3ab4n94419db3a5553936@mail.gmail.com>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "stephane eranian" <eranian@googlemail.com>
Cc: "Roland McGrath" <roland@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <markus.t.metzger@gmail.com>
X-OriginalArrivalTime: 30 Jan 2008 12:52:44.0230 (UTC) FILETIME=[01AD8E60:01C8633F]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Mittwoch, 30. Januar 2008 12:01

>You can get information about the perfmon2 project at: 
>http://perfmon2.sf.net

I downloaded your patch for 2.6.23 and cloned your git repository.

>From a first glance, it looks like there is indeed a lot of overlap.


>I would like to take a look at your patches. Where can I get them?

You can find the changes in the mm branch of the x86 git. Do they keep
the patches there, somewhere, as well?

You should get the best overview if you look at arch/x86/kernel/ds.c,
include/asm-x86/ds.h, include/asm-x86/ptrace-abi.h, and
arch/x86/kernel/ptrace.c or simply grep for BTS.

I have all the patches that I submitted but they rather protocol
development than describe the final thing.


>My understanding at this point is that we would need to coordinate
>access to the
>DS_AREA. It would likely have to be mutually exclusive access. 

>From a brief look at your patch, I would say that we should rather
combine the configuration and collection part. They are very similar.

We might still want to provide different interfaces on top of it.
In particular, I think the ptrace interface is most appropriate for
debuggers.


>I am planning on
>adding support for LBRs in the next few months. But BTS the way it is
>currently defined
>is useless for performance monitoring. I think this a great debug
>feature, though.

Debugging was my target;-)


>Now, there is some preliminary perf. MSR allocator in the kernel.
>However, it does not know
>of all available MSRs out there. It focuses on the counters mostly.
>Perfmon, oprofile and
>the NMI watchdog use it. I think it could be generalized to other MSR
>(non-contiguous).
>
>I would be happy to work with you in refining this MSR allocator.


Are you planning to get the perfmon patch into the kernel? Or do you
want it to remain a separate patch?

In the first case, we should try to merge the features. In the second
case, refining the MSR allocator would probably be best.


thanks and regards,
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

