Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbXIEM4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbXIEM4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXIEM4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:56:24 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2413 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXIEM4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:56:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 05 Sep 2007 12:55:56.0113 (UTC) FILETIME=[19535410:01C7EFBC]
Content-class: urn:content-classes:message
Subject: Re: file system for solid state disks
Date: Wed, 5 Sep 2007 08:56:20 -0400
Message-ID: <Pine.LNX.4.61.0709050847020.11599@chaos.analogic.com>
In-Reply-To: <200709051334.14599.vda.linux@googlemail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: file system for solid state disks
Thread-Index: AcfvvBlmtJuIMIfqSM+sidkVjgHQPA==
References: <6278d2220708230155j18248f2cr3cc697a7acbaa930@mail.gmail.com> <200709051334.14599.vda.linux@googlemail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Richard Ballantyne" <richardballantyne@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 5 Sep 2007, Denys Vlasenko wrote:

> On Thursday 23 August 2007 09:55, Daniel J Blueman wrote:
>> On 23 Aug, 07:00, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>>> On Aug 23 2007 01:01, Richard Ballantyne wrote:
>>>> What file system that is already in the linux kernel do people recommend
>>>> I use for my laptop that now contains a solid state disk?
>>>
>>> If I had to choose, the list of options seems to be:
>>>
>>> - logfs
>>>   [unmerged]
>>>
>>> - UBI layer with any fs you like
>>>   [just a guess]
>>>
>>> - UDF in Spared Flavor (mkudffs --media-type=cdrw --utf8)
>>>   [does not support ACLs/quotas]
>>
>> Isn't it that with modern rotational wear-levelling, re-writing hot
>> blocks many times is not an issue, as they are internally moved around
>> anyway? So, using a journalled filesystem such as ext3 is still good
>> (robustness and maturity in mind).
>
> Crap hardware (one which only _claim_ to do it) is out there,
> and is typically cheaper, so users preferentially buy that ;)
> --
> vda

You might want to check and see what is actually being
used for the solid-state disk. Some solid state disks
are SRAM and DRAM. SRAM is fast, it doesn't require refresh,
is now as cheap as flash, and does R/W forever. It retains
its data for 10 years of power being removed by using an
embedded battery.

http://en.wikipedia.org/wiki/Solid_state_drive

This is exactly what I proposed on this list a long
time ago. It is now a reality.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
