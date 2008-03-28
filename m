Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYC1XFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYC1XFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbYC1XFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:05:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:62446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbYC1XFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:05:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,572,1199692800"; 
   d="scan'208";a="362432325"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 16:07:07 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEC83E9A@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200803290001.18912.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25 regression: powertop says 120K wakeups/sec
Thread-Index: AciRJ8N+bWoBADKBQiiWqTYzodxLgwAAG0/A
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281509.23107.david-b@pacbell.net> <20080328225604.GA7136@linux-os.sc.intel.com> <200803290001.18912.rjw@sisk.pl>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>
X-OriginalArrivalTime: 28 Mar 2008 23:05:04.0331 (UTC) FILETIME=[287191B0:01C89128]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org 
>[mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael 
>J. Wysocki
>Sent: Friday, March 28, 2008 4:01 PM
>To: Pallipadi, Venkatesh
>Cc: David Brownell; Andrew Morton; 
>linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org; Len Brown
>Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
>
>On Friday, 28 of March 2008, Venki Pallipadi wrote:
>> On Fri, Mar 28, 2008 at 03:09:22PM -0700, David Brownell wrote:
>> > On Friday 28 March 2008, Pallipadi, Venkatesh wrote:
>> > > You should have a dmesg line which looks like
>> > > ACPI: CPU0 (power states: C1[C1] C2[C2]
>> > > Do you see C2 in such line?
>> > 
>> > Yes:
>> > 
>> > ACPI: CPU0 (power states: C1[C1] C2[C2])
>> 
>> 
>> David,
>> 
>> I think I figured out the bug...
>> 
>> Can you try the below patch and confirm that it works (over 
>upstream - ignore
>> the earlier revert patch I sent to you).
>> 
>> Thanks,
>> Venki
>> 
>> ----
>> 
>> 
>> Patch to fix huge number of wakeups reported due to recent changes in
>> processor_idle.c. The problem was that the entry_method 
>determination was
>> broken due to one of the recent commits (bc71bec91f987) causing
>> C1 entry to not to go to halt. This should also fix the hang 
>reported here.
>> http://bugzilla.kernel.org/show_bug.cgi?id=10093
>
>Ah, thanks for figuring that out.  As a regression fix, it 
>should go upstream
>ASAP, I think.
>

Lets just wait for confirmation from either David or in bug #10093. Yes.
Once we get that confirmation this should go upstream.

Thanks,
Venki
