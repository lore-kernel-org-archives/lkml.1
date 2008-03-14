Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYCNABj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYCNABj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYCNAB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:01:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45377 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757729AbYCNABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:01:24 -0400
X-Sasl-enc: 2eu4lKxpwFv+ki3Z08L0j+c+lkqitrRittvXIeMIpNp9 1205452881
Message-ID: <47D9C04E.3060208@imap.cc>
Date: Fri, 14 Mar 2008 01:01:18 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] WARNING: at drivers/base/sys.c:173
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D87238.8080305@imap.cc> <20080313195656.GA32463@codemonkey.org.uk>
In-Reply-To: <20080313195656.GA32463@codemonkey.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCFAC5A2B1B59E325AD5EDA6A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCFAC5A2B1B59E325AD5EDA6A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 13.03.2008 20:56 schrieb Dave Jones:

>  > [   56.759128] ------------[ cut here ]------------
>  > [   56.765058] WARNING: at drivers/base/sys.c:173 sysdev_driver_regi=
ster+0x34/0xce()
>  > [   56.776027] Modules linked in: acpi_cpufreq(+) speedstep_lib ip6t=
able_filter ip6_tables x_tables ipv6 microcode firmware_class loop osst s=
t sr_mod cdrom pata_acpi bas_gigaset snd_hda_intel gigaset isdn snd_pcm a=
ta_generic<6>ip_tables: (C) 2000-2006 Netfilter Core Team
>  > [   56.785293]  snd_timer aic7xxx slhc snd ohci1394 rtc_cmos ieee139=
4 shpchp crc_ccitt iTCO_wdt e1000e rtc_core iTCO_vendor_support soundcore=
 scsi_transport_spi watchdog_core pci_hotplug intel_agp button thermal ag=
pgart rtc_lib processor i2c_i801 watchdog_dev parport_pc i2c_core snd_pag=
e_alloc parport pata_marvell sg ext3 jbd mbcache linear sd_mod usbhid hid=
 ff_memless ahci libata scsi_mod ehci_hcd uhci_hcd usbcore dm_snapshot dm=
_mod
>  > [   56.805358] Pid: 2856, comm: modprobe Not tainted 2.6.25-rc5-mm1-=
testing #1
>  > [   56.810766]  [<c01272e9>] warn_on_slowpath+0x41/0x6d
>  > [   56.820628]  [<c0230065>] ? acpi_ns_lookup+0x2b5/0x497
>  > [   56.830455]  [<c0230e25>] ? acpi_evaluate_object+0x23e/0x249
>  > [   56.840414]  [<c02ff809>] ? mutex_unlock+0x8/0xa
>  > [   56.848380]  [<fa9fec1d>] ? acpi_processor_preregister_performanc=
e+0x4e6/0x4f1 [processor]
>  > [   56.858297]  [<c0286438>] ? cpufreq_register_driver+0x42/0xfc
>  > [   56.868263]  [<c026423d>] sysdev_driver_register+0x34/0xce
>  > [   56.877974]  [<c0286476>] cpufreq_register_driver+0x80/0xfc
>  > [   56.887327]  [<facde034>] acpi_cpufreq_init+0x34/0x3a [acpi_cpufr=
eq]
>  > [   56.897290]  [<c014ad7a>] sys_init_module+0x1816/0x1943
>  > [   56.907304]  [<facb5000>] ? icmp_checkentry+0x0/0x14 [ip_tables]
>  > [   56.917255]  [<c0183cd2>] ? sys_read+0x3b/0x60
>  > [   56.925094]  [<c0106aec>] sysenter_past_esp+0x6d/0xc5
>  > [   56.935071]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>  > [   56.945016] ---[ end trace 9ade9adb26b6da0a ]---

> Full dmesg please, with CPU_FREQ_DEBUG=3Dy, and boot with cpufreq.debug=
=3D7

You can find it at
http://gollum.phnxsoft.com/~ts/linux/dmesg.out
and the corresponding .config right beside it at
http://gollum.phnxsoft.com/~ts/linux/config-2.6.25-rc5-mm1

CCing linux-acpi as you did in your other mail.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCFAC5A2B1B59E325AD5EDA6A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH2cBPMdB4Whm86/kRAsUUAJ0TgS7GL56Fwk36nUofH85sQ9uhLQCfS2RH
0cbiBmYoLPdP90f5vAonEPQ=
=pyjM
-----END PGP SIGNATURE-----

--------------enigCFAC5A2B1B59E325AD5EDA6A--
