Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbYBZCLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbYBZCLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbYBZCLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:11:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:18944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbYBZCLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:11:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,404,1199692800"; 
   d="scan'208";a="259581875"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-current-git hangs on boot
Date: Mon, 25 Feb 2008 18:12:55 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE9AA266@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200802241218.04617.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-current-git hangs on boot
Thread-Index: Ach210inlI6bJpDqSeOgrGA2piLovwBRY2dw
References: <1203789325.4063.9.camel@localhost> <6101e8c40802231100t3af57018r139de0b52cd556b5@mail.gmail.com> <1203833710.4006.3.camel@localhost> <200802241218.04617.rjw@sisk.pl>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Soeren Sonnenburg" <kernel@nn7.de>
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Feb 2008 02:11:25.0930 (UTC) FILETIME=[E3FA2CA0:01C8781C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
>Sent: Sunday, February 24, 2008 3:18 AM
>To: Soeren Sonnenburg
>Cc: Oliver Pinter; Linux Kernel; Pallipadi, Venkatesh
>Subject: Re: 2.6.25-current-git hangs on boot
>
>On Sunday, 24 of February 2008, Soeren Sonnenburg wrote:
>> On Sat, 2008-02-23 at 20:00 +0100, Oliver Pinter wrote:
>> > the pci=nommconf kernel parameter helped it?
>> 
>> yes indeed, this switch reliably helps to over come the hang at *this
>> stage* (I tried booting with booth the switch and w/o).
>> 
>> however with 50% chance I still see a hang directly after
>> 
>> cpuidle: using governor ladder
>
>Do you have CONFIG_CPU_IDLE set?  If you have, please try to 
>unset it and
>retest.
>

Rafael,

I am looking at the CPU_IDLE part of this regression. Just want to note
that there is another regression with needing pci=nommconf in current
git which was not required in .24. I am not sure whether you are already
tracking that as a different issue.

Thanks,
Venki
