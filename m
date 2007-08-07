Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbXHGIha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbXHGIha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbXHGIhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:37:20 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:15992 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756242AbXHGIhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:37:17 -0400
Message-ID: <46B82F2B.7010704@interia.pl>
Date: Tue, 07 Aug 2007 10:36:59 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Cc: Andreas Mohr <andi@lisas.de>, David Edwards <powertop@dpe.lusars.net>,
       power@bughost.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de>	<46B79512.6090704@interia.pl> <20070806235752.1e6c5653@laptop.hypervisor.org>
In-Reply-To: <20070806235752.1e6c5653@laptop.hypervisor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: dd00cacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> RB> VT8235 does *NOT* have a HPET(*). Only part which has HPET is VT8237. It
> RB> is device 00:17.0 too, but only 1106:3227 has HPET enable and memory
> RB> base registers. VT8235 one and only feature which doesn't have driver
> RB> yet seems to be hardware watchdog.
> RB> (*) Datasheet revision 2.03 March 16, 2005
> 
> We have an Asrock K7VT4A+ board with VT8235 southbridge in our lab and it
> does have an HPET. Just because the datasheet does not document HPET does
> not mean it is not implemented.
> 
> My guess is that newer revisions of VT8235 have HPET whereas older revisions
> do not. I'll get an lspci dump from our box tomorrow.
Indeed datasheet lies. I have VIA EPIA M10000 Rev. B motherboard.
% uname -r
2.6.23-rc1-hrt1

% dmesg | grep -i hpet
Force enabled HPET at base address 0xfed00000
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 32-bit timers, 14318180 Hz
Time: hpet clocksource has been installed.

% cat /proc/timer_list
[...]
Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     672664000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  hrtimer_interrupt

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
	Subsystem: VIA Technologies, Inc. Unknown device aa01
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2
00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 01 aa
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 45 00 f0 00 00 00 00 00 0c 20 00 00 44 00 0a 08
50: 81 1d 09 00 00 b0 a5 30 03 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 04 80 00 d0 fe 00 00 00 00
70: 06 11 01 aa 00 00 00 00 00 00 00 00 20 00 00 00
80: 20 84 59 00 b2 30 00 00 01 04 00 00 00 18 00 00
90: 00 1f 50 88 b0 c0 00 00 00 97 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 05 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 14 88 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 16 00 00 00 00 00 01 00 00 00

> Cheers,
> 
> 	- Udo
Regards
Rafał


----------------------------------------------------------------------
Plaza plazy nierowna
Kliknij
>>>http://link.interia.pl/f1af7

