Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbZDXMpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbZDXMpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZDXMpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:45:24 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:23051 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753931AbZDXMpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:45:23 -0400
Message-ID: <409142.83316.qm@web32605.mail.mud.yahoo.com>
X-YMail-OSG: KzaHZwAVM1kv5.ex7ENosMbETW8Iz0mmVvClsYPsQ9cenaLG8qj6gpg_9XV_SR57KmzoaOz1vw_boVBkWPTuja.FCFOe8CRHt_C_k_1ypaCfWOA8L9uS20m6qlLoOqZ7ft_NE3pXey9vR7qohOiE22cRmOARP_5cQVNIR5S4blIf9RimHjqBDTtkLSIckV62FgmfaGm8XefZvUcpqyJaS16kNNRKq45Fnw1mwspb2wJYfZz2TP4vUJl2B58UvBxvSHYTGcgWzCiHWPcSsfl2rwsZ0HRJAVIfPkKi4G8_nRdXVg--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
Date: Fri, 24 Apr 2009 05:45:19 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, efault@gmx.de,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Martin Knoblauch <knobi@knobisoft.de>
> To: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-kernel@vger.kernel.org; efault@gmx.de
> Sent: Wednesday, April 22, 2009 6:55:27 PM
> Subject: Re: Booting 2.6.30-rc2-git7 very slow
> 
> ----- Original Message ----
> 
> > From: Martin Knoblauch 
> > To: Rafael J. Wysocki 
> > Cc: linux-kernel@vger.kernel.org; efault@gmx.de
> > Sent: Wednesday, April 22, 2009 1:32:25 PM
> > Subject: Re: Booting 2.6.30-rc2-git7 very slow
> > 
> > ----- Original Message ----
> > 
> > > From: Martin Knoblauch 
> > > To: Rafael J. Wysocki 
> > > Cc: linux-kernel@vger.kernel.org
> > > Sent: Wednesday, April 22, 2009 11:56:27 AM
> > > Subject: Re: Booting 2.6.30-rc2-git7 very slow
> > > 
> > > > From: Rafael J. Wysocki 
> > > 
> > > > To: Martin Knoblauch 
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Sent: Tuesday, April 21, 2009 9:12:20 PM
> > > > Subject: Re: Booting 2.6.30-rc2-git7 very slow
> > > > 
> > > > On Tuesday 21 April 2009, Martin Knoblauch wrote:
> > > > > 
> > > > > Hi, [please CC me on replies, as I am not subscribed]
> > > > > 
> > > > >  booting  2.6.30-rc2-git7 on a HP/DL380G3 (x86_64, RHEL4.3, 64 bit 
> > > userspace) 
> > > > is much slower that it used to be. It seems I run into timeouts when 
> [trying 
> > 
> > > to] 
> > > > load intel and tg3 microcodes:
> > > > > 
> > > > > [   14.478892] platform microcode: firmware: requesting 
> > intel-ucode/0f-04-0a
> > > > > [   74.476741] platform microcode: firmware: requesting 
> > intel-ucode/0f-04-0a
> > > > > [  134.476638] platform microcode: firmware: requesting 
> > intel-ucode/0f-04-0a
> > > > > [  194.476637] platform microcode: firmware: requesting 
> > intel-ucode/0f-04-0a
> > > > > [  254.476493] Microcode Update Driver: v2.00 , 
> > > > Peter Oruba
> > > > > [  254.718489] Microcode Update Driver: v2.00 removed.
> > > > > 
> > > > >  So, we see 60 seconds for eaoch of the CPUs
> > > > > 
> > > > > [  255.273426] tg3 0000:03:01.0: PME# disabled
> > > > > [  257.833769] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> > > > > [  257.833775] tg3: eth0: Flow control is off for TX and off for RX.
> > > > > [  269.643973] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> > > > > [  329.640456] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> > > > > [  329.640463] eth1: TSO capability disabled.
> > > > > [  329.640487] tg3 0000:03:01.1: PME# disabled
> > > > > [  333.081753] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> > > > > [  333.081759] tg3: eth1: Flow control is off for TX and off for RX.
> > > > > 
> > > > >  We see 60 seconds for eth1, complaining about a failed firmware load.
> > > > > /lib/firmware/tigon/tg3_tso.bin does exist and is from the current
> > > > > build.
> > > > 
> > > > Do I assume correctly that 2.6.29 did not have this problem?
> > > > 
> > > 
> > > Just checked. 2.6.29 has exactely the same problem. 2.6.28.2 was OK. This is 
> 
> > > from the 2.6.29 boot:
> > > 
> > > [   14.308340] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [   74.304612] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [  134.304651] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [  194.304638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [  254.304597] Microcode Update Driver: v2.00 ,  Peter Oruba
> > > [  254.546200] Microcode Update Driver: v2.00 removed.
> > 
> > In case of the platform microcode, the delays happen when doing:
> > 
> > /sbin/modprobe microcode
> > 
> > from the init script. I have a "microcode.dat" File in both /etc/ and 
> > /etc/firmware.
> > 
> > > [  255.088405] tg3 0000:03:01.0: PME# disabled
> > > [  257.669617] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> > > [  257.669622] tg3: eth0: Flow control is off for TX and off for RX.
> > > [  269.456132] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> > > [  329.456495] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> > > [  329.456500] eth1: TSO capability disabled.
> > > [  329.456524] tg3 0000:03:01.1: PME# disabled
> > > [  332.921832] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> > > [  332.921837] tg3: eth1: Flow control is off for TX and off for RX.
> > > 
> > > 
> > 
> 
> OK, I was able to solve the tg3 failure by adding "tigon/tg3_tso.bin" to 
> CONFIG_EXTRA_FIRMWARE. I tried the same with the CPU microcode (after copying 
> /etc/firmware/microcode.dat to $BUILDDIR/firmware/), but no success.
> 
> Searching the archives also found some mentioning that I might need special 
> udev-rules to make firmware loading work again transparently. But no explicit 
> solution.
> 
> I find this new (since 2.6.29) behaviour:
> 
> - very unexpected
> - not well documented
> - the EXTRA_FIRMWARE solution very unscalable
> 

 OK, I just found the reason for both intel-ucode and tg3 failures. Apparently between 2.6.28 and 2.6.29 the mount of sysfs has subtely changed from:

/sys /sys sysfs rw 0 0

to:

none /sys sysfs rw,relatime 0 0

 The "none" breaks the RHEL-4 provided hotplug script "firmware.agent" when it tries to parse the mount point for "/sys". As a result, the firmware loading is never properly finished and the driver(s) just timeout on the value  in /sys/class/firmware/timeout. Bingo. Simple fix in user-pace possible - cool down Martin :-)

Questions remains: was this intentional? It breaks existing userspace and should therefore be considered a regression - right? On the other hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets backported. Any ideas?

Cheers
Martin

