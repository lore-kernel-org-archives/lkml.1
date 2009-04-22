Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZDVQzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZDVQzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZDVQz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:55:29 -0400
Received: from web32601.mail.mud.yahoo.com ([68.142.207.228]:36939 "HELO
	web32601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751450AbZDVQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:55:29 -0400
Message-ID: <556070.57412.qm@web32601.mail.mud.yahoo.com>
X-YMail-OSG: yBCBgj0VM1mFKQk3dG1.yDo.4YhlzaJk2dLjeCKIV10Vc890PtqMNt1xn_SqqIkNX8lB041DMta7yF0mO6erKddNHK30O1cX.RVHHYLJztiQ_3PSQ60igULo7gSMxzIVd4TibnqMEP6XnjPS85TdLtXKjguzVI5LtVWHjGeUpihPtYw.LLoRgkRjmdxJPKdghV830Mayd1kZTfI6CZwJq97JN3Gep_bBRBMrRXKSK__oqyaDztyNC.yAWVvKe4P9UBe83o1eoS.Y2RN5D7lWuqGu_H8z3jRVmGSeHy5j_pBdag--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
Date: Wed, 22 Apr 2009 09:55:27 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Booting 2.6.30-rc2-git7 very slow
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, efault@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-kernel@vger.kernel.org; efault@gmx.de
> Sent: Wednesday, April 22, 2009 1:32:25 PM
> Subject: Re: Booting 2.6.30-rc2-git7 very slow
> 
> ----- Original Message ----
> 
> > From: Martin Knoblauch 
> > To: Rafael J. Wysocki 
> > Cc: linux-kernel@vger.kernel.org
> > Sent: Wednesday, April 22, 2009 11:56:27 AM
> > Subject: Re: Booting 2.6.30-rc2-git7 very slow
> > 
> > > From: Rafael J. Wysocki 
> > 
> > > To: Martin Knoblauch 
> > > Cc: linux-kernel@vger.kernel.org
> > > Sent: Tuesday, April 21, 2009 9:12:20 PM
> > > Subject: Re: Booting 2.6.30-rc2-git7 very slow
> > > 
> > > On Tuesday 21 April 2009, Martin Knoblauch wrote:
> > > > 
> > > > Hi, [please CC me on replies, as I am not subscribed]
> > > > 
> > > >  booting  2.6.30-rc2-git7 on a HP/DL380G3 (x86_64, RHEL4.3, 64 bit 
> > userspace) 
> > > is much slower that it used to be. It seems I run into timeouts when [trying 
> 
> > to] 
> > > load intel and tg3 microcodes:
> > > > 
> > > > [   14.478892] platform microcode: firmware: requesting 
> intel-ucode/0f-04-0a
> > > > [   74.476741] platform microcode: firmware: requesting 
> intel-ucode/0f-04-0a
> > > > [  134.476638] platform microcode: firmware: requesting 
> intel-ucode/0f-04-0a
> > > > [  194.476637] platform microcode: firmware: requesting 
> intel-ucode/0f-04-0a
> > > > [  254.476493] Microcode Update Driver: v2.00 , 
> > > Peter Oruba
> > > > [  254.718489] Microcode Update Driver: v2.00 removed.
> > > > 
> > > >  So, we see 60 seconds for eaoch of the CPUs
> > > > 
> > > > [  255.273426] tg3 0000:03:01.0: PME# disabled
> > > > [  257.833769] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> > > > [  257.833775] tg3: eth0: Flow control is off for TX and off for RX.
> > > > [  269.643973] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> > > > [  329.640456] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> > > > [  329.640463] eth1: TSO capability disabled.
> > > > [  329.640487] tg3 0000:03:01.1: PME# disabled
> > > > [  333.081753] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> > > > [  333.081759] tg3: eth1: Flow control is off for TX and off for RX.
> > > > 
> > > >  We see 60 seconds for eth1, complaining about a failed firmware load.
> > > > /lib/firmware/tigon/tg3_tso.bin does exist and is from the current
> > > > build.
> > > 
> > > Do I assume correctly that 2.6.29 did not have this problem?
> > > 
> > 
> > Just checked. 2.6.29 has exactely the same problem. 2.6.28.2 was OK. This is 
> > from the 2.6.29 boot:
> > 
> > [   14.308340] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [   74.304612] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [  134.304651] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [  194.304638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [  254.304597] Microcode Update Driver: v2.00 ,  Peter Oruba
> > [  254.546200] Microcode Update Driver: v2.00 removed.
> 
> In case of the platform microcode, the delays happen when doing:
> 
> /sbin/modprobe microcode
> 
> from the init script. I have a "microcode.dat" File in both /etc/ and 
> /etc/firmware.
> 
> > [  255.088405] tg3 0000:03:01.0: PME# disabled
> > [  257.669617] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> > [  257.669622] tg3: eth0: Flow control is off for TX and off for RX.
> > [  269.456132] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> > [  329.456495] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> > [  329.456500] eth1: TSO capability disabled.
> > [  329.456524] tg3 0000:03:01.1: PME# disabled
> > [  332.921832] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> > [  332.921837] tg3: eth1: Flow control is off for TX and off for RX.
> > 
> > 
> 

 OK, I was able to solve the tg3 failure by adding "tigon/tg3_tso.bin" to CONFIG_EXTRA_FIRMWARE. I tried the same with the CPU microcode (after copying /etc/firmware/microcode.dat to $BUILDDIR/firmware/), but no success.

 Searching the archives also found some mentioning that I might need special udev-rules to make firmware loading work again transparently. But no explicit solution.

 I find this new (since 2.6.29) behaviour:

- very unexpected
- not well documented
- the EXTRA_FIRMWARE solution very unscalable

Cheers
Martin

