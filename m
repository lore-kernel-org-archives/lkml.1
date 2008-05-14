Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbYENNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbYENNVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbYENNVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:21:08 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2143 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620AbYENNVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:21:07 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 14 May 2008 13:20:58.0039 (UTC) FILETIME=[58A40C70:01C8B5C5]
Content-class: urn:content-classes:message
Subject: Re: WD doesn`t use disks with Linux - was Re: Re:Western Digital GreenPower drives and Linux
Date: Wed, 14 May 2008 09:20:46 -0400
Message-ID: <Pine.LNX.4.61.0805140912170.9528@chaos.analogic.com>
In-Reply-To: <482A062B.3010308@arndnet.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: WD doesn`t use disks with Linux - was Re: Re:Western Digital GreenPower drives and Linux
thread-index: Aci1xViwKLZuktijRNOvHHUWbuTuIg==
References: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com> <482A062B.3010308@arndnet.de>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Arnd Hannemann" <arnd@arndnet.de>
Cc: "Roland" <devzero@web.de>, <tvrtko@ursulin.net>, <pernegger@gmail.com>,
       <snitzer@gmail.com>, <jengelh@computergmbh.de>,
       <zorglub_olsen@hotmail.com>, <renatoyamane@mandic.com.br>,
       <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15908.007
X-TM-AS-Result: No--21.809000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 13 May 2008, Arnd Hannemann wrote:

> Roland wrote:
>>> BTW, WD's tech support has gone silent so chances for an easier
>>> solution are not so great.
>>>
>>> Tvrtko
>>
>> I`ve got a real funky response from WD support  today, i`d like to
>> share here.
>> This is just too weird....
>>
>> After asking if they could give a comment if the problem with the high
>> Load_Cycle_Count may be an issue of their drives or an issue of Linux
>> i got:
>>
>> ------
>> Dear......
>> The problem is, that we actually don`t use the disks with Linux. I´m
>> sorry that i cannot send further information to you.
>>
>> Sincery yours
>> <insert support employee name here>
>> Western Digital Service and Support
>> ------
>> (translated from german)
>
> Well the answer was probably just from a first level support person so
> nothing one should get excited about.
> Anyway to the high Load_Cycle_Count; if I understood the technology
> correctly the WD GreenPower drives are exactly "Green" because they
> unload the heads on a plastic ramp (no landing zone!) quite often during
> longer idle periods. Thus they can power off the positioning logic and
> actuator of the heads. -> safe Power
> This also explains why the power usage under seek is comparable with
> other "non-green" drives...
>
> <snipped a lot of stuff>
>> 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
> my 1 TB drive has also a relative high value:
>
> 193 Load_Cycle_Count        0x0032   200   200   000    Old_age
> Always       -       2786
>
>
> Just my 2 cents,
> Arnd
> ||

Practically nobody has any on-line support that means anything
anymore. The person who wrote the response is probably in the
Philippines, makes about $US 3.00 per hour, and is allowed to
pee twice a day. Don't worry. The tiny "bump-proof" drives
cycle on an off many times to conserve power. They also
keep the heads from landing "crashing" by inserting a plastic
wedge between the swing-arms during power down. It's probably
a lot less harmful than letting the heads touch down somewhere.

It's not just the positioning logic that gets powered off. The
discs are spun down, which saves a lot of power.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
