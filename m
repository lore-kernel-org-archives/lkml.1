Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYDDUjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYDDUjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYDDUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:39:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:60983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbYDDUjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:39:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,606,1199692800"; 
   d="scan'208";a="312753481"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Date: Fri, 4 Apr 2008 13:41:45 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Thread-Index: AciWbEVLakuw0LpFTkCNK8MnydGR4wADhHhQAAZzpJA=
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.AOB.6GW9HB@albercik> <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com> <20080404011053.GA21254@localhost.ift.unesp.br> <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com> <20080404114756.GA3890@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0EB77@orsmsx423.amr.corp.intel.com> <20080404155155.GA6578@localhost.ift.unesp.br> 
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Soeren Sonnenburg" <kernel@nn7.de>
X-OriginalArrivalTime: 04 Apr 2008 20:39:35.0067 (UTC) FILETIME=[FE49D6B0:01C89693]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Pallipadi, Venkatesh 
>Sent: Friday, April 04, 2008 10:37 AM
>To: 'Carlos R. Mafra'
>Cc: Ray Lee; Rafael J. Wysocki; Linux Kernel Mailing List; 
>Soeren Sonnenburg
>Subject: RE: 2.6.25-current-git hangs on boot unless 
>CONFIG_CPU_IDLE=n-Apple
>
> 
>
>>-----Original Message-----
>>From: Carlos R. Mafra [mailto:crmafra2@gmail.com] 
>>Sent: Friday, April 04, 2008 8:52 AM
>>To: Pallipadi, Venkatesh
>>Cc: Ray Lee; Rafael J. Wysocki; Linux Kernel Mailing List; 
>>Pallipadi@ogre.sisk.pl; Soeren Sonnenburg
>>Subject: Re: 2.6.25-current-git hangs on boot unless 
>>CONFIG_CPU_IDLE=n-Apple
>>
>>On Fri  4.Apr'08 at  7:25:34 -0700, Pallipadi, Venkatesh wrote:
>>>  
>>> 
>>> >-----Original Message-----
>>> >From: linux-kernel-owner@vger.kernel.org 
>>> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>>> >Carlos R. Mafra
>>> >Sent: Friday, April 04, 2008 4:48 AM
>>> >To: Ray Lee
>>> >Cc: Pallipadi, Venkatesh; Rafael J. Wysocki; Linux Kernel 
>>> >Mailing List; Pallipadi@ogre.sisk.pl; Soeren Sonnenburg
>>> >Subject: Re: 2.6.25-current-git hangs on boot unless 
>>> >CONFIG_CPU_IDLE=n -Apple
>>> >
>>> >On Thu  3.Apr'08 at 20:15:02 -0700, Ray Lee wrote:
>>> >> On Thu, Apr 3, 2008 at 6:10 PM, Carlos R. Mafra 
>>> ><crmafra2@gmail.com> wrote:
>>> >> > On Thu  3.Apr'08 at 17:14:22 -0700, Pallipadi, Venkatesh wrote:
>>> >> >  > >The following report is on the current list of known 
>>> >regressions
>>> >> >  > >from 2.6.24.  Please verify if the issue is still 
>>> >present in the
>>> >> >  > >mainline.
>>> >> >  > >
>>> >> >  > >
>>> >> >  > >Bug-Entry    : 
>>http://bugzilla.kernel.org/show_bug.cgi?id=10093
>>> >> >  > >Subject              : 2.6.25-current-git hangs on boot
>>> >> >  > >unless CONFIG_CPU_IDLE=n - Apple
>>> >> >  > >Submitter    : Soeren Sonnenburg <kernel@nn7.de>
>>> >> >  > >Date         : 2008-02-23 18:55 (41 days old)
>>> >> >  > >References   : http://lkml.org/lkml/2008/2/23/263
>>> >> >  > >
>>> >> >  > 
>>http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
>>> >> >  > >Handled-By   : Pallipadi, Venkatesh 
>>> ><venkatesh.pallipadi@intel.com>
>>> >> >  > >
>>> >> >  >
>>> >> >  > Last comment I saw from Soeren says it does not really 
>>> >hang. It waits
>>> >> >  > for 5-10 seconds sometimes before continuing. We are 
>>> >still trying to
>>> >> >  > narrow this down with max_cstate etc..
>>> >> >
>>> >> >  I should say that my laptop (Vaio) _hangs_ at boot (less 
>>> >than 10% of boots)
>>> >> >  and this is the last message I see:
>>> >> >
>>> >> >  "ACPI: Processor [CPU1] (supports 8 throttling states)"
>>> >> >
>>> >> >  and it stays there "forever" (more than 1 or 2 minutes 
>>at least).
>>> >> >
>>> >> >  I am not using my laptop too much these days, and I 
>>thought this
>>> >> >  bug had been solved because it didn't hang for the 
>>last week (but
>>> >> >  I boot it once per day), however it hang last night 
>(using some
>>> >> >  post 2.6.25-rc7 kernel)
>>> >> >
>>> >> >  I have pictures of the screen while showing this last 
>>> >message at boot,
>>> >> >  should I post it somewhere or that is not necessary?.
>>> >> 
>>> >> If the sysrq key still works when that happens, try to do 
>>a sysrq-t,
>>> >> s, b to generate a trace, sync the filesystem, and reboot. 
>>> >If anything
>>> >> made it to the logs, please post it.
>>> >
>>> >Sysrq keys don't work when it hangs, I have to push the 
>>power button.
>>> >
>>> >Another thing to notice is that when it happens, it usually happens
>>> >more times in a row (like 3 times). And then it can take 
>>many boots to
>>> >happen again.
>>> >
>>> >I've uploaded the picture where it hangs, it is in the very 
>>beginning
>>> >of the boot process:
>>> >
>>> >http://www.ift.unesp.br/users/crmafra/dsc04673.jpg
>>> 
>>> 
>>> Can you try the latest git and see whether this still is a problem?
>>
>>I've just updated to latest git, but it may take some time for it 
>>to happen again (the first 3 boots were okay). Last time it happened
>>with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
>>
>>Do you have reasons to believe this issue was fixed since then?
>
>Yes. I think the patch here should have fixed the problem....
>Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4
>

Hmmmm.... Looking at latest git,
The above patch is not yet in git. Can you please apply the above patch
and see whether do you still see the problem.....

Thanks,
Venki
