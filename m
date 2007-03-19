Return-Path: <linux-kernel-owner+w=401wt.eu-S1030649AbXCSVvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649AbXCSVvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030720AbXCSVva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:51:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:39781 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030649AbXCSVvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hkw9O1MFjbmpbQjmqs2s7tiibVyXfKYV0M9Hp9mYoKEYOV1bjURbNUjAOHRWQEa1kDR1s4J6oCoI6OjyIjn2Xa7CZQegHOAlOGBe9q42nZu95+0Vc2E9YjgKlL939oMg3xZuhDZeOd2SPpZeP4GW5dGVMBbfR0iYERtk/UIQetM=
Message-ID: <b93822910703191451o216a8931v9023b174fdef750@mail.gmail.com>
Date: Mon, 19 Mar 2007 22:51:19 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, "Len Brown" <lenb@kernel.org>,
       "Andi Kleen" <ak@suse.de>, "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <1174337777.13341.621.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
	 <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
	 <1174334646.13341.577.camel@localhost.localdomain>
	 <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com>
	 <1174337777.13341.621.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/19, Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 2007-03-19 at 21:35 +0100, Stefan Prechtel wrote:
> >            CPU0       CPU1
> >  0:      28289          0  local-APIC-edge-fasteio   timer
> > ...
> > LOC:      28237      28236
> >
> > after a read: (I hope that is this what you want :-)
> >            CPU0       CPU1
> >   0:      30344          0  local-APIC-edge-fasteio   timer
> > ...
> > LOC:      30292      30291
>
> Is this with AC plugged in ? If yes, please provide the same numbers for
> battery mode.

Yes. And here is the output for battery mode (2.6.20):
           CPU0       CPU1
  0:     292153          0  local-APIC-edge-fasteio   timer
LOC:     292114     292113

           CPU0       CPU1
  0:     293263          0  local-APIC-edge-fasteio   timer
LOC:     293224     293223



> What's the output of
> cat /proc/acpi/processor/C000/power
>
> for 2.6.20 and 2.6.21-rc4-latest-git with and w/o AC ?

2.6.20 / 2.6.21: (both the same)
battery / ac (both the same)
# cat /proc/acpi/processor/C000/power
active state:            C1
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 2000 usec
states:
   *C1:                  type[C1] promotion[--] demotion[--] latency[000] usage[
00000000] duration[00000000000000000000]
# cat /proc/acpi/processor/C001/power
active state:            C1
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 2000 usec
states:
   *C1:                  type[C1] promotion[--] demotion[--] latency[000] usage[
00000000] duration[00000000000000000000]



> Can you also please upload a bootlog with and without AC of 2.6.20 to
> bugzilla ?
Yes, one moment please. I will upload files..

> Thanks,
>
>         tglx

Thanks too ;)
- Stefan Prechtel
