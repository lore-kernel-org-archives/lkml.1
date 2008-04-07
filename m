Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYDGOIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYDGOIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 10:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbYDGOIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 10:08:25 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:17376 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbYDGOIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 10:08:24 -0400
From: nikosapi <me@nikosapi.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend on Lenovo 3000 V200 - Linux 2.6.25rc8
Date: Mon, 7 Apr 2008 10:08:33 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <3e8fd0440804052010xbe8f59bw3268d8206b97ac3e@mail.gmail.com> <200804061930.49659.me@nikosapi.org> <200804071058.38141.rjw@sisk.pl>
In-Reply-To: <200804071058.38141.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071008.33879.me@nikosapi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On April 7, 2008 04:58:37 Rafael J. Wysocki wrote:
> On Monday, 7 of April 2008, nikosapi wrote:
> > On April 6, 2008 19:23:36 Rafael J. Wysocki wrote:
> > > On Monday, 7 of April 2008, nikosapi wrote:
> > > > On April 6, 2008 16:21:57 Rafael J. Wysocki wrote:
> > > > > On Sunday, 6 of April 2008, Nick Nobody wrote:
>
> [--snip--]
>
> > > > Hello Rafael,
> > > >
> > > > I tested with that patch and the problem persists, when the laptop
> > > > resumes it locks up (with a black screen). If I add
> > > > acpi_apic_instance=2 acpi_osi=Linux as kernel boot options (as
> > > > suggested by my dmesg) when it resumes I get back to a virtual term
> > > > but I'm not able to log in. After entering my username it just hangs
> > > > there.
>
> Have you tried if doing "echo mem > /sys/power/state" instead of s2ram
> works?
>
> If you have, what graphics adapter is there in your machine?
>
> Rafael
> --

Yes, I've been using /sys/power/state to put the machine to sleep ever since 
you told me. 

Here's the output of lspci -d 8086:2a02 -vvvxxx 

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
        Subsystem: Lenovo Unknown device 3c18
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=1M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 1800 [size=8]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
00: 86 80 02 2a 07 00 90 00 03 00 00 03 00 00 80 00
10: 04 00 00 f4 00 00 00 00 0c 00 00 d0 00 00 00 00
20: 01 18 00 00 00 00 00 00 00 00 00 00 aa 17 18 3c
30: 00 00 00 00 90 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 00 00 48 00 00 00 09 00 0a 91 28 64 00 30
50: 04 00 30 00 19 00 00 00 00 00 00 00 00 00 80 3f
60: 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 01 01 01 01 00 00 00 00 4d 01 00 00
d0: 01 00 23 00 00 00 01 01 01 01 00 94 34 00 00 00
e0: 00 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00
f0: 05 02 34 07 00 00 00 00 90 0f 03 00 bc 0c 6e 3f

nick
