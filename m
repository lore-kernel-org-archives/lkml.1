Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbYBKSV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbYBKSV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYBKSVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:21:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:30990 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbYBKSVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:21:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,334,1199692800"; 
   d="scan'208";a="516695577"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-rc1 regression] Suspend to RAM (bisected)
Date: Mon, 11 Feb 2008 10:22:04 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE8608D3@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1202708864.5206.0.camel@zem>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc1 regression] Suspend to RAM (bisected)
Thread-Index: Achscprg9WmW3VDDSQKOeFuWYrdtLAAZ7nNA
References: <47AFDC4D.4070400@gmail.com> <1202708864.5206.0.camel@zem>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Calvin Walton" <calvin.walton@gmail.com>,
       "Carlos R. Mafra" <crmafra@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "Len Brown" <lenb@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 11 Feb 2008 18:20:56.0121 (UTC) FILETIME=[D7EAAA90:01C86CDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Calvin Walton [mailto:calvin.walton@gmail.com] 
>Sent: Sunday, February 10, 2008 9:48 PM
>To: Carlos R. Mafra
>Cc: linux-kernel@vger.kernel.org; Pallipadi, Venkatesh
>Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
>
>On Mon, 2008-02-11 at 03:25 -0200, Carlos R. Mafra wrote: 
>> Hi,
>> 
>> I want to report that suspend to RAM stopped working on my Sony Vaio 
>> VGN-FZ240E in 2.6.25-rc1 and that I could bisect the problem down
>> to:
>> 
>> commit bc71bec91f9875ef825d12104acf3bf4ca215fa4
>> Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
>> Date:   Thu Jan 31 17:35:04 2008 -0800
>> 
>>     ACPI: enable MWAIT for C1 idle
>
>I normally hate to throw in a 'me-too', but I'm also seeing a
>suspend-to-ram regression on my Thinkpad R61i that I've managed to
>bisect down to the same patch series.
>

Carlos, Calvin,

Can you send me the output of acpidump and full dmesg to me. Looks like
it is a platform issue due to which we cannot use C1 mwait idle during
suspend resume, something similar to issue we had with using C2/C3 state
during idle.

Thanks,
Venki 
