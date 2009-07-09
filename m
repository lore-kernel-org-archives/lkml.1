Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZGIVUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZGIVUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZGIVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:19:58 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:61585 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbZGIVT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uFr2v4a+FY2qBmlshc1MFOwpiDwvmNKMHVdjSotHdOGRBy0CHFM6mtpW/p9NaUoG5T
         HdQql9vM9OKJ4qQ4jRpRHNSYtHZJyk8O2/0wbRyeuj8fs9EzaBlMLSUwGqNhUhHWjUbh
         PBlsc4vt190NmbsyaRa64CViuIkeYDVv7xbWo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907091943290.2768@localhost.localdomain>
References: <200907031326.21822.andres@anarazel.de> <200907091728.23367.andres@anarazel.de> 
	<alpine.LFD.2.00.0907091801130.24704@localhost.localdomain> 
	<200907091846.37926.andres@anarazel.de> <alpine.LFD.2.00.0907091943290.2768@localhost.localdomain>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Thu, 9 Jul 2009 22:19:34 +0100
Message-ID: <a5d9929e0907091419j2e4aefbdrc845b3e158982539@mail.gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( 
	possibly?caused by netem)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andres Freund <andres@anarazel.de>, Jarek Poplawski <jarkao2@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 6:44 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
> Andres,
>
> On Thu, 9 Jul 2009, Andres Freund wrote:
>
>> On Thursday 09 July 2009 18:01:56 Thomas Gleixner wrote:
>> > Andres,
>> >
>> > On Thu, 9 Jul 2009, Andres Freund wrote:
>> > > On Thursday 09 July 2009 16:28:05 Thomas Gleixner wrote:
>> > > > Please test them separate from each other. The one I sent in this
>> > > > thread was just for narrowing down the issue, but I'm now quite sure
>> > > > that they really hit the issue which is addressed by the hrtimer
>> > > > patch.
>> > >
>> > > No crash yet. 15min running (seconds to a minute before).
>> > >
>> > > Will let it run for some hours to be sure.
>> >
>> > Which one of the patches are you testing ?
>> Your "real" one, i.e. de907e8432b08f2d5966c36e0747e97c0e596810
>>
>> 1h30m now...
>
> Looks like I hit the nail on the head. Queueing it up for Linus.
>
> Thanks,
>
>        tglx
>

Confirmed working from me as well.

Thank you for your time,
Joao Correia
