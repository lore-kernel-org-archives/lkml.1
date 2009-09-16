Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbZIPPP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbZIPPP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZIPPP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:15:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZIPPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=hyFqLwDZE5HRhvTRKr+ziQ4QyYkJpnzncCD5k6QKsMBxnLXtOgp3JMAzzzNp0w21/O
         M13Gi1iW47KXOYM7Kc9BrKScJdJvx/sngNkUGlERcgiLX6WF2E2Tkzhx2LTaWalSzflS
         kTM2Pm4eZI3XrpAo3X2G5iPYBd8zcMTkJ//5A=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Wed, 16 Sep 2009 17:15:51 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0909160939230.8236-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909160939230.8236-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nEQsKwbmmXrOX8a"
Message-Id: <200909161715.51449.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_nEQsKwbmmXrOX8a
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch 16 September 2009, Alan Stern wrote:
> On Wed, 16 Sep 2009, Volker Armin Hemmann wrote:
> > emm, the mouse is attached through a powered 4port usb 2.0 hub. That is
> > the only way to get it working. If I attach it directly (without loading
> > ohci) it does not work (well, only tried with both Transaction Translat=
or
> > options off), and if I load ohci before I connect it, it is very very
> > jerky. So jerky in fact, that I considered douzends of lockups a day a
> > better alternative.
>=20
> That is a separate issue and it is a serious bug.  If anything, the
> behavior with OHCI should be better than with EHCI.  This is worth
> pursuing farther.  A usbmon log combined with the dmesg log would help.
> There's no need to include all the boot-up messages in the dmesg log;
> you can clear the log buffer before plugging in the mouse.
>=20
> In fact, we can probably forget about the EHCI issue.  If it works okay
> with the newer TT scheduler, that should be good enough.
>=20
> Alan Stern
>=20

ok, I was in the kitchen, I am back and the mouse is extremely jerky.

I cat usbmon/5u into a file for a short while, I hope it is the right file?

Gl=FCck Auf
Volker

--Boundary-00=_nEQsKwbmmXrOX8a
Content-Type: text/plain;
  charset="ISO-8859-15";
  name="dmesg_ohci_jerk_attack"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_ohci_jerk_attack"

[ 4641.872236] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[ 4641.872244] ohci_hcd: block sizes: ed 80 td 96
[ 4641.872295]   alloc irq_desc for 16 on node -1
[ 4641.872300]   alloc kstat_irqs on node -1
[ 4641.872313] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 4641.873309] ohci_hcd 0000:00:12.0: OHCI Host Controller
[ 4641.873523] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[ 4641.873550] ohci_hcd 0000:00:12.0: enabled AMD ISO transfers quirk
[ 4641.873576] ohci_hcd 0000:00:12.0: created debug files
[ 4641.873581] ohci_hcd 0000:00:12.0: supports USB remote wakeup
[ 4641.873612] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfddfe000
[ 4641.931511] ohci_hcd 0000:00:12.0: OHCI controller state
[ 4641.931523] ohci_hcd 0000:00:12.0: OHCI 1.0, NO legacy support registers
[ 4641.931533] ohci_hcd 0000:00:12.0: control 0x283 RWC HCFS=operational CBSR=3
[ 4641.931540] ohci_hcd 0000:00:12.0: cmdstatus 0x00000 SOC=0
[ 4641.931548] ohci_hcd 0000:00:12.0: intrstatus 0x00000004 SF
[ 4641.931555] ohci_hcd 0000:00:12.0: intrenable 0x8000001a MIE UE RD WDH
[ 4641.931567] ohci_hcd 0000:00:12.0: hcca frame #0005
[ 4641.931575] ohci_hcd 0000:00:12.0: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 4641.931582] ohci_hcd 0000:00:12.0: roothub.b 00000000 PPCM=0000 DR=0000
[ 4641.931589] ohci_hcd 0000:00:12.0: roothub.status 00008000 DRWE
[ 4641.931597] ohci_hcd 0000:00:12.0: roothub.portstatus [0] 0x00000100 PPS
[ 4641.931604] ohci_hcd 0000:00:12.0: roothub.portstatus [1] 0x00000100 PPS
[ 4641.931611] ohci_hcd 0000:00:12.0: roothub.portstatus [2] 0x00000100 PPS
[ 4641.931639] usb usb3: default language 0x0409
[ 4641.931653] usb usb3: udev 1, busnum 3, minor = 256
[ 4641.931658] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[ 4641.931663] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 4641.931668] usb usb3: Product: OHCI Host Controller
[ 4641.931672] usb usb3: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 4641.931676] usb usb3: SerialNumber: 0000:00:12.0
[ 4641.931795] usb usb3: uevent
[ 4641.931944] usb usb3: usb_probe_device
[ 4641.931950] usb usb3: configuration #1 chosen from 1 choice
[ 4641.931967] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[ 4641.932002] usb 3-0:1.0: uevent
[ 4641.932076] hub 3-0:1.0: usb_probe_interface
[ 4641.932081] hub 3-0:1.0: usb_probe_interface - got id
[ 4641.932087] hub 3-0:1.0: USB hub found
[ 4641.932105] hub 3-0:1.0: 3 ports detected
[ 4641.932109] hub 3-0:1.0: standalone hub
[ 4641.932113] hub 3-0:1.0: no power switching (usb 1.0)
[ 4641.932118] hub 3-0:1.0: no over-current protection
[ 4641.932122] hub 3-0:1.0: power on to power good time: 4ms
[ 4641.932133] hub 3-0:1.0: local power source is good
[ 4641.932138] hub 3-0:1.0: trying to enable port power on non-switchable hub
[ 4641.932239] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 4641.932290] ohci_hcd 0000:00:12.1: OHCI Host Controller
[ 4641.932428] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[ 4641.932451] ohci_hcd 0000:00:12.1: enabled AMD ISO transfers quirk
[ 4641.932476] ohci_hcd 0000:00:12.1: created debug files
[ 4641.932482] ohci_hcd 0000:00:12.1: supports USB remote wakeup
[ 4641.932497] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfddfd000
[ 4641.988180] ohci_hcd 0000:00:12.1: OHCI controller state
[ 4641.988190] ohci_hcd 0000:00:12.1: OHCI 1.0, NO legacy support registers
[ 4641.988200] ohci_hcd 0000:00:12.1: control 0x283 RWC HCFS=operational CBSR=3
[ 4641.988208] ohci_hcd 0000:00:12.1: cmdstatus 0x00000 SOC=0
[ 4641.988215] ohci_hcd 0000:00:12.1: intrstatus 0x00000004 SF
[ 4641.988223] ohci_hcd 0000:00:12.1: intrenable 0x8000001a MIE UE RD WDH
[ 4641.988235] ohci_hcd 0000:00:12.1: hcca frame #0005
[ 4641.988243] ohci_hcd 0000:00:12.1: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 4641.988250] ohci_hcd 0000:00:12.1: roothub.b 00000000 PPCM=0000 DR=0000
[ 4641.988256] ohci_hcd 0000:00:12.1: roothub.status 00008000 DRWE
[ 4641.988264] ohci_hcd 0000:00:12.1: roothub.portstatus [0] 0x00000100 PPS
[ 4641.988271] ohci_hcd 0000:00:12.1: roothub.portstatus [1] 0x00000100 PPS
[ 4641.988278] ohci_hcd 0000:00:12.1: roothub.portstatus [2] 0x00000100 PPS
[ 4641.988304] usb usb4: default language 0x0409
[ 4641.988317] usb usb4: udev 1, busnum 4, minor = 384
[ 4641.988322] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[ 4641.988327] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 4641.988332] usb usb4: Product: OHCI Host Controller
[ 4641.988336] usb usb4: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 4641.988340] usb usb4: SerialNumber: 0000:00:12.1
[ 4641.988445] usb usb4: uevent
[ 4641.989624] usb usb4: usb_probe_device
[ 4641.989631] usb usb4: configuration #1 chosen from 1 choice
[ 4641.989648] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[ 4641.989685] usb 4-0:1.0: uevent
[ 4641.989770] hub 4-0:1.0: usb_probe_interface
[ 4641.989775] hub 4-0:1.0: usb_probe_interface - got id
[ 4641.989780] hub 4-0:1.0: USB hub found
[ 4641.989797] hub 4-0:1.0: 3 ports detected
[ 4641.989801] hub 4-0:1.0: standalone hub
[ 4641.989805] hub 4-0:1.0: no power switching (usb 1.0)
[ 4641.989809] hub 4-0:1.0: no over-current protection
[ 4641.989814] hub 4-0:1.0: power on to power good time: 4ms
[ 4641.989824] hub 4-0:1.0: local power source is good
[ 4641.989830] hub 4-0:1.0: trying to enable port power on non-switchable hub
[ 4641.989929] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 4641.989975] ohci_hcd 0000:00:13.0: OHCI Host Controller
[ 4641.990115] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[ 4641.990137] ohci_hcd 0000:00:13.0: enabled AMD ISO transfers quirk
[ 4641.990165] ohci_hcd 0000:00:13.0: created debug files
[ 4641.990170] ohci_hcd 0000:00:13.0: supports USB remote wakeup
[ 4641.990202] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfddfc000
[ 4642.030839] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4642.048175] ohci_hcd 0000:00:13.0: OHCI controller state
[ 4642.048184] ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
[ 4642.048193] ohci_hcd 0000:00:13.0: control 0x283 RWC HCFS=operational CBSR=3
[ 4642.048200] ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
[ 4642.048207] ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
[ 4642.048214] ohci_hcd 0000:00:13.0: intrenable 0x8000001a MIE UE RD WDH
[ 4642.048227] ohci_hcd 0000:00:13.0: hcca frame #0005
[ 4642.048234] ohci_hcd 0000:00:13.0: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 4642.048241] ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
[ 4642.048247] ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
[ 4642.048255] ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
[ 4642.048262] ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00000100 PPS
[ 4642.048269] ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
[ 4642.048293] usb usb5: default language 0x0409
[ 4642.048306] usb usb5: udev 1, busnum 5, minor = 512
[ 4642.048310] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[ 4642.048315] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 4642.048320] usb usb5: Product: OHCI Host Controller
[ 4642.048324] usb usb5: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 4642.048328] usb usb5: SerialNumber: 0000:00:13.0
[ 4642.048428] usb usb5: uevent
[ 4642.048551] usb usb5: usb_probe_device
[ 4642.048556] usb usb5: configuration #1 chosen from 1 choice
[ 4642.048571] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[ 4642.048605] usb 5-0:1.0: uevent
[ 4642.048674] hub 5-0:1.0: usb_probe_interface
[ 4642.048679] hub 5-0:1.0: usb_probe_interface - got id
[ 4642.048684] hub 5-0:1.0: USB hub found
[ 4642.048701] hub 5-0:1.0: 3 ports detected
[ 4642.048704] hub 5-0:1.0: standalone hub
[ 4642.048708] hub 5-0:1.0: no power switching (usb 1.0)
[ 4642.048712] hub 5-0:1.0: no over-current protection
[ 4642.048717] hub 5-0:1.0: power on to power good time: 4ms
[ 4642.048727] hub 5-0:1.0: local power source is good
[ 4642.048731] hub 5-0:1.0: trying to enable port power on non-switchable hub
[ 4642.048827] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 4642.048864] ohci_hcd 0000:00:13.1: OHCI Host Controller
[ 4642.048997] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[ 4642.049016] ohci_hcd 0000:00:13.1: enabled AMD ISO transfers quirk
[ 4642.049041] ohci_hcd 0000:00:13.1: created debug files
[ 4642.049046] ohci_hcd 0000:00:13.1: supports USB remote wakeup
[ 4642.049060] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfddf7000
[ 4642.090842] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4642.104844] ohci_hcd 0000:00:13.1: OHCI controller state
[ 4642.104853] ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
[ 4642.104862] ohci_hcd 0000:00:13.1: control 0x283 RWC HCFS=operational CBSR=3
[ 4642.104869] ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
[ 4642.104876] ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
[ 4642.104883] ohci_hcd 0000:00:13.1: intrenable 0x8000001a MIE UE RD WDH
[ 4642.104895] ohci_hcd 0000:00:13.1: hcca frame #0005
[ 4642.104902] ohci_hcd 0000:00:13.1: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 4642.104909] ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
[ 4642.104915] ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
[ 4642.104923] ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00000100 PPS
[ 4642.104930] ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
[ 4642.104937] ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00000100 PPS
[ 4642.104960] usb usb6: default language 0x0409
[ 4642.104973] usb usb6: udev 1, busnum 6, minor = 640
[ 4642.104977] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[ 4642.104982] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 4642.104987] usb usb6: Product: OHCI Host Controller
[ 4642.104991] usb usb6: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 4642.104995] usb usb6: SerialNumber: 0000:00:13.1
[ 4642.105095] usb usb6: uevent
[ 4642.106222] usb usb6: usb_probe_device
[ 4642.106229] usb usb6: configuration #1 chosen from 1 choice
[ 4642.106245] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[ 4642.106278] usb 6-0:1.0: uevent
[ 4642.106361] hub 6-0:1.0: usb_probe_interface
[ 4642.106365] hub 6-0:1.0: usb_probe_interface - got id
[ 4642.106370] hub 6-0:1.0: USB hub found
[ 4642.106386] hub 6-0:1.0: 3 ports detected
[ 4642.106389] hub 6-0:1.0: standalone hub
[ 4642.106393] hub 6-0:1.0: no power switching (usb 1.0)
[ 4642.106397] hub 6-0:1.0: no over-current protection
[ 4642.106401] hub 6-0:1.0: power on to power good time: 4ms
[ 4642.106411] hub 6-0:1.0: local power source is good
[ 4642.106416] hub 6-0:1.0: trying to enable port power on non-switchable hub
[ 4642.106511] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[ 4642.106551] ohci_hcd 0000:00:14.5: OHCI Host Controller
[ 4642.106690] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[ 4642.106710] ohci_hcd 0000:00:14.5: enabled AMD ISO transfers quirk
[ 4642.106737] ohci_hcd 0000:00:14.5: created debug files
[ 4642.106741] ohci_hcd 0000:00:14.5: supports USB remote wakeup
[ 4642.106756] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfddf5000
[ 4642.147506] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4642.164847] ohci_hcd 0000:00:14.5: OHCI controller state
[ 4642.164856] ohci_hcd 0000:00:14.5: OHCI 1.0, NO legacy support registers
[ 4642.164865] ohci_hcd 0000:00:14.5: control 0x283 RWC HCFS=operational CBSR=3
[ 4642.164872] ohci_hcd 0000:00:14.5: cmdstatus 0x00000 SOC=0
[ 4642.164879] ohci_hcd 0000:00:14.5: intrstatus 0x00000004 SF
[ 4642.164886] ohci_hcd 0000:00:14.5: intrenable 0x8000001a MIE UE RD WDH
[ 4642.164898] ohci_hcd 0000:00:14.5: hcca frame #0005
[ 4642.164905] ohci_hcd 0000:00:14.5: roothub.a 02001202 POTPGT=2 NOCP NPS NDP=2(2)
[ 4642.164912] ohci_hcd 0000:00:14.5: roothub.b 00000000 PPCM=0000 DR=0000
[ 4642.164918] ohci_hcd 0000:00:14.5: roothub.status 00008000 DRWE
[ 4642.164926] ohci_hcd 0000:00:14.5: roothub.portstatus [0] 0x00000100 PPS
[ 4642.164933] ohci_hcd 0000:00:14.5: roothub.portstatus [1] 0x00000100 PPS
[ 4642.164956] usb usb7: default language 0x0409
[ 4642.164970] usb usb7: udev 1, busnum 7, minor = 768
[ 4642.164974] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[ 4642.164979] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 4642.164984] usb usb7: Product: OHCI Host Controller
[ 4642.164988] usb usb7: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 4642.164992] usb usb7: SerialNumber: 0000:00:14.5
[ 4642.165094] usb usb7: uevent
[ 4642.166223] usb usb7: usb_probe_device
[ 4642.166230] usb usb7: configuration #1 chosen from 1 choice
[ 4642.166246] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[ 4642.166283] usb 7-0:1.0: uevent
[ 4642.166369] hub 7-0:1.0: usb_probe_interface
[ 4642.166373] hub 7-0:1.0: usb_probe_interface - got id
[ 4642.166378] hub 7-0:1.0: USB hub found
[ 4642.166394] hub 7-0:1.0: 2 ports detected
[ 4642.166398] hub 7-0:1.0: standalone hub
[ 4642.166402] hub 7-0:1.0: no power switching (usb 1.0)
[ 4642.166406] hub 7-0:1.0: no over-current protection
[ 4642.166410] hub 7-0:1.0: power on to power good time: 4ms
[ 4642.166420] hub 7-0:1.0: local power source is good
[ 4642.166425] hub 7-0:1.0: trying to enable port power on non-switchable hub
[ 4642.207505] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4642.267500] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 4643.097483] ohci_hcd 0000:00:12.0: auto-stop root hub
[ 4643.097504] ohci_hcd 0000:00:12.1: auto-stop root hub
[ 4643.097521] ohci_hcd 0000:00:13.0: auto-stop root hub
[ 4643.347483] ohci_hcd 0000:00:13.1: auto-stop root hub
[ 4643.347501] ohci_hcd 0000:00:14.5: auto-stop root hub
[ 4644.317487] hub 3-0:1.0: hub_suspend
[ 4644.317500] usb usb3: bus auto-suspend
[ 4644.317506] ohci_hcd 0000:00:12.0: suspend root hub
[ 4644.317516] hub 4-0:1.0: hub_suspend
[ 4644.317521] usb usb4: bus auto-suspend
[ 4644.317526] ohci_hcd 0000:00:12.1: suspend root hub
[ 4644.317534] hub 5-0:1.0: hub_suspend
[ 4644.317539] usb usb5: bus auto-suspend
[ 4644.317544] ohci_hcd 0000:00:13.0: suspend root hub
[ 4644.317552] hub 6-0:1.0: hub_suspend
[ 4644.317557] usb usb6: bus auto-suspend
[ 4644.317562] ohci_hcd 0000:00:13.1: suspend root hub
[ 4644.317569] hub 7-0:1.0: hub_suspend
[ 4644.317574] usb usb7: bus auto-suspend
[ 4644.317579] ohci_hcd 0000:00:14.5: suspend root hub
[ 4648.692184] usb usb2: usb resume
[ 4648.692193] ehci_hcd 0000:00:13.2: resume root hub
[ 4648.717486] hub 2-0:1.0: hub_resume
[ 4648.717514] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
[ 4648.717521] hub 2-0:1.0: port 3: status 0501 change 0001
[ 4648.820828] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[ 4648.820846] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[ 4648.820871] ehci_hcd 0000:00:13.2: port 3 low speed --> companion
[ 4648.820930] usb usb5: usb resume
[ 4648.830402] ohci_hcd 0000:00:13.0: wakeup root hub
[ 4648.874163] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001002 POWER sig=se0 CSC
[ 4648.874190] hub 2-0:1.0: unable to enumerate USB device on port 3
[ 4648.874202] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[ 4648.895393] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[ 4648.895410] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001003 POWER sig=se0 CSC CONNECT
[ 4648.895424] hub 2-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
[ 4648.900403] hub 5-0:1.0: hub_resume
[ 4648.900428] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 0x00010100 CSC PPS
[ 4648.924159] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
[ 4649.044158] hub 2-0:1.0: debounce: port 3: total 125ms stable 100ms status 0x501
[ 4649.044175] ehci_hcd 0000:00:13.2: port 3 low speed --> companion
[ 4649.097491] ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[ 4649.097524] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[ 4649.097534] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0008
[ 4649.097545] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 0x00010301 CSC LSDA PPS CCS
[ 4649.097554] hub 5-0:1.0: port 3, status 0301, change 0001, 1.5 Mb/s
[ 4649.217491] hub 5-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x301
[ 4649.240849] ohci_hcd 0000:00:13.0: port[2] reset timeout, stat 00000311
[ 4649.294156] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
[ 4649.347499] usb 5-3: new low speed USB device using ohci_hcd and address 2
[ 4649.370848] ohci_hcd 0000:00:13.0: port[2] reset timeout, stat 00000313
[ 4649.424156] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
[ 4649.501243] usb 5-3: skipped 1 descriptor after interface
[ 4649.501251] usb 5-3: skipped 1 descriptor after interface
[ 4649.503247] usb 5-3: default language 0x0409
[ 4649.508251] usb 5-3: udev 2, busnum 5, minor = 513
[ 4649.508258] usb 5-3: New USB device found, idVendor=046d, idProduct=c518
[ 4649.508263] usb 5-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 4649.508268] usb 5-3: Product: USB Receiver
[ 4649.508272] usb 5-3: Manufacturer: Logitech
[ 4649.508390] usb 5-3: uevent
[ 4649.509935] usb 5-3: usb_probe_device
[ 4649.509942] usb 5-3: configuration #1 chosen from 1 choice
[ 4649.519242] usb 5-3: adding 5-3:1.0 (config #1, interface 0)
[ 4649.519302] usb 5-3:1.0: uevent
[ 4649.519422] usbhid 5-3:1.0: usb_probe_interface
[ 4649.519428] usbhid 5-3:1.0: usb_probe_interface - got id
[ 4649.526229] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:13.0/usb5/5-3/5-3:1.0/input/input5
[ 4649.526542] generic-usb 0003:046D:C518.0003: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:13.0-3/input0
[ 4649.526582] usb 5-3: adding 5-3:1.1 (config #1, interface 1)
[ 4649.526626] usb 5-3:1.1: uevent
[ 4649.527441] usbhid 5-3:1.1: usb_probe_interface
[ 4649.527448] usbhid 5-3:1.1: usb_probe_interface - got id
[ 4649.531694] usb 5-3:1.0: uevent
[ 4649.531865] usb 5-3: uevent
[ 4649.532064] usb 5-3:1.0: uevent
[ 4649.532234] usb 5-3: uevent
[ 4649.533871] usb 5-3:1.0: uevent
[ 4649.534280] usb 5-3:1.0: uevent
[ 4649.537474] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:13.0/usb5/5-3/5-3:1.1/input/input6
[ 4649.537553] drivers/usb/core/file.c: looking for a minor, starting at 96
[ 4649.537671] generic-usb 0003:046D:C518.0004: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:13.0-3/input1
[ 4649.537731] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0008
[ 4649.543613] usb 5-3:1.1: uevent
[ 4649.543769] usb 5-3: uevent
[ 4649.546227] usb 5-3:1.1: uevent
[ 4651.317487] hub 2-0:1.0: hub_suspend
[ 4651.317501] usb usb2: bus auto-suspend
[ 4651.317507] ehci_hcd 0000:00:13.2: suspend root hub
[ 4772.774530] usb usb7: usb auto-resume
[ 4772.774544] ohci_hcd 0000:00:14.5: resume root hub
[ 4772.844137] hub 7-0:1.0: hub_resume
[ 4772.844172] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 4772.844290] usb usb6: usb auto-resume
[ 4772.844300] ohci_hcd 0000:00:13.1: resume root hub
[ 4772.914136] hub 6-0:1.0: hub_resume
[ 4772.914170] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4772.914379] usb usb4: usb auto-resume
[ 4772.914389] ohci_hcd 0000:00:12.1: resume root hub
[ 4772.984136] hub 4-0:1.0: hub_resume
[ 4772.984169] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4772.984274] usb usb3: usb auto-resume
[ 4772.984282] ohci_hcd 0000:00:12.0: resume root hub
[ 4773.054136] hub 3-0:1.0: hub_resume
[ 4773.054169] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4773.054272] usb usb2: usb auto-resume
[ 4773.054279] ehci_hcd 0000:00:13.2: resume root hub
[ 4773.104136] hub 2-0:1.0: hub_resume
[ 4773.104176] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 4773.104280] usb usb1: usb auto-resume
[ 4773.104287] ehci_hcd 0000:00:12.2: resume root hub
[ 4773.130803] hub 1-0:1.0: hub_resume
[ 4773.130823] hub 1-0:1.0: port 2: status 0507 change 0000
[ 4773.130848] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 4773.130864] usb 1-2: usb auto-resume
[ 4773.160823] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 4773.174145] usb 1-2: finish resume
[ 4773.174559] hub 1-2:1.0: hub_resume
[ 4773.175562] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800180 schedule
[ 4773.175570] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[ 4773.175590] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0000
[ 4773.847469] ohci_hcd 0000:00:14.5: auto-stop root hub
[ 4774.097471] ohci_hcd 0000:00:13.1: auto-stop root hub
[ 4774.097493] ohci_hcd 0000:00:12.1: auto-stop root hub
[ 4774.097510] ohci_hcd 0000:00:12.0: auto-stop root hub
[ 4775.317479] hub 7-0:1.0: hub_suspend
[ 4775.317494] usb usb7: bus auto-suspend
[ 4775.317502] ohci_hcd 0000:00:14.5: suspend root hub
[ 4775.317513] hub 6-0:1.0: hub_suspend
[ 4775.317518] usb usb6: bus auto-suspend
[ 4775.317523] ohci_hcd 0000:00:13.1: suspend root hub
[ 4775.317531] hub 4-0:1.0: hub_suspend
[ 4775.317536] usb usb4: bus auto-suspend
[ 4775.317541] ohci_hcd 0000:00:12.1: suspend root hub
[ 4775.317549] hub 3-0:1.0: hub_suspend
[ 4775.317555] usb usb3: bus auto-suspend
[ 4775.317559] ohci_hcd 0000:00:12.0: suspend root hub
[ 4775.317568] hub 2-0:1.0: hub_suspend
[ 4775.317573] usb usb2: bus auto-suspend
[ 4775.317577] ehci_hcd 0000:00:13.2: suspend root hub
[ 4775.318450] hub 1-2:1.0: hub_suspend
[ 4775.318459] usb 1-2: unlink qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[ 4775.318719] usb 1-2: usb auto-suspend
[ 4778.317505] hub 1-0:1.0: hub_suspend
[ 4778.317519] usb usb1: bus auto-suspend
[ 4778.317524] ehci_hcd 0000:00:12.2: suspend root hub
[ 4781.882644] usb usb7: usb auto-resume
[ 4781.882652] ohci_hcd 0000:00:14.5: resume root hub
[ 4781.951945] hub 7-0:1.0: hub_resume
[ 4781.951980] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 4781.952095] usb usb6: usb auto-resume
[ 4781.952105] ohci_hcd 0000:00:13.1: resume root hub
[ 4782.020803] hub 6-0:1.0: hub_resume
[ 4782.020838] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4782.021048] usb usb4: usb auto-resume
[ 4782.021057] ohci_hcd 0000:00:12.1: resume root hub
[ 4782.090803] hub 4-0:1.0: hub_resume
[ 4782.090837] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4782.090942] usb usb3: usb auto-resume
[ 4782.090951] ohci_hcd 0000:00:12.0: resume root hub
[ 4782.160803] hub 3-0:1.0: hub_resume
[ 4782.160837] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 4782.160940] usb usb2: usb auto-resume
[ 4782.160947] ehci_hcd 0000:00:13.2: resume root hub
[ 4782.210802] hub 2-0:1.0: hub_resume
[ 4782.210843] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 4782.210952] usb usb1: usb auto-resume
[ 4782.210959] ehci_hcd 0000:00:12.2: resume root hub
[ 4782.237469] hub 1-0:1.0: hub_resume
[ 4782.237489] hub 1-0:1.0: port 2: status 0507 change 0000
[ 4782.237514] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 4782.237530] usb 1-2: usb auto-resume
[ 4782.267493] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 4782.280822] usb 1-2: finish resume
[ 4782.281231] hub 1-2:1.0: hub_resume
[ 4782.282234] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800180 schedule
[ 4782.282241] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[ 4782.282261] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0000
[ 4783.097469] ohci_hcd 0000:00:14.5: auto-stop root hub
[ 4783.097491] ohci_hcd 0000:00:13.1: auto-stop root hub
[ 4783.097508] ohci_hcd 0000:00:12.1: auto-stop root hub
[ 4783.347470] ohci_hcd 0000:00:12.0: auto-stop root hub
[ 4784.317479] hub 7-0:1.0: hub_suspend
[ 4784.317495] usb usb7: bus auto-suspend
[ 4784.317503] ohci_hcd 0000:00:14.5: suspend root hub
[ 4784.317513] hub 6-0:1.0: hub_suspend
[ 4784.317519] usb usb6: bus auto-suspend
[ 4784.317524] ohci_hcd 0000:00:13.1: suspend root hub
[ 4784.317532] hub 4-0:1.0: hub_suspend
[ 4784.317538] usb usb4: bus auto-suspend
[ 4784.317543] ohci_hcd 0000:00:12.1: suspend root hub
[ 4784.317551] hub 3-0:1.0: hub_suspend
[ 4784.317556] usb usb3: bus auto-suspend
[ 4784.317561] ohci_hcd 0000:00:12.0: suspend root hub
[ 4784.317569] hub 2-0:1.0: hub_suspend
[ 4784.317574] usb usb2: bus auto-suspend
[ 4784.317579] ehci_hcd 0000:00:13.2: suspend root hub
[ 4784.318109] hub 1-2:1.0: hub_suspend
[ 4784.318119] usb 1-2: unlink qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[ 4784.318382] usb 1-2: usb auto-suspend
[ 4787.317475] hub 1-0:1.0: hub_suspend
[ 4787.317491] usb usb1: bus auto-suspend
[ 4787.317497] ehci_hcd 0000:00:12.2: suspend root hub

--Boundary-00=_nEQsKwbmmXrOX8a
Content-Type: text/plain;
  charset="ISO-8859-15";
  name="usbmon_5u"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="usbmon_5u"

ffff88019e545000 99404519 C Ii:5:002:1 0:8 7 = 0000eb0f 020000
ffff88019e545000 99404571 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99412517 C Ii:5:002:1 0:8 7 = 0000f70f 000000
ffff88019e545000 99412541 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99420519 C Ii:5:002:1 0:8 7 = 0000ee0f 000000
ffff88019e545000 99420544 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99428519 C Ii:5:002:1 0:8 7 = 0000f60f 000000
ffff88019e545000 99428541 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99436525 C Ii:5:002:1 0:8 7 = 0000f50f 000000
ffff88019e545000 99436551 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99444522 C Ii:5:002:1 0:8 7 = 0000f63f 000000
ffff88019e545000 99444555 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99452531 C Ii:5:002:1 0:8 7 = 0000f54f 000000
ffff88019e545000 99452559 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99460533 C Ii:5:002:1 0:8 7 = 0000f56f 000000
ffff88019e545000 99460561 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99468535 C Ii:5:002:1 0:8 7 = 0000f37f 000000
ffff88019e545000 99468562 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99476536 C Ii:5:002:1 0:8 7 = 0000f47f 000000
ffff88019e545000 99476564 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99484531 C Ii:5:002:1 0:8 7 = 0000f48f 000000
ffff88019e545000 99484557 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99492539 C Ii:5:002:1 0:8 7 = 0000f56f 000000
ffff88019e545000 99492567 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99500541 C Ii:5:002:1 0:8 7 = 0000f56f 000000
ffff88019e545000 99500569 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99508542 C Ii:5:002:1 0:8 7 = 0000f56f 000000
ffff88019e545000 99508570 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99516545 C Ii:5:002:1 0:8 7 = 0000f48f 000000
ffff88019e545000 99516572 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99524548 C Ii:5:002:1 0:8 7 = 0000f58f 000000
ffff88019e545000 99524575 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99532548 C Ii:5:002:1 0:8 7 = 0000f5af 000000
ffff88019e545000 99532575 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99540549 C Ii:5:002:1 0:8 7 = 0000f5af 000000
ffff88019e545000 99540576 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99548551 C Ii:5:002:1 0:8 7 = 0000f6cf 000000
ffff88019e545000 99548578 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99556552 C Ii:5:002:1 0:8 7 = 0000f6cf 000000
ffff88019e545000 99556580 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99564548 C Ii:5:002:1 0:8 7 = 0000f8df 000000
ffff88019e545000 99564573 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99572556 C Ii:5:002:1 0:8 7 = 0000f8df 000000
ffff88019e545000 99572583 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99580558 C Ii:5:002:1 0:8 7 = 0000fadf 000000
ffff88019e545000 99580585 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99588559 C Ii:5:002:1 0:8 7 = 0000fcdf 000000
ffff88019e545000 99588586 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99596561 C Ii:5:002:1 0:8 7 = 0000fddf 000000
ffff88019e545000 99596588 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99604562 C Ii:5:002:1 0:8 7 = 0000fdcf 000000
ffff88019e545000 99604589 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99612564 C Ii:5:002:1 0:8 7 = 0000fecf 000000
ffff88019e545000 99612591 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99620565 C Ii:5:002:1 0:8 7 = 0000ffbf 000000
ffff88019e545000 99620593 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99628567 C Ii:5:002:1 0:8 7 = 0000ffaf 000000
ffff88019e545000 99628594 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99636569 C Ii:5:002:1 0:8 7 = 00000140 010000
ffff88019e545000 99636596 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99644566 C Ii:5:002:1 0:8 7 = 00000290 000000
ffff88019e545000 99644593 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99652565 C Ii:5:002:1 0:8 7 = 00000180 000000
ffff88019e545000 99652592 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99660573 C Ii:5:002:1 0:8 7 = 00000270 000000
ffff88019e545000 99660601 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99668575 C Ii:5:002:1 0:8 7 = 00000270 000000
ffff88019e545000 99668603 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99676577 C Ii:5:002:1 0:8 7 = 00000370 000000
ffff88019e545000 99676604 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99684572 C Ii:5:002:1 0:8 7 = 00000370 000000
ffff88019e545000 99684596 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99692581 C Ii:5:002:1 0:8 7 = 00000370 000000
ffff88019e545000 99692608 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99700582 C Ii:5:002:1 0:8 7 = 00000370 000000
ffff88019e545000 99700609 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99708584 C Ii:5:002:1 0:8 7 = 00000460 000000
ffff88019e545000 99708611 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99716585 C Ii:5:002:1 0:8 7 = 00000470 000000
ffff88019e545000 99716613 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99724580 C Ii:5:002:1 0:8 7 = 00000560 000000
ffff88019e545000 99724604 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99732588 C Ii:5:002:1 0:8 7 = 00000570 000000
ffff88019e545000 99732616 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99740590 C Ii:5:002:1 0:8 7 = 00000660 000000
ffff88019e545000 99740616 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99748591 C Ii:5:002:1 0:8 7 = 00000750 000000
ffff88019e545000 99748618 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99756593 C Ii:5:002:1 0:8 7 = 00000840 000000
ffff88019e545000 99756621 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99764588 C Ii:5:002:1 0:8 7 = 00000a40 000000
ffff88019e545000 99764612 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99772596 C Ii:5:002:1 0:8 7 = 00000a50 000000
ffff88019e545000 99772623 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99780598 C Ii:5:002:1 0:8 7 = 00000a30 000000
ffff88019e545000 99780625 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99788599 C Ii:5:002:1 0:8 7 = 00000a30 000000
ffff88019e545000 99788626 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99796601 C Ii:5:002:1 0:8 7 = 00000930 000000
ffff88019e545000 99796628 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99804596 C Ii:5:002:1 0:8 7 = 00000920 000000
ffff88019e545000 99804622 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99812605 C Ii:5:002:1 0:8 7 = 00000810 000000
ffff88019e545000 99812632 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99820606 C Ii:5:002:1 0:8 7 = 00001020 000000
ffff88019e545000 99820633 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99828608 C Ii:5:002:1 0:8 7 = 00000710 000000
ffff88019e545000 99828635 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99972638 C Ii:5:002:1 0:8 7 = 00000700 000000
ffff88019e545000 99972663 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 99996642 C Ii:5:002:1 0:8 7 = 00000700 000000
ffff88019e545000 99996668 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101316910 C Ii:5:002:1 0:8 7 = 0000adc0 fa0000
ffff88019e545000 101316943 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101340907 C Ii:5:002:1 0:8 7 = 000001a0 ff0000
ffff88019e545000 101340936 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101620964 C Ii:5:002:1 0:8 7 = 000001a0 ff0000
ffff88019e545000 101620993 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101789005 C Ii:5:002:1 0:8 7 = 00000350 f50000
ffff88019e545000 101789034 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101805008 C Ii:5:002:1 0:8 7 = 0000466f f90000
ffff88019e545000 101805039 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101957043 C Ii:5:002:1 0:8 7 = 0000906f 000000
ffff88019e545000 101957074 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101973042 C Ii:5:002:1 0:8 7 = 0000fa0f 000000
ffff88019e545000 101973070 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101981036 C Ii:5:002:1 0:8 7 = 0000b06f 010000
ffff88019e545000 101981067 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101989046 C Ii:5:002:1 0:8 7 = 0000fe2f 000000
ffff88019e545000 101989073 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 101997046 C Ii:5:002:1 0:8 7 = 0000fc4f 000000
ffff88019e545000 101997079 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102005049 C Ii:5:002:1 0:8 7 = 0000fc4f 000000
ffff88019e545000 102005080 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102013050 C Ii:5:002:1 0:8 7 = 0000fb5f 000000
ffff88019e545000 102013082 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102021045 C Ii:5:002:1 0:8 7 = 0000fa6f 000000
ffff88019e545000 102021077 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102029053 C Ii:5:002:1 0:8 7 = 0000fb6f 000000
ffff88019e545000 102029085 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102037055 C Ii:5:002:1 0:8 7 = 0000fc6f 000000
ffff88019e545000 102037085 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102045056 C Ii:5:002:1 0:8 7 = 0000fc5f 000000
ffff88019e545000 102045088 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102053058 C Ii:5:002:1 0:8 7 = 0000fe4f 000000
ffff88019e545000 102053088 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102061053 C Ii:5:002:1 0:8 7 = 0000fd4f 000000
ffff88019e545000 102061081 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102069061 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 102069093 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102077063 C Ii:5:002:1 0:8 7 = 0000ff2f 000000
ffff88019e545000 102077094 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102085065 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 102085097 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102093066 C Ii:5:002:1 0:8 7 = 0000ff4f 000000
ffff88019e545000 102093095 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102101061 C Ii:5:002:1 0:8 7 = 0000fc9f 000000
ffff88019e545000 102101089 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102109063 C Ii:5:002:1 0:8 7 = 0000fe5f 000000
ffff88019e545000 102109090 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102117072 C Ii:5:002:1 0:8 7 = 0000fd5f 000000
ffff88019e545000 102117099 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102125073 C Ii:5:002:1 0:8 7 = 0000fe5f 000000
ffff88019e545000 102125101 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102133068 C Ii:5:002:1 0:8 7 = 0000fe4f 000000
ffff88019e545000 102133096 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102141070 C Ii:5:002:1 0:8 7 = 0000ff4f 000000
ffff88019e545000 102141095 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102149072 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 102149101 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102157074 C Ii:5:002:1 0:8 7 = 0000fe3f 000000
ffff88019e545000 102157109 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102165075 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 102165110 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102173077 C Ii:5:002:1 0:8 7 = 00000020 000000
ffff88019e545000 102173107 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102181078 C Ii:5:002:1 0:8 7 = 0000ff2f 000000
ffff88019e545000 102181112 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102189086 C Ii:5:002:1 0:8 7 = 0000ff2f 000000
ffff88019e545000 102189119 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102197082 C Ii:5:002:1 0:8 7 = 0000ff4f 000000
ffff88019e545000 102197092 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102205084 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 102205097 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102213086 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 102213099 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102221081 C Ii:5:002:1 0:8 7 = 0000ff4f 000000
ffff88019e545000 102221090 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102229088 C Ii:5:002:1 0:8 7 = 00000020 000000
ffff88019e545000 102229097 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102237090 C Ii:5:002:1 0:8 7 = 00000030 000000
ffff88019e545000 102237099 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102245092 C Ii:5:002:1 0:8 7 = 00000020 000000
ffff88019e545000 102245104 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102253094 C Ii:5:002:1 0:8 7 = 00000110 000000
ffff88019e545000 102253106 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102261093 C Ii:5:002:1 0:8 7 = 00000120 000000
ffff88019e545000 102261119 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102269102 C Ii:5:002:1 0:8 7 = 00000120 000000
ffff88019e545000 102269133 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102277103 C Ii:5:002:1 0:8 7 = 00000130 000000
ffff88019e545000 102277132 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102285105 C Ii:5:002:1 0:8 7 = 00000150 000000
ffff88019e545000 102285134 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102293107 C Ii:5:002:1 0:8 7 = 00000030 000000
ffff88019e545000 102293134 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102301101 C Ii:5:002:1 0:8 7 = 00000030 000000
ffff88019e545000 102301129 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102309110 C Ii:5:002:1 0:8 7 = 00000040 000000
ffff88019e545000 102309137 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102317111 C Ii:5:002:1 0:8 7 = 00000120 000000
ffff88019e545000 102317140 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102325113 C Ii:5:002:1 0:8 7 = 00000230 000000
ffff88019e545000 102325142 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102333115 C Ii:5:002:1 0:8 7 = 00000330 000000
ffff88019e545000 102333143 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102341109 C Ii:5:002:1 0:8 7 = 00000320 000000
ffff88019e545000 102341141 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102349111 C Ii:5:002:1 0:8 7 = 00000540 000000
ffff88019e545000 102349143 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102357120 C Ii:5:002:1 0:8 7 = 00000530 000000
ffff88019e545000 102357151 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102365121 C Ii:5:002:1 0:8 7 = 00000630 000000
ffff88019e545000 102365153 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102373123 C Ii:5:002:1 0:8 7 = 00000830 000000
ffff88019e545000 102373150 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102381117 C Ii:5:002:1 0:8 7 = 00000720 000000
ffff88019e545000 102381147 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102389126 C Ii:5:002:1 0:8 7 = 00000820 000000
ffff88019e545000 102389151 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102397121 C Ii:5:002:1 0:8 7 = 00000820 000000
ffff88019e545000 102397150 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102405129 C Ii:5:002:1 0:8 7 = 00000910 000000
ffff88019e545000 102405161 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102413131 C Ii:5:002:1 0:8 7 = 00000920 000000
ffff88019e545000 102413163 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102421126 C Ii:5:002:1 0:8 7 = 00000710 000000
ffff88019e545000 102421154 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102429134 C Ii:5:002:1 0:8 7 = 00000710 000000
ffff88019e545000 102429163 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102437129 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 102437156 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102445137 C Ii:5:002:1 0:8 7 = 00000410 000000
ffff88019e545000 102445166 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102453139 C Ii:5:002:1 0:8 7 = 00000200 000000
ffff88019e545000 102453166 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102461134 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 102461157 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102477138 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 102477162 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102485146 C Ii:5:002:1 0:8 7 = 00000200 000000
ffff88019e545000 102485171 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102493148 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 102493173 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102501142 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 102501167 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102509151 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 102509176 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102517146 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 102517170 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102525154 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102525179 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102533156 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102533182 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102541150 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 102541175 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102549152 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 102549177 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102557154 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 102557178 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102565162 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 102565188 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102573164 C Ii:5:002:1 0:8 7 = 00000110 000000
ffff88019e545000 102573190 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102581159 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 102581184 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102589160 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 102589183 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102597169 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 102597194 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102605170 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 102605195 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102613172 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102613198 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102621167 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102621192 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102629175 C Ii:5:002:1 0:8 7 = 00000710 000000
ffff88019e545000 102629202 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102637177 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 102637202 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102645178 C Ii:5:002:1 0:8 7 = 00000c00 000000
ffff88019e545000 102645204 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102653180 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 102653208 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102661175 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102661197 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102669184 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 102669209 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102677185 C Ii:5:002:1 0:8 7 = 00000310 000000
ffff88019e545000 102677212 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102685186 C Ii:5:002:1 0:8 7 = 00000510 000000
ffff88019e545000 102685214 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102693189 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102693214 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102701183 C Ii:5:002:1 0:8 7 = 00000510 000000
ffff88019e545000 102701209 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102709191 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102709217 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102717193 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 102717219 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102725195 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102725220 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102733196 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 102733222 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102741191 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102741216 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102749199 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102749225 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102757201 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102757227 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102765196 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 102765221 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102773205 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 102773230 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102781199 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 102781224 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102789208 C Ii:5:002:1 0:8 7 = 00000f10 000000
ffff88019e545000 102789235 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102797209 C Ii:5:002:1 0:8 7 = 00000810 000000
ffff88019e545000 102797237 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102805211 C Ii:5:002:1 0:8 7 = 00000900 000000
ffff88019e545000 102805236 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102813213 C Ii:5:002:1 0:8 7 = 00000b00 000000
ffff88019e545000 102813239 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 102973245 C Ii:5:002:1 0:8 7 = 00001500 000000
ffff88019e545000 102973273 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104301514 C Ii:5:002:1 0:8 7 = 00001500 000000
ffff88019e545000 104301544 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104317510 C Ii:5:002:1 0:8 7 = 00000a00 000000
ffff88019e545000 104317537 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104325519 C Ii:5:002:1 0:8 7 = 0000b50f ec0000
ffff88019e545000 104325547 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104341522 C Ii:5:002:1 0:8 7 = 0000fb0f 000000
ffff88019e545000 104341549 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104349523 C Ii:5:002:1 0:8 7 = 0000fa0f 000000
ffff88019e545000 104349553 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104357518 C Ii:5:002:1 0:8 7 = 0000f51f 000000
ffff88019e545000 104357546 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104365527 C Ii:5:002:1 0:8 7 = 0000fa1f 000000
ffff88019e545000 104365556 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104373528 C Ii:5:002:1 0:8 7 = 0000f91f 000000
ffff88019e545000 104373557 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104381530 C Ii:5:002:1 0:8 7 = 0000f91f 000000
ffff88019e545000 104381559 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104389531 C Ii:5:002:1 0:8 7 = 0000f91f 000000
ffff88019e545000 104389561 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104397526 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 104397557 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104405535 C Ii:5:002:1 0:8 7 = 0000f72f 000000
ffff88019e545000 104405566 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104413534 C Ii:5:002:1 0:8 7 = 0000f82f 000000
ffff88019e545000 104413565 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104421538 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 104421567 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104429543 C Ii:5:002:1 0:8 7 = 0000f82f 000000
ffff88019e545000 104429572 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104437534 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 104437562 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104445543 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 104445572 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104453545 C Ii:5:002:1 0:8 7 = 0000f82f 000000
ffff88019e545000 104453573 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104461546 C Ii:5:002:1 0:8 7 = 0000f91f 000000
ffff88019e545000 104461578 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104469548 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 104469580 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104477543 C Ii:5:002:1 0:8 7 = 0000f91f 000000
ffff88019e545000 104477573 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104485551 C Ii:5:002:1 0:8 7 = 0000f71f 000000
ffff88019e545000 104485580 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104493553 C Ii:5:002:1 0:8 7 = 0000ef3f 000000
ffff88019e545000 104493582 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104501554 C Ii:5:002:1 0:8 7 = 0000f82f 000000
ffff88019e545000 104501583 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104509556 C Ii:5:002:1 0:8 7 = 0000f82f 000000
ffff88019e545000 104509585 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104517551 C Ii:5:002:1 0:8 7 = 0000f73f 000000
ffff88019e545000 104517579 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104525560 C Ii:5:002:1 0:8 7 = 0000f93f 000000
ffff88019e545000 104525592 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104533561 C Ii:5:002:1 0:8 7 = 0000f93f 000000
ffff88019e545000 104533590 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104541563 C Ii:5:002:1 0:8 7 = 0000f93f 000000
ffff88019e545000 104541594 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104549564 C Ii:5:002:1 0:8 7 = 0000f93f 000000
ffff88019e545000 104549593 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104557559 C Ii:5:002:1 0:8 7 = 0000fa3f 000000
ffff88019e545000 104557587 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104565567 C Ii:5:002:1 0:8 7 = 0000f93f 000000
ffff88019e545000 104565596 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104573569 C Ii:5:002:1 0:8 7 = 0000fa2f 000000
ffff88019e545000 104573598 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104581571 C Ii:5:002:1 0:8 7 = 0000fb2f 000000
ffff88019e545000 104581599 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104589572 C Ii:5:002:1 0:8 7 = 0000fb3f 000000
ffff88019e545000 104589604 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104597567 C Ii:5:002:1 0:8 7 = 0000fd1f 000000
ffff88019e545000 104597598 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104605575 C Ii:5:002:1 0:8 7 = 0000fe1f 000000
ffff88019e545000 104605607 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104613577 C Ii:5:002:1 0:8 7 = 0000fd3f 000000
ffff88019e545000 104613606 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104621579 C Ii:5:002:1 0:8 7 = 0000fc4f 000000
ffff88019e545000 104621607 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104629573 C Ii:5:002:1 0:8 7 = 0000fc4f 000000
ffff88019e545000 104629602 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104637575 C Ii:5:002:1 0:8 7 = 0000f97f 000000
ffff88019e545000 104637603 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104645583 C Ii:5:002:1 0:8 7 = 0000fc4f 000000
ffff88019e545000 104645612 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104653585 C Ii:5:002:1 0:8 7 = 0000fd4f 000000
ffff88019e545000 104653612 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104661587 C Ii:5:002:1 0:8 7 = 0000fd3f 000000
ffff88019e545000 104661619 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104669589 C Ii:5:002:1 0:8 7 = 0000f95f 000000
ffff88019e545000 104669621 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104677583 C Ii:5:002:1 0:8 7 = 0000fd2f 000000
ffff88019e545000 104677614 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104685592 C Ii:5:002:1 0:8 7 = 0000fd3f 000000
ffff88019e545000 104685623 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104693593 C Ii:5:002:1 0:8 7 = 0000fd2f 000000
ffff88019e545000 104693626 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104701595 C Ii:5:002:1 0:8 7 = 0000fd3f 000000
ffff88019e545000 104701624 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104709597 C Ii:5:002:1 0:8 7 = 0000fc2f 000000
ffff88019e545000 104709626 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104717591 C Ii:5:002:1 0:8 7 = 0000fd2f 000000
ffff88019e545000 104717622 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104725600 C Ii:5:002:1 0:8 7 = 0000fb2f 000000
ffff88019e545000 104725632 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104733601 C Ii:5:002:1 0:8 7 = 0000fc2f 000000
ffff88019e545000 104733630 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104741603 C Ii:5:002:1 0:8 7 = 0000fb2f 000000
ffff88019e545000 104741632 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104749605 C Ii:5:002:1 0:8 7 = 0000fb2f 000000
ffff88019e545000 104749634 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104757599 C Ii:5:002:1 0:8 7 = 0000fd3f 000000
ffff88019e545000 104757627 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104765608 C Ii:5:002:1 0:8 7 = 0000fd2f 000000
ffff88019e545000 104765636 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104773610 C Ii:5:002:1 0:8 7 = 0000fd2f 000000
ffff88019e545000 104773639 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104781611 C Ii:5:002:1 0:8 7 = 0000fe2f 000000
ffff88019e545000 104781643 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104789613 C Ii:5:002:1 0:8 7 = 0000ff1f 000000
ffff88019e545000 104789645 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104797608 C Ii:5:002:1 0:8 7 = 0000ff1f 000000
ffff88019e545000 104797638 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104805616 C Ii:5:002:1 0:8 7 = 0000ff2f 000000
ffff88019e545000 104805645 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104813618 C Ii:5:002:1 0:8 7 = 0000fe3f 000000
ffff88019e545000 104813647 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104821619 C Ii:5:002:1 0:8 7 = 0000ff2f 000000
ffff88019e545000 104821648 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104829622 C Ii:5:002:1 0:8 7 = 0000fe2f 000000
ffff88019e545000 104829651 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104837615 C Ii:5:002:1 0:8 7 = 0000fd2f 000000
ffff88019e545000 104837643 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104845624 C Ii:5:002:1 0:8 7 = 0000fe2f 000000
ffff88019e545000 104845656 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104853626 C Ii:5:002:1 0:8 7 = 0000fd2f 000000
ffff88019e545000 104853658 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104861627 C Ii:5:002:1 0:8 7 = 0000fe2f 000000
ffff88019e545000 104861659 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104869632 C Ii:5:002:1 0:8 7 = 0000fe1f 000000
ffff88019e545000 104869660 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104877625 C Ii:5:002:1 0:8 7 = 0000ff1f 000000
ffff88019e545000 104877651 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104885633 C Ii:5:002:1 0:8 7 = 0000ff1f 000000
ffff88019e545000 104885660 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104893635 C Ii:5:002:1 0:8 7 = 00000010 000000
ffff88019e545000 104893660 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104901636 C Ii:5:002:1 0:8 7 = 0000ff1f 000000
ffff88019e545000 104901663 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104909638 C Ii:5:002:1 0:8 7 = 00000030 000000
ffff88019e545000 104909664 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104917633 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 104917659 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104925641 C Ii:5:002:1 0:8 7 = 0000ff3f 000000
ffff88019e545000 104925668 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104933642 C Ii:5:002:1 0:8 7 = 0000ff4f 000000
ffff88019e545000 104933670 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104941645 C Ii:5:002:1 0:8 7 = 0000ff4f 000000
ffff88019e545000 104941673 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104949646 C Ii:5:002:1 0:8 7 = 0000fe3f 000000
ffff88019e545000 104949673 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104957640 C Ii:5:002:1 0:8 7 = 0000ff2f 000000
ffff88019e545000 104957667 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104965649 C Ii:5:002:1 0:8 7 = 00000020 000000
ffff88019e545000 104965675 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104973651 C Ii:5:002:1 0:8 7 = 00000010 000000
ffff88019e545000 104973678 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104981652 C Ii:5:002:1 0:8 7 = 00000010 000000
ffff88019e545000 104981678 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104989654 C Ii:5:002:1 0:8 7 = 00000150 000000
ffff88019e545000 104989684 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 104997648 C Ii:5:002:1 0:8 7 = 00000230 000000
ffff88019e545000 104997676 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105005656 C Ii:5:002:1 0:8 7 = 00000340 000000
ffff88019e545000 105005686 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105013658 C Ii:5:002:1 0:8 7 = 00000440 000000
ffff88019e545000 105013687 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105021660 C Ii:5:002:1 0:8 7 = 00000350 000000
ffff88019e545000 105021688 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105029662 C Ii:5:002:1 0:8 7 = 00000360 000000
ffff88019e545000 105029691 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105037656 C Ii:5:002:1 0:8 7 = 00000270 000000
ffff88019e545000 105037687 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105045657 C Ii:5:002:1 0:8 7 = 00000280 000000
ffff88019e545000 105045687 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105053666 C Ii:5:002:1 0:8 7 = 00000280 000000
ffff88019e545000 105053695 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105061668 C Ii:5:002:1 0:8 7 = 00000260 000000
ffff88019e545000 105061696 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105069670 C Ii:5:002:1 0:8 7 = 00000160 000000
ffff88019e545000 105069699 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105077664 C Ii:5:002:1 0:8 7 = 00000170 000000
ffff88019e545000 105077692 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105085673 C Ii:5:002:1 0:8 7 = 00000150 000000
ffff88019e545000 105085702 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105093674 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105093706 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105101676 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105101703 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105109678 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105109706 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105117672 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105117700 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105125681 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105125708 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105133683 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105133710 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105141684 C Ii:5:002:1 0:8 7 = 00000070 000000
ffff88019e545000 105141711 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105149686 C Ii:5:002:1 0:8 7 = 00000070 000000
ffff88019e545000 105149714 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105157680 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105157707 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105165689 C Ii:5:002:1 0:8 7 = 00000070 000000
ffff88019e545000 105165716 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105173691 C Ii:5:002:1 0:8 7 = 0000ff7f 000000
ffff88019e545000 105173721 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105181692 C Ii:5:002:1 0:8 7 = 00000070 000000
ffff88019e545000 105181719 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105189694 C Ii:5:002:1 0:8 7 = 0000ff6f 000000
ffff88019e545000 105189723 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105197689 C Ii:5:002:1 0:8 7 = 00000050 000000
ffff88019e545000 105197715 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105205697 C Ii:5:002:1 0:8 7 = 00000050 000000
ffff88019e545000 105205725 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105213699 C Ii:5:002:1 0:8 7 = 00000040 000000
ffff88019e545000 105213726 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105221700 C Ii:5:002:1 0:8 7 = 00000050 000000
ffff88019e545000 105221727 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105229702 C Ii:5:002:1 0:8 7 = 00000040 000000
ffff88019e545000 105229729 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105237696 C Ii:5:002:1 0:8 7 = 00000060 000000
ffff88019e545000 105237724 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105245698 C Ii:5:002:1 0:8 7 = 00000080 000000
ffff88019e545000 105245726 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105253709 C Ii:5:002:1 0:8 7 = 00000180 000000
ffff88019e545000 105253738 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105261708 C Ii:5:002:1 0:8 7 = 00000080 000000
ffff88019e545000 105261736 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105269710 C Ii:5:002:1 0:8 7 = 00000090 000000
ffff88019e545000 105269738 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105277705 C Ii:5:002:1 0:8 7 = 00000090 000000
ffff88019e545000 105277731 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105285713 C Ii:5:002:1 0:8 7 = 00000180 000000
ffff88019e545000 105285743 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105293715 C Ii:5:002:1 0:8 7 = 00000170 000000
ffff88019e545000 105293747 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105301716 C Ii:5:002:1 0:8 7 = 00000260 000000
ffff88019e545000 105301745 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105309718 C Ii:5:002:1 0:8 7 = 00000250 000000
ffff88019e545000 105309747 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105317713 C Ii:5:002:1 0:8 7 = 00000360 000000
ffff88019e545000 105317741 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105325721 C Ii:5:002:1 0:8 7 = 00000360 000000
ffff88019e545000 105325751 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105333723 C Ii:5:002:1 0:8 7 = 00000350 000000
ffff88019e545000 105333753 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105341724 C Ii:5:002:1 0:8 7 = 00000bc0 000000
ffff88019e545000 105341756 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105349726 C Ii:5:002:1 0:8 7 = 00000430 000000
ffff88019e545000 105349759 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105357721 C Ii:5:002:1 0:8 7 = 00000430 000000
ffff88019e545000 105357751 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105365730 C Ii:5:002:1 0:8 7 = 00000430 000000
ffff88019e545000 105365759 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105373731 C Ii:5:002:1 0:8 7 = 00000440 000000
ffff88019e545000 105373760 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105381733 C Ii:5:002:1 0:8 7 = 00000430 000000
ffff88019e545000 105381761 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105389735 C Ii:5:002:1 0:8 7 = 00000530 000000
ffff88019e545000 105389764 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105397729 C Ii:5:002:1 0:8 7 = 00000520 000000
ffff88019e545000 105397757 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105405737 C Ii:5:002:1 0:8 7 = 00000630 000000
ffff88019e545000 105405769 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105413739 C Ii:5:002:1 0:8 7 = 00000620 000000
ffff88019e545000 105413768 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105421741 C Ii:5:002:1 0:8 7 = 00000620 000000
ffff88019e545000 105421772 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105429743 C Ii:5:002:1 0:8 7 = 00000710 000000
ffff88019e545000 105429772 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105437737 C Ii:5:002:1 0:8 7 = 00000810 000000
ffff88019e545000 105437763 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105445740 C Ii:5:002:1 0:8 7 = 00000710 000000
ffff88019e545000 105445766 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105453742 C Ii:5:002:1 0:8 7 = 00000800 000000
ffff88019e545000 105453767 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105461743 C Ii:5:002:1 0:8 7 = 00000700 000000
ffff88019e545000 105461765 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105469745 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 105469771 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105477746 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 105477772 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105485755 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 105485784 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105493755 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 105493784 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105501757 C Ii:5:002:1 0:8 7 = 00000200 000000
ffff88019e545000 105501786 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105509759 C Ii:5:002:1 0:8 7 = 00000200 000000
ffff88019e545000 105509787 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105517754 C Ii:5:002:1 0:8 7 = 00000200 000000
ffff88019e545000 105517780 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105525762 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 105525789 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105533764 C Ii:5:002:1 0:8 7 = 000002f0 ff0000
ffff88019e545000 105533793 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105541765 C Ii:5:002:1 0:8 7 = 000004f0 ff0000
ffff88019e545000 105541794 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105549767 C Ii:5:002:1 0:8 7 = 000003f0 ff0000
ffff88019e545000 105549796 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105557761 C Ii:5:002:1 0:8 7 = 000004e0 ff0000
ffff88019e545000 105557789 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105565770 C Ii:5:002:1 0:8 7 = 000004d0 ff0000
ffff88019e545000 105565799 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105573771 C Ii:5:002:1 0:8 7 = 000004e0 ff0000
ffff88019e545000 105573802 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105581773 C Ii:5:002:1 0:8 7 = 000003e0 ff0000
ffff88019e545000 105581805 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105589775 C Ii:5:002:1 0:8 7 = 000003e0 ff0000
ffff88019e545000 105589804 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105597769 C Ii:5:002:1 0:8 7 = 000003e0 ff0000
ffff88019e545000 105597800 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105605778 C Ii:5:002:1 0:8 7 = 000001e0 ff0000
ffff88019e545000 105605807 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105613780 C Ii:5:002:1 0:8 7 = 000001e0 ff0000
ffff88019e545000 105613809 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105621781 C Ii:5:002:1 0:8 7 = 000001f0 ff0000
ffff88019e545000 105621810 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105629783 C Ii:5:002:1 0:8 7 = 000001e0 ff0000
ffff88019e545000 105629812 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105637778 C Ii:5:002:1 0:8 7 = 000001e0 ff0000
ffff88019e545000 105637806 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105645786 C Ii:5:002:1 0:8 7 = 000003a0 ff0000
ffff88019e545000 105645818 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105653788 C Ii:5:002:1 0:8 7 = 000003c0 ff0000
ffff88019e545000 105653817 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105661782 C Ii:5:002:1 0:8 7 = 000002b0 ff0000
ffff88019e545000 105661811 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105669791 C Ii:5:002:1 0:8 7 = 000002d0 ff0000
ffff88019e545000 105669820 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105677786 C Ii:5:002:1 0:8 7 = 000002c0 ff0000
ffff88019e545000 105677814 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105685794 C Ii:5:002:1 0:8 7 = 000002d0 ff0000
ffff88019e545000 105685823 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105693796 C Ii:5:002:1 0:8 7 = 000001d0 ff0000
ffff88019e545000 105693825 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105701797 C Ii:5:002:1 0:8 7 = 000001c0 ff0000
ffff88019e545000 105701826 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105709799 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 105709827 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105717794 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 105717820 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105725803 C Ii:5:002:1 0:8 7 = 000001e0 ff0000
ffff88019e545000 105725831 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105733805 C Ii:5:002:1 0:8 7 = 000001e0 ff0000
ffff88019e545000 105733834 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105741806 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 105741833 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105749808 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 105749835 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105757802 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 105757830 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105765811 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 105765839 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105773812 C Ii:5:002:1 0:8 7 = 0000ffdf ff0000
ffff88019e545000 105773841 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105781814 C Ii:5:002:1 0:8 7 = 0000fdcf ff0000
ffff88019e545000 105781842 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105789816 C Ii:5:002:1 0:8 7 = 0000fdbf ff0000
ffff88019e545000 105789845 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105797810 C Ii:5:002:1 0:8 7 = 0000fcbf ff0000
ffff88019e545000 105797841 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105805819 C Ii:5:002:1 0:8 7 = 0000fdbf ff0000
ffff88019e545000 105805850 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105813820 C Ii:5:002:1 0:8 7 = 0000febf ff0000
ffff88019e545000 105813850 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105821822 C Ii:5:002:1 0:8 7 = 0000ffbf ff0000
ffff88019e545000 105821851 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105829824 C Ii:5:002:1 0:8 7 = 0000ffbf ff0000
ffff88019e545000 105829854 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105837819 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 105837845 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105845827 C Ii:5:002:1 0:8 7 = 000000b0 ff0000
ffff88019e545000 105845854 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105853828 C Ii:5:002:1 0:8 7 = 000000b0 ff0000
ffff88019e545000 105853858 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105861830 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 105861859 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105869832 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 105869859 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105877829 C Ii:5:002:1 0:8 7 = 0000fe8f ff0000
ffff88019e545000 105877858 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105885835 C Ii:5:002:1 0:8 7 = 0000ffdf ff0000
ffff88019e545000 105885864 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105893837 C Ii:5:002:1 0:8 7 = 0000fdcf ff0000
ffff88019e545000 105893865 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105901838 C Ii:5:002:1 0:8 7 = 0000fdbf ff0000
ffff88019e545000 105901867 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105909840 C Ii:5:002:1 0:8 7 = 0000fecf ff0000
ffff88019e545000 105909869 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105917834 C Ii:5:002:1 0:8 7 = 0000febf ff0000
ffff88019e545000 105917863 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105925843 C Ii:5:002:1 0:8 7 = 0000ffbf ff0000
ffff88019e545000 105925874 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105933845 C Ii:5:002:1 0:8 7 = 0000ffcf ff0000
ffff88019e545000 105933873 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105941846 C Ii:5:002:1 0:8 7 = 000000a0 ff0000
ffff88019e545000 105941873 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105949848 C Ii:5:002:1 0:8 7 = 00000090 ff0000
ffff88019e545000 105949876 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105957843 C Ii:5:002:1 0:8 7 = 00000090 ff0000
ffff88019e545000 105957870 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105965851 C Ii:5:002:1 0:8 7 = 0000ff9f ff0000
ffff88019e545000 105965880 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105973853 C Ii:5:002:1 0:8 7 = 0000ff5f ff0000
ffff88019e545000 105973882 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105981854 C Ii:5:002:1 0:8 7 = 000000b0 ff0000
ffff88019e545000 105981883 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105989856 C Ii:5:002:1 0:8 7 = 0000ffbf ff0000
ffff88019e545000 105989886 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 105997851 C Ii:5:002:1 0:8 7 = 0000ffbf ff0000
ffff88019e545000 105997879 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106005859 C Ii:5:002:1 0:8 7 = 000000a0 ff0000
ffff88019e545000 106005888 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106013861 C Ii:5:002:1 0:8 7 = 0000ffcf ff0000
ffff88019e545000 106013889 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106021862 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 106021889 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106029864 C Ii:5:002:1 0:8 7 = 0000ffdf ff0000
ffff88019e545000 106029893 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106037859 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 106037885 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106045867 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 106045894 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106053869 C Ii:5:002:1 0:8 7 = 00000070 ff0000
ffff88019e545000 106053898 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106061870 C Ii:5:002:1 0:8 7 = 000000b0 ff0000
ffff88019e545000 106061899 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106069873 C Ii:5:002:1 0:8 7 = 000000a0 ff0000
ffff88019e545000 106069899 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106077867 C Ii:5:002:1 0:8 7 = 00000090 ff0000
ffff88019e545000 106077893 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106085870 C Ii:5:002:1 0:8 7 = 00000090 ff0000
ffff88019e545000 106085895 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106093872 C Ii:5:002:1 0:8 7 = 000000a0 ff0000
ffff88019e545000 106093896 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106101874 C Ii:5:002:1 0:8 7 = 00000090 ff0000
ffff88019e545000 106101899 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106109882 C Ii:5:002:1 0:8 7 = 000000b0 ff0000
ffff88019e545000 106109907 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106117879 C Ii:5:002:1 0:8 7 = 000000b0 ff0000
ffff88019e545000 106117905 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106125884 C Ii:5:002:1 0:8 7 = 000000b0 ff0000
ffff88019e545000 106125910 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106133887 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 106133913 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106141888 C Ii:5:002:1 0:8 7 = 000001d0 ff0000
ffff88019e545000 106141915 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106149889 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 106149914 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106157885 C Ii:5:002:1 0:8 7 = 000000d0 ff0000
ffff88019e545000 106157908 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106165892 C Ii:5:002:1 0:8 7 = 000001c0 ff0000
ffff88019e545000 106165920 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106173888 C Ii:5:002:1 0:8 7 = 000001d0 ff0000
ffff88019e545000 106173915 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106181896 C Ii:5:002:1 0:8 7 = 000002c0 ff0000
ffff88019e545000 106181929 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106189897 C Ii:5:002:1 0:8 7 = 000002c0 ff0000
ffff88019e545000 106189925 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106197895 C Ii:5:002:1 0:8 7 = 000002b0 ff0000
ffff88019e545000 106197923 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106205900 C Ii:5:002:1 0:8 7 = 000003c0 ff0000
ffff88019e545000 106205929 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106213902 C Ii:5:002:1 0:8 7 = 000003b0 ff0000
ffff88019e545000 106213931 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106221903 C Ii:5:002:1 0:8 7 = 000003c0 ff0000
ffff88019e545000 106221935 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106229905 C Ii:5:002:1 0:8 7 = 000004d0 ff0000
ffff88019e545000 106229937 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106237905 C Ii:5:002:1 0:8 7 = 00000990 ff0000
ffff88019e545000 106237934 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106245908 C Ii:5:002:1 0:8 7 = 000006d0 ff0000
ffff88019e545000 106245937 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106253909 C Ii:5:002:1 0:8 7 = 000007e0 ff0000
ffff88019e545000 106253938 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106261911 C Ii:5:002:1 0:8 7 = 000007e0 ff0000
ffff88019e545000 106261940 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106269913 C Ii:5:002:1 0:8 7 = 000008e0 ff0000
ffff88019e545000 106269941 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106277914 C Ii:5:002:1 0:8 7 = 000006e0 ff0000
ffff88019e545000 106277944 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106285916 C Ii:5:002:1 0:8 7 = 000005e0 ff0000
ffff88019e545000 106285947 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106293917 C Ii:5:002:1 0:8 7 = 000006e0 ff0000
ffff88019e545000 106293949 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106301919 C Ii:5:002:1 0:8 7 = 000003f0 ff0000
ffff88019e545000 106301951 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106309921 C Ii:5:002:1 0:8 7 = 00000200 000000
ffff88019e545000 106309948 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106317919 C Ii:5:002:1 0:8 7 = 000002f0 ff0000
ffff88019e545000 106317951 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106325924 C Ii:5:002:1 0:8 7 = 000004f0 ff0000
ffff88019e545000 106325956 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106333926 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 106333953 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106341927 C Ii:5:002:1 0:8 7 = 000005f0 ff0000
ffff88019e545000 106341959 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106349929 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 106349957 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106357927 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 106357955 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106365932 C Ii:5:002:1 0:8 7 = 00000700 000000
ffff88019e545000 106365959 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106373934 C Ii:5:002:1 0:8 7 = 00000800 000000
ffff88019e545000 106373961 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106381936 C Ii:5:002:1 0:8 7 = 000009f0 ff0000
ffff88019e545000 106381967 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106389937 C Ii:5:002:1 0:8 7 = 00000a00 000000
ffff88019e545000 106389969 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106397935 C Ii:5:002:1 0:8 7 = 00000800 000000
ffff88019e545000 106397963 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106405940 C Ii:5:002:1 0:8 7 = 00000810 000000
ffff88019e545000 106405969 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106413942 C Ii:5:002:1 0:8 7 = 00000820 000000
ffff88019e545000 106413974 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106421943 C Ii:5:002:1 0:8 7 = 00000720 000000
ffff88019e545000 106421975 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106437946 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 106437977 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106445948 C Ii:5:002:1 0:8 7 = 00000620 000000
ffff88019e545000 106445977 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106453950 C Ii:5:002:1 0:8 7 = 00001270 000000
ffff88019e545000 106453979 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106461952 C Ii:5:002:1 0:8 7 = 00000720 000000
ffff88019e545000 106461980 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106469959 C Ii:5:002:1 0:8 7 = 00000630 000000
ffff88019e545000 106469988 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106477954 C Ii:5:002:1 0:8 7 = 00000630 000000
ffff88019e545000 106477983 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106485957 C Ii:5:002:1 0:8 7 = 00000630 000000
ffff88019e545000 106485988 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106493951 C Ii:5:002:1 0:8 7 = 00000520 000000
ffff88019e545000 106493983 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106501960 C Ii:5:002:1 0:8 7 = 00000520 000000
ffff88019e545000 106501991 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106509962 C Ii:5:002:1 0:8 7 = 00000310 000000
ffff88019e545000 106509991 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106517962 C Ii:5:002:1 0:8 7 = 00000330 000000
ffff88019e545000 106517990 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106525965 C Ii:5:002:1 0:8 7 = 00000230 000000
ffff88019e545000 106525993 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106533966 C Ii:5:002:1 0:8 7 = 00000340 000000
ffff88019e545000 106533995 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106541968 C Ii:5:002:1 0:8 7 = 00000440 000000
ffff88019e545000 106541996 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106549970 C Ii:5:002:1 0:8 7 = 00000460 000000
ffff88019e545000 106550001 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106557970 C Ii:5:002:1 0:8 7 = 00000460 000000
ffff88019e545000 106558002 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106565973 C Ii:5:002:1 0:8 7 = 00000460 000000
ffff88019e545000 106566004 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106709997 C Ii:5:002:1 0:8 7 = 00000560 000000
ffff88019e545000 106710021 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106734007 C Ii:5:002:1 0:8 7 = 00000460 000000
ffff88019e545000 106734035 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106750004 C Ii:5:002:1 0:8 7 = 000021b0 070000
ffff88019e545000 106750028 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106758012 C Ii:5:002:1 0:8 7 = 00000120 000000
ffff88019e545000 106758040 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 106766014 C Ii:5:002:1 0:8 7 = 00000320 000000
ffff88019e545000 106766041 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108086283 C Ii:5:002:1 0:8 7 = 00000530 000000
ffff88019e545000 108086310 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108270320 C Ii:5:002:1 0:8 7 = 00000320 000000
ffff88019e545000 108270347 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108294317 C Ii:5:002:1 0:8 7 = 000072b0 e30000
ffff88019e545000 108294348 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108302325 C Ii:5:002:1 0:8 7 = 00003b5f 000000
ffff88019e545000 108302353 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108310326 C Ii:5:002:1 0:8 7 = 0000fa1f 000000
ffff88019e545000 108310355 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108318328 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 108318357 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108326330 C Ii:5:002:1 0:8 7 = 0000f91f 000000
ffff88019e545000 108326359 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108334324 C Ii:5:002:1 0:8 7 = 0000f82f 000000
ffff88019e545000 108334352 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108342333 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 108342365 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108350334 C Ii:5:002:1 0:8 7 = 0000f92f 000000
ffff88019e545000 108350368 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108358330 C Ii:5:002:1 0:8 7 = 0000f93f 000000
ffff88019e545000 108358357 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108366338 C Ii:5:002:1 0:8 7 = 0000fb2f 000000
ffff88019e545000 108366366 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108374333 C Ii:5:002:1 0:8 7 = 0000fc3f 000000
ffff88019e545000 108374358 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108382342 C Ii:5:002:1 0:8 7 = 0000fc2f 000000
ffff88019e545000 108382370 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108390343 C Ii:5:002:1 0:8 7 = 0000fd3f 000000
ffff88019e545000 108390371 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108398345 C Ii:5:002:1 0:8 7 = 0000fc2f 000000
ffff88019e545000 108398373 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108686405 C Ii:5:002:1 0:8 7 = 0000f66f 000000
ffff88019e545000 108686432 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108710408 C Ii:5:002:1 0:8 7 = 0000f94f 000000
ffff88019e545000 108710436 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108718410 C Ii:5:002:1 0:8 7 = 0000518f 090000
ffff88019e545000 108718438 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108726412 C Ii:5:002:1 0:8 7 = 0000fe1f 000000
ffff88019e545000 108726439 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108734406 C Ii:5:002:1 0:8 7 = 0000fc1f 000000
ffff88019e545000 108734437 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108742414 C Ii:5:002:1 0:8 7 = 0000fc1f 000000
ffff88019e545000 108742443 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108758418 C Ii:5:002:1 0:8 7 = 0000fc2f 000000
ffff88019e545000 108758447 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108766419 C Ii:5:002:1 0:8 7 = 0000fa1f 000000
ffff88019e545000 108766448 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108774413 C Ii:5:002:1 0:8 7 = 0000f42f 000000
ffff88019e545000 108774438 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108782422 C Ii:5:002:1 0:8 7 = 0000f70f 000000
ffff88019e545000 108782451 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108790424 C Ii:5:002:1 0:8 7 = 0000fdff ff0000
ffff88019e545000 108790456 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108798426 C Ii:5:002:1 0:8 7 = 0000ffff ff0000
ffff88019e545000 108798458 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108806427 C Ii:5:002:1 0:8 7 = 0000feef ff0000
ffff88019e545000 108806460 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108814422 C Ii:5:002:1 0:8 7 = 0000ffef ff0000
ffff88019e545000 108814451 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108822430 C Ii:5:002:1 0:8 7 = 0000fb8f ff0000
ffff88019e545000 108822462 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108830432 C Ii:5:002:1 0:8 7 = 0000fdcf ff0000
ffff88019e545000 108830464 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108838435 C Ii:5:002:1 0:8 7 = 0000fdbf ff0000
ffff88019e545000 108838463 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108846436 C Ii:5:002:1 0:8 7 = 0000fdbf ff0000
ffff88019e545000 108846463 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108854432 C Ii:5:002:1 0:8 7 = 0000feaf ff0000
ffff88019e545000 108854458 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108870441 C Ii:5:002:1 0:8 7 = 0000feaf ff0000
ffff88019e545000 108870468 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108878443 C Ii:5:002:1 0:8 7 = 0000fe8f ff0000
ffff88019e545000 108878470 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108886445 C Ii:5:002:1 0:8 7 = 0000fc7f ff0000
ffff88019e545000 108886472 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108894439 C Ii:5:002:1 0:8 7 = 0000fe7f ff0000
ffff88019e545000 108894466 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108902448 C Ii:5:002:1 0:8 7 = 0000fd5f ff0000
ffff88019e545000 108902475 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108910449 C Ii:5:002:1 0:8 7 = 0000fadf fe0000
ffff88019e545000 108910477 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108918444 C Ii:5:002:1 0:8 7 = 0000fe8f ff0000
ffff88019e545000 108918473 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108926446 C Ii:5:002:1 0:8 7 = 0000fe7f ff0000
ffff88019e545000 108926479 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108934447 C Ii:5:002:1 0:8 7 = 0000fe8f ff0000
ffff88019e545000 108934481 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108942449 C Ii:5:002:1 0:8 7 = 0000ff8f ff0000
ffff88019e545000 108942483 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108950451 C Ii:5:002:1 0:8 7 = 0000ff7f ff0000
ffff88019e545000 108950485 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108958458 C Ii:5:002:1 0:8 7 = 00000080 ff0000
ffff88019e545000 108958488 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108966454 C Ii:5:002:1 0:8 7 = 0000ff8f ff0000
ffff88019e545000 108966484 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108974458 C Ii:5:002:1 0:8 7 = 00000080 ff0000
ffff88019e545000 108974484 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108982458 C Ii:5:002:1 0:8 7 = 00000090 ff0000
ffff88019e545000 108982486 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108990460 C Ii:5:002:1 0:8 7 = 00000010 ff0000
ffff88019e545000 108990491 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 108998471 C Ii:5:002:1 0:8 7 = 000000a0 ff0000
ffff88019e545000 108998508 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109006469 C Ii:5:002:1 0:8 7 = 000000a0 ff0000
ffff88019e545000 109006503 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109014462 C Ii:5:002:1 0:8 7 = 000000a0 ff0000
ffff88019e545000 109014492 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109022471 C Ii:5:002:1 0:8 7 = 000000c0 ff0000
ffff88019e545000 109022498 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109030472 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109030499 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109038474 C Ii:5:002:1 0:8 7 = 000000f0 ff0000
ffff88019e545000 109038502 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109046476 C Ii:5:002:1 0:8 7 = 000000f0 ff0000
ffff88019e545000 109046504 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109062479 C Ii:5:002:1 0:8 7 = 000000f0 ff0000
ffff88019e545000 109062506 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109070480 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109070508 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109078482 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109078510 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109086484 C Ii:5:002:1 0:8 7 = 000000d0 ff0000
ffff88019e545000 109086511 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109094479 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109094505 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109102487 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109102514 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109110489 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109110517 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109118490 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109118519 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109126492 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109126520 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109134487 C Ii:5:002:1 0:8 7 = 000000e0 ff0000
ffff88019e545000 109134513 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109278523 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 109278553 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109286524 C Ii:5:002:1 0:8 7 = 00000210 000000
ffff88019e545000 109286554 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109302528 C Ii:5:002:1 0:8 7 = 00000210 000000
ffff88019e545000 109302556 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109310529 C Ii:5:002:1 0:8 7 = 00000110 000000
ffff88019e545000 109310561 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109318531 C Ii:5:002:1 0:8 7 = 00000310 000000
ffff88019e545000 109318560 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109326533 C Ii:5:002:1 0:8 7 = 00000110 000000
ffff88019e545000 109326561 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109334527 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 109334553 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109342536 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 109342563 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109350537 C Ii:5:002:1 0:8 7 = 00000010 000000
ffff88019e545000 109350566 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109374535 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 109374562 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109382544 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 109382571 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109390545 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 109390574 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109398547 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 109398574 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109406549 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 109406577 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109414553 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 109414581 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109430553 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 109430580 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109438555 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 109438583 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109446557 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 109446584 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109454556 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 109454585 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109462560 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 109462587 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109510570 C Ii:5:002:1 0:8 7 = 00000100 000000
ffff88019e545000 109510596 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109870643 C Ii:5:002:1 0:8 7 = 00000200 000000
ffff88019e545000 109870671 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109886646 C Ii:5:002:1 0:8 7 = 00005420 000000
ffff88019e545000 109886677 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109894648 C Ii:5:002:1 0:8 7 = 00002400 000000
ffff88019e545000 109894676 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109918652 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 109918681 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109926654 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 109926681 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109934656 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 109934682 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109942657 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 109942685 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109950659 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 109950686 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109958661 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 109958688 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109966662 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 109966689 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109974664 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 109974692 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109982666 C Ii:5:002:1 0:8 7 = 00000700 000000
ffff88019e545000 109982692 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109990667 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 109990694 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 109998669 C Ii:5:002:1 0:8 7 = 00000700 000000
ffff88019e545000 109998695 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110014672 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 110014700 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110022667 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 110022693 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110030675 C Ii:5:002:1 0:8 7 = 00000400 000000
ffff88019e545000 110030702 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110038677 C Ii:5:002:1 0:8 7 = 00000300 000000
ffff88019e545000 110038705 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110046678 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 110046706 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110054680 C Ii:5:002:1 0:8 7 = 00000210 000000
ffff88019e545000 110054709 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110062682 C Ii:5:002:1 0:8 7 = 00000310 000000
ffff88019e545000 110062713 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110078685 C Ii:5:002:1 0:8 7 = 00000910 000000
ffff88019e545000 110078716 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110086687 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 110086716 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110094688 C Ii:5:002:1 0:8 7 = 00000c20 000000
ffff88019e545000 110094717 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110102690 C Ii:5:002:1 0:8 7 = 00000600 000000
ffff88019e545000 110102717 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110110691 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 110110723 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110118693 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 110118721 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110134696 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 110134725 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110142698 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 110142727 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110150700 C Ii:5:002:1 0:8 7 = 00000610 000000
ffff88019e545000 110150728 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110158702 C Ii:5:002:1 0:8 7 = 00000b00 000000
ffff88019e545000 110158731 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110166703 C Ii:5:002:1 0:8 7 = 00000510 000000
ffff88019e545000 110166733 S Ii:5:002:1 -115:8 7 <
ffff88019e545000 110174705 C Ii:5:002:1 0:8 7 = 00000500 000000
ffff88019e545000 110174732 S Ii:5:002:1 -115:8 7 <

--Boundary-00=_nEQsKwbmmXrOX8a--
