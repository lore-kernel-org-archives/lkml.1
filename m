Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYFKOQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYFKOQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYFKOQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:16:27 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4190 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYFKOQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:16:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 11 Jun 2008 14:14:56.0406 (UTC) FILETIME=[866CA360:01C8CBCD]
Content-class: urn:content-classes:message
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Date: Wed, 11 Jun 2008 10:14:50 -0400
Message-ID: <Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>
In-Reply-To: <20080611065816.6cff290d@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
thread-index: AcjLzYZ2A1rEJsrvSmOxsC7M0nQVDA==
References: <200806102152.23286.solstice.dhiver@gmail.com><20080610131314.5f7069e6@infradead.org><484EE71A.40002@intel.com><alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr><20080611063639.5e1eea5b@infradead.org><alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr> <20080611065816.6cff290d@infradead.org>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1027-15964.007
X-TM-AS-Result: No--15.866000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Jun 2008, Arjan van de Ven wrote:

> On Wed, 11 Jun 2008 15:52:57 +0200 (CEST)
> Jan Engelhardt <jengelh@medozas.de> wrote:
>
>>
>> On Wednesday 2008-06-11 15:36, Arjan van de Ven wrote:
>>>>>> btw this is scary; the Mhz line in /proc/cpuinfo doesn't have
>>>>>> much meaning really, so applications using it and depending on
>>>>>> it is a rather big disaster ;-(
>>>>>>
>>>>>> Does anyone know why jackd wants to use this?
>>>>
>>>> It would be nice to have a /sys file where the CPU frequency is in,
>>>
>>> may I ask why? What would you do with it?
>>
>> Off the top off the head, just for reporting to the user. Desklets
>> and stuff.
>
> even then it doesn't mean much ;-(
>
>>> CPU frequency is...
>>> 1) not something that is fixed; it changes all the time
>>> 2) not a good indication for performance; remember the 3.4Ghz
>>> pentium4, a 2Ghz Core2Duo outperforms it
>>> 3) something which the cpu itself barely honors (the clock stops
>>> during idle etc etc)
>
>

I use CPU frequency to scale the output of rdtsc when timing
routines being optimized. If CPU frequency goes away, I'll
have to add calibration routines to a lot of code. I don't
think one should just dispose of something that has been
useful for many years because they don't understand its
utility. The fact that __some__ machines dynamically adjust
clock-speeds is not a valid reason to remove something useful
that impacts only boot time. Following this trend, soon there
won't be any floppy-drive code because "nobody" uses them
anymore. Please don't keep throwing good stuff away.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
