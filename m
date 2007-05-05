Return-Path: <linux-kernel-owner+w=401wt.eu-S934315AbXEES0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbXEES0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934305AbXEES0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:26:52 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37293 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934285AbXEES0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:26:52 -0400
Date: Sat, 5 May 2007 20:23:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: David Johnson <dj@david-web.co.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org,
       Wander Winkelhorst <w.winkelhorst@gmail.com>
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463CC735.9080709@interia.pl>
Message-ID: <Pine.LNX.4.61.0705052022460.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
 <200705042320.41278.dj@david-web.co.uk> <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
 <463C18C4.7030304@interia.pl> <Pine.LNX.4.61.0705051114130.18504@yvahk01.tjqt.qr>
 <463C9070.7020007@interia.pl> <Pine.LNX.4.61.0705051932210.18504@yvahk01.tjqt.qr>
 <463CC735.9080709@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 20:04, Rafał Bilski wrote:
>
>> I just wonder why x86info says I have a C5XL while `modprobe longhaul`
>> says it is a C5P.
>I have changed names to names which VIA is using. 
>> 
>> cn:/dev/shm # ./x86info -v -v
>You need to be root and use -a option. I'm interested in:

x86info v1.20.  Dave Jones 2001-2006
Feedback to <davej@redhat.com>.

Found 1 CPU
MP Table:
#	APIC ID	Version	State		Family	Model	Step	Flags

--------------------------------------------------------------------------
eax in: 0x00000000, eax = 00000001 ebx = 746e6543 ecx = 736c7561 edx = 48727561
eax in: 0x00000001, eax = 00000698 ebx = 00000000 ecx = 00000000 edx = 0381b13f

eax in: 0x80000000, eax = 80000006 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000001, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000002, eax = 20414956 ebx = 6568654e ecx = 6861696d edx = 00000000
eax in: 0x80000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = 00000000 ebx = 08800880 ecx = 40040120 edx = 40040120
eax in: 0x80000006, eax = 00000000 ebx = 00000000 ecx = 00408120 edx = 00000000

eax in: 0xc0000000, eax = c0000001 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0xc0000001, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000000dd

Family: 6 Model: 9 Stepping: 8
CPU Model : VIA C3 (Nehemiah) [C5XL]
Feature flags:
 fpu vme de pse tsc msr cx8 mtrr pge cmov pat mmx fxsr sse
Extended feature flags:
 [0] RNGp RNGe [4] ACEp ACEe
Cache info
 L1 Instruction cache: 64KB, 4-way associative, 1 lines per tag, line size=32 bytes.
 L1 Data cache: 64KB 4-way associative, 1 lines per tag, line size=32 bytes.
 L2 (on CPU) cache: 64KB 8-way associative, 1 lines per tag, line size=32 bytes.
TLB info
 Instruction TLB: 8-way associative. 128 entries.
 Data TLB: 8-way associative. 128 entries.
FCR: MSR: 0x00001107=0x9e3f1ad2 : 10011110 00111111 00011010 11010010
Power management: Powersaver
MSR: 0x0000110a=0x07ff0004000080f0 : 00000111 11111111 00000000 00000100
           00000000 00000000 10000000 11110000

 RevisionID: 0 : Initial revision (Software clock multiplier only, no SoftVID)
 Software clock multiplier is disabled

750MHz processor (estimate).



>> And the BIOS announces it as a "Via Eden ESP 6000" (as does the manufacturer).
>
>Great. I think that I saw datasheet somewhere.

Oops, that should read *ESP 7000*. And s/manufacturer/vendor/.
The box is an Atiosys BA-4000 (www.atiosys.com) pretty much your
standard x86-in-a-tiny-box.


Jan
-- 
