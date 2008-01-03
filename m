Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYACBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYACBMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYACBME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:12:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:27415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYACBMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:12:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="248252758"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Wed, 2 Jan 2008 17:12:43 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE4FC4E4@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080102165157.2150f2d2.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Thread-Index: AchNoxB/ebTWoBc+SPeC/YzhXloGjQAAFRDQ
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org><924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com><20071130142058.816d1693.akpm@linux-foundation.org><924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com><4750CC78.9070105@rtr.ca><20071130190227.1976e682@laptopd505.fenrus.org><4750D180.6080001@rtr.ca><20071130191816.3e744205@laptopd505.fenrus.org><4750D585.1030200@rtr.ca><477C2143.8090406@rtr.ca><924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com> <20080102165157.2150f2d2.akpm@linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Mark Lord" <lkml@rtr.ca>, "Arjan van de Ven" <arjan@infradead.org>,
       <abelay@novell.com>, <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>
X-OriginalArrivalTime: 03 Jan 2008 01:12:00.0586 (UTC) FILETIME=[A48F5AA0:01C84DA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Wednesday, January 02, 2008 4:52 PM
>To: Pallipadi, Venkatesh
>Cc: Mark Lord; Arjan van de Ven; abelay@novell.com; 
>lenb@kernel.org; Ingo Molnar; linux-kernel@vger.kernel.org; 
>linux-acpi@vger.kernel.org
>Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch 
>added to -mm tree
>
>On Wed, 2 Jan 2008 16:06:20 -0800 "Pallipadi, Venkatesh" 
><venkatesh.pallipadi@intel.com> wrote:
>
>>  
>> 
>> >-----Original Message-----
>> >From: Mark Lord [mailto:lkml@rtr.ca] 
>> >Sent: Wednesday, January 02, 2008 3:42 PM
>> >To: Arjan van de Ven
>> >Cc: Pallipadi, Venkatesh; Andrew Morton; abelay@novell.com; 
>> >lenb@kernel.org; Ingo Molnar; linux-kernel@vger.kernel.org; 
>> >linux-acpi@vger.kernel.org
>> >Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch 
>> >added to -mm tree
>> >
>> >Arjan van de Ven wrote:
>> >> On Fri, 30 Nov 2007 22:31:17 -0500
>> >> Mark Lord <lkml@rtr.ca> wrote:
>> >> 
>> >>> Arjan van de Ven wrote:
>> >>>> On Fri, 30 Nov 2007 22:14:08 -0500
>> >>>> Mark Lord <lkml@rtr.ca> wrote:
>> >>>>
>> >>>>>> in -mm there is.. the QoS stuff allows you to set maximum
>> >>>>>> tolerable
>> >>>>> ..
>> >>>>>
>> >>>>> That's encouraging, I think, but not for 2.6.24.
>> >>>>>
>> >>>>>> latency. If your app cant take any latency, you should set
>> >>>>>> those... and the side effect is that the kernel will not do
>> >>>>>> long-latency C-states or P-state transitions..
>> >>>>> ..
>> >>>>>
>> >>>>> I don't mind the cpufreq changing (actually, I want it 
>to drop in
>> >>>>> cpugfreq to save power and keep the fan off), but the 
>> >C-states just
>> >>>>> kill this app.
>> >>>>>
>> >>>>> The app is VMware.  I force the max_state=1 when launching,
>> >>>> ah but then its' even easier... and can be done in 
>2.6.24 already.
>> >>>> VMWare after all has a kernel module, and the latency 
>stuff is in
>> >>>> 2.6.23 and 2.6.24 available inside the kernel already.
>> >>> ..
>> >>>
>> >>> Oh, I'm perfectly happy to write my own kernel module if 
>that's what
>> >> 
>> >> all you need to do in your kernel module is call
>> >> 
>> >> add_latency_constraint("mark_wants_his_mouse", 5);
>> >> 
>> >> or so
>> >..
>> >
>> >Dredging up an old regression again now:
>> >
>> >The "make my own module to replace /sys/.../max_cstate" doesn't work
>> >for the single-core machine we use a lot around here.
>> >
>> >VMware is totally sluggish unless I go to another text window 
>> >and do this:
>> >
>> >    while ( true ); do echo -n ; done
>> >
>> >At which point VMware performs well again,
>> >the same as with "echo 1 > max_cstate" in 2.6.23.
>> >
>> >Anyone got any suggestions on how to fix this regression
>> >or work around it for 2.6.24 ?
>> >
>> 
>> Easiest and clean way to do it is to have a driver with
>> set_acceptable_latency() for 1uS or so in init and
>> remove_acceptable_latency() at exit.
>
>err, you appear to be suggesting that Mark patch his kernel to 
>make it work
>as well as 2.6.23?  That would be a wrong answer.
>
>This regression was known six weeks ago.  What do we need to 
>do (or revert)
>to fix it in 2.6.24?
>

As I responded earlier here
http://www.ussg.iu.edu/hypermail/linux/kernel/0711.3/2348.html

This interface cannot be supported cleanly with cpuidle. The cleanest
way to do this is to go through latency interfaces. We have changed all
in kernel drivers to use this new interface. The issue here is, I
removed this sysfs interface without depracting it. We can call it a
regression and we can add it back for the moment. But, this will go from
sysfs sooner or later and latency interface has to be used in future.
And Mark earlier responded in this thread saying he is OK with adding
something in the kernel to get this working, That is the reason I
suggested the above option.

As I saw it 6 weeks back, max_cstate option works as a boot parameter. I
did not see anyone else (apart from Mark) saying they are depending on
this sysfs interface to change max_cstate at run time and Mark said he
can do with the kernel change if possible. Please let me know if you
think this interface is a must fix for .24. I will send a minimal patch
to add it back for .24 for !CPU_IDLE case.

Thanks,
Venki 
