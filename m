Return-Path: <linux-kernel-owner+w=401wt.eu-S935969AbYEBTfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935969AbYEBTfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbYEBTfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:35:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:22045 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbYEBTfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,428,1204531200"; 
   d="scan'208";a="559939294"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [git head] Should X86_PAT really default to yes?
Date: Fri, 2 May 2008 12:37:32 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEFB8D3D@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200805022122.03576.elendil@planet.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [git head] Should X86_PAT really default to yes?
Thread-Index: AcisieMC5OgeyphCQF2Sr3jySCzsswAAbjdQ
References: <200805022122.03576.elendil@planet.nl>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Frans Pop" <elendil@planet.nl>, <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
X-OriginalArrivalTime: 02 May 2008 19:34:59.0485 (UTC) FILETIME=[9BD3F4D0:01C8AC8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Frans Pop [mailto:elendil@planet.nl] 
>Sent: Friday, May 02, 2008 12:22 PM
>To: linux-kernel@vger.kernel.org
>Cc: Pallipadi, Venkatesh; Ingo Molnar
>Subject: [git head] Should X86_PAT really default to yes?
>
>With X86_PAT enabled, when X is started I get about 40 lines 
>(with varying 
>addresses) like:
>kernel: Xorg:3358 /dev/mem expected mapping type write-back for 
>807bf000-81000000, got uncached-minus
>
>And when X exits I get a bunch of lines like:
>kernel: Xorg:3349 freeing invalid memtype 80020000-8002a000
>
>I also noticed artifacts (a band of about 2 cm high across the 
>screen) after 
>X goes to black but before the switch to VT1.
>
>When I unset X86_PAT all this disappeared.
>
>Apparently this has been seen before:
>http://lkml.org/lkml/2008/5/2/139
>
>The author of that mail also points to:
>http://marc.info/?l=linux-kernel&m=120612742217604&w=2
>
>Is this a bug in PAT or not. If it is, should PAT really be 
>recommended to 
>be enabled by default?
>
>System: Intel desktop with D945GCZ mainboard
>        Intel(R) Pentium(R) D CPU 3.20GHz
>        x86_64 kernel; Debian unstable
>Video:  00:02.0 VGA compatible controller [0300]:
>        Intel Corporation 82945G/GZ Integrated Graphics Controller
>        [8086:2772] (rev 02)
>

Copying the X-guys.
The messages all look like debug messages from X and should not cause
any side-effects other than little annoyance. I am not sure why band of
2 cm is there...
Do you see any performance difference with or without PAT.

Thanks,
Venki
