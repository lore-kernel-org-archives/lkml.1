Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbYCCVOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbYCCVOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762642AbYCCVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:14:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:15491 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762681AbYCCVOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:14:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,440,1199692800"; 
   d="scan'208";a="528063484"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cpuidle: avoid singing capacitors
Date: Mon, 3 Mar 2008 13:14:28 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEA2E81B@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080303210839.GJ13869@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cpuidle: avoid singing capacitors
Thread-Index: Ach9crBsUixV09CiSc6K/wkV5e3y0wAAJ9fg
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx> <20080303211842.6f492782@mjolnir.drzeus.cx> <20080303204603.GA19775@elf.ucw.cz> <20080303220310.0cab7213@mjolnir.drzeus.cx> <20080303210839.GJ13869@elf.ucw.cz>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>, "Pierre Ossman" <drzeus-list@drzeus.cx>
Cc: "Adam Belay" <abelay@novell.com>, <linux-pm@lists.linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Lee Revell" <rlrevell@joe-job.com>
X-OriginalArrivalTime: 03 Mar 2008 21:12:50.0016 (UTC) FILETIME=[5626E600:01C87D73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Pavel Machek [mailto:pavel@ucw.cz] 
>Sent: Monday, March 03, 2008 1:09 PM
>To: Pierre Ossman
>Cc: Pallipadi, Venkatesh; Adam Belay; 
>linux-pm@lists.linux-foundation.org; LKML; Andi Kleen; Lee Revell
>Subject: Re: [PATCH] cpuidle: avoid singing capacitors
>
>On Mon 2008-03-03 22:03:10, Pierre Ossman wrote:
>> On Mon, 3 Mar 2008 21:46:03 +0100
>> Pavel Machek <pavel@ucw.cz> wrote:
>> 
>> > >  
>> > > +static unsigned int min_deep_sleep = 2000;
>> > > +
>> > 
>> > Well, why not, but I believe we should default to old 
>behaviour... not
>> > all machines are cheaply-build.
>> 
>> One would hope. ;)
>> 
>> But the problem is that most people will not be able to find this
>> option (or even know such an option exists). I'd guess the 
>distros will
>> just end up having this on by default anyway. And since I could not
>> measure any extra power drain, I believe it's hard to 
>justify having it
>> off by default (more than by pure principle).
>
>So just leave it off by default, and let distros break their own
>kernels ;-).
>								

I prefer leaving it off my default and enabling it on faulty hardware by
some blacklist.

Thanks,
Venki
