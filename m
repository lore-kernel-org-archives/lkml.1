Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYGHEkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYGHEkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 00:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYGHEkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 00:40:45 -0400
Received: from mail.lang.hm ([64.81.33.126]:52993 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYGHEko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 00:40:44 -0400
Date: Mon, 7 Jul 2008 21:41:41 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Altobelli, David" <david.altobelli@hp.com>
cc: Pavel Machek <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: RE: [PATCH][resubmit] HP iLO driver
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
Message-ID: <alpine.DEB.1.10.0807072127390.12950@asgard.lang.hm>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz>
 <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Altobelli, David wrote:

> Pavel Machek wrote:
>> Hi!
>>
>>>>> A driver for the HP iLO/iLO2 management processor, which allows
>>>>> userspace programs to query the management processor. Programs can
>>>>> open a channel to the device (/dev/hpilo/dXccbN), and use this to
>>>>> send/receive queries.
>>>>
>>>> What kind of queries? Is there documentation somewhere?
>>>
>>> Generally, it can get data out of the management processor - things
>>> like basic iLO configuration (users, nic, etc), handle SNMP traffic,
>>> flashing iLO, and some others.
>>>
>>> Unfortunately, there isn't yet any available documenation.
>>
>> Ok, I guess we should have documentation "what does it do" and "what
>> protocol does it speak" before we can think about merging.
>
> I really hope that isn't the case.
>
> The message packets and documention are owned by hardware teams,
> and they currently do not want to make that documentation public.

umm, by merging the code a you reveal a lot of what they are attempting to 
keep secret. what's to stop someone from reading the code and writing the 
documentation?

that really should be someone at HP if you don't want to publish the 
exising documentation (since you are submitting the code)

> However, I do think there is value in merging the driver without docs.
> Having drivers in tree is often stated as a goal, because of the obvious
> security and API/ABI disadvantages to out of tree drivers.
>
> If this can't be merged, then we continue to ship an out of tree driver,
> which no one (us, distros, customers) likes.  We pester our partners to
> support this driver, or include it, or what have you.  We get slowly
> out of date, and bugs creep in, or our package breaks on upstream kernels.
> To me, it seems like merging the driver is the better path.

correct, it's a far better path for you and your users, but it gets even 
better if there is some documentation to go with it.

David Lang
