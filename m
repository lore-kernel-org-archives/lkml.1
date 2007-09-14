Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXINSuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXINSuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXINSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:50:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:39634 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXINSur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:50:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,256,1186383600"; 
   d="scan'208";a="279126028"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: cpu hotplug support broken in 2.6.23-rc3
Date: Fri, 14 Sep 2007 11:49:17 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F501619542@scsmsx415.amr.corp.intel.com>
In-Reply-To: <1189774257.3100.7.camel@chaos>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: cpu hotplug support broken in 2.6.23-rc3
Thread-Index: Acf2zpBmzbaAG8UATK+sJyzaHAxZqQAMSKDw
References: <20070827104350.GA2073@elf.ucw.cz> <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com> <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl> <1188822917.3406.0.camel@chaos> <20070904072744.GA30474@atrey.karlin.mff.cuni.cz> <1189713695.3974.23.camel@chaos>  <20070914123816.GE1671@elf.ucw.cz> <1189774257.3100.7.camel@chaos>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Jeff Chua" <jeff.chua.linux@gmail.com>,
       <rusty@rustycorp.com.au>, <vatsa@in.ibm.com>, <zwane@arm.linux.org.uk>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>
X-OriginalArrivalTime: 14 Sep 2007 18:50:31.0724 (UTC) FILETIME=[204BAEC0:01C7F700]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>Thomas Gleixner
>Sent: Friday, September 14, 2007 5:51 AM
>To: Pavel Machek
>Cc: Rafael J. Wysocki; Jeff Chua; rusty@rustycorp.com.au; 
>vatsa@in.ibm.com; zwane@arm.linux.org.uk; kernel list; Len Brown
>Subject: Re: cpu hotplug support broken in 2.6.23-rc3
>
>Pavel,
>
>On Fri, 2007-09-14 at 14:38 +0200, Pavel Machek wrote:
>> > I have an yet untested fix, which preserves the broadcast 
>state across
>> > the offline state, but Len is looking into it as well, 
>whether we can
>> > just reevaluate the power states (and the broadcast flags) 
>when a cpu
>> > becomes online again. If Len can do that easily for 
>2.6.23, I'd prefer
>> > that.
>> 
>> Is there a patch you want me to test? Or does Len have anything to
>> play with?
>
>Venki sent me an initial patch, but it has issues with the notify
>ordering. Find below my "cache the broadcast flags" version 
>for testing.
>

While wirting that patch, I knew solution could not be that simple :(.
Does the patch work for online offline case atleast?
Will look at the Suspend/Resume ordering part in that case.

Thanks,
Venki
