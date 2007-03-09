Return-Path: <linux-kernel-owner+w=401wt.eu-S1767529AbXCIVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767529AbXCIVDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993134AbXCIVDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:03:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:33423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993126AbXCIVDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:03:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,268,1170662400"; 
   d="scan'208"; a="193355559:sNHT29918784"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Date: Fri, 9 Mar 2007 13:03:31 -0800
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A4020CD43E@orsmsx415.amr.corp.intel.com>
In-Reply-To: <45F19ACD.6030906@linux.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Thread-Index: AcdicU1dRaski8kQTTONEFKM9A09CgAHHBTA
From: "Moore, Robert" <robert.moore@intel.com>
To: "Alexey Starikovskiy" <alexey.y.starikovskiy@linux.intel.com>,
       "Jean Delvare" <khali@linux-fr.org>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Rudolf Marek" <r.marek@assembler.cz>, <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>, "Therien, Guy" <guy.therien@intel.com>,
       "Walz, Michael" <michael.walz@intel.com>
X-OriginalArrivalTime: 09 Mar 2007 21:03:32.0326 (UTC) FILETIME=[65082860:01C7628E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No ACPI discussion can be complete without mentioning Microsoft and
Microsoft compatibility -- Windows does not fully support ACPI 2.0 to
this day, even though it was released in the year 2000, and ACPI 3.0 has
been out since 2004.

> -----Original Message-----
> From: Alexey Starikovskiy
[mailto:alexey.y.starikovskiy@linux.intel.com]
> Sent: Friday, March 09, 2007 9:35 AM
> To: Jean Delvare
> Cc: Pavel Machek; Moore, Robert; Matthew Garrett; Chuck Ebbert; Rudolf
> Marek; linux-acpi@vger.kernel.org; linux-kernel;
lm-sensors@lm-sensors.org
> Subject: Re: [lm-sensors] Could the k8temp driver be interfering with
> ACPI?
> 
> Jean Delvare wrote:
> > Hi Alexey,
> >
> > On Fri, 09 Mar 2007 13:39:33 +0300, Alexey Starikovskiy wrote:
> >
> >> Jean Delvare wrote:
> >>
> >>> I can only second Pavel's wish here. This would be highly
convenient
> >>> for OS developers to at least know which resources are accessed by
AML
> >>> and SMM. Without this information, we can never be sure that
OS-level
> >>> code won't conflict with ACPI or SMM.
> >>>
> >> BIOS vendors are not required to support latest and greatest ACPI
spec.
> >> So even if some future spec version
> >> will include this ports description, we will still have majority of
> >> hardware not exporting it...
> >>
> >
> > Your reasoning is amazing. So we should refrain from proposing any
> > improvement which we aren't certain 100% of the systems will support
> > tomorrow? Then let's all stay away from our keyboards forever, as
the
> > evolution of computer technology is based on exactly that -
> > improvements which not all systems implement.
> >
> > It's friday evening, let's have some more for fun. With a similar
> > logic, ten years ago we'd have come up with the following
conclusions:
> >
> > The majority of computers have a single CPU, there is no point in
> > adding SMP support to Linux.
> >
> > Let's not add a new instruction set in our next CPU family. The
> > majority of systems will not implement it so it will be useless
anyway.
> >
> > There's no point in supporting PnP in Linux, there are a majority of
> > legacy ISA cards out there which do not support it anyway!
> >
> > See my point? Just because not every hardware out there supports a
> > given standard doesn't make that standard necessarily useless.
> >
> > Just make the next version of ACPI better than the previous one (not
> > necessarily a challenge) and everyone will embrace it.
> >
> >
> You get me wrong, I'm not against the proposal, so keep your breath.
> I'm just saying that you get old waiting for BIOS vendors to export
this
> info, even if it's in spec.
> 
> Regards,
> Alex.
