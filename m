Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbYELU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbYELU6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYELU6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:58:02 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57558 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759165AbYELU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:57:59 -0400
X-Sasl-enc: hwwEZbfN45PEU3Vn8A5cS1M71MR9VHOq9md6YmzCEPQa 1210625874
Message-ID: <4828AF43.9030608@imap.cc>
Date: Mon, 12 May 2008 22:57:39 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>, yakui.zhao@intel.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6.26-rc1] WARNING: at drivers/base/sys.c:183
References: <48273860.1000103@imap.cc> <20080511184658.GA2087@codemonkey.org.uk>
In-Reply-To: <20080511184658.GA2087@codemonkey.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEDE993C090B7CBD9AC736F43"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEDE993C090B7CBD9AC736F43
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 11.05.2008 20:46 schrieb Dave Jones:
>=20
>  > May 11 19:32:44 xenon kernel: [   29.607563] sysdev: class cpu: driv=
er (c0439804) has already been registered to a class, something is wrong,=
 but will forge on!
>  > May 11 19:32:44 xenon kernel: [   29.611835] ------------[ cut here =
]------------
>  > May 11 19:32:44 xenon kernel: [   29.616182] WARNING: at drivers/bas=
e/sys.c:183 sysdev_driver_register+0x59/0xf2()
>  > May 11 19:32:44 xenon kernel: [   29.622037] Modules linked in: acpi=
_cpufreq(+) speedstep_lib microcode firmware_class loop osst st sr_mod cd=
rom pata_acpi bas_gigaset snd_hda_intel gigaset isdn snd_pcm rtc_cmos ata=
_generic aic7xxx snd_timer rtc_core usblp snd slhc ohci1394 pata_marvell =
thermal ieee1394 rtc_lib i2c_i801 parport_pc intel_agp processor soundcor=
e crc_ccitt iTCO_wdt button scsi_transport_spi iTCO_vendor_support parpor=
t snd_page_alloc agpgart i2c_core sg ext3 jbd mbcache linear usbhid hid s=
d_mod ahci libata uhci_hcd ehci_hcd scsi_mod dock usbcore dm_snapshot dm_=
mod
>  > May 11 19:32:44 xenon kernel: [   29.648305] Pid: 2860, comm: modpro=
be Not tainted 2.6.26-rc1-testing #1
>  > May 11 19:32:44 xenon kernel: [   29.653156]  [<c0129d09>] warn_on_s=
lowpath+0x41/0x6d
>  > May 11 19:32:44 xenon kernel: [   29.658026]  [<c0120032>] ? push_rt=
_task+0xb1/0x1ab
>  > May 11 19:32:44 xenon kernel: [   29.664013]  [<c012a75a>] ? vprintk=
+0x3a5/0x3c5
>  > May 11 19:32:44 xenon kernel: [   29.670995]  [<c010b7a4>] ? native_=
sched_clock+0xe0/0xff
>  > May 11 19:32:44 xenon kernel: [   29.675849]  [<c010b7a4>] ? native_=
sched_clock+0xe0/0xff
>  > May 11 19:32:44 xenon kernel: [   29.680678]  [<c0143881>] ? put_loc=
k_stats+0xd/0x21
>  > May 11 19:32:44 xenon kernel: [   29.685465]  [<c012a78f>] ? printk+=
0x15/0x17
>  > May 11 19:32:44 xenon kernel: [   29.690406]  [<c026a57a>] sysdev_dr=
iver_register+0x59/0xf2
>  > May 11 19:32:44 xenon kernel: [   29.696845]  [<c02a8fe3>] cpufreq_r=
egister_driver+0x80/0xfc
>  > May 11 19:32:44 xenon kernel: [   29.701892]  [<faafe034>] acpi_cpuf=
req_init+0x34/0x3a [acpi_cpufreq]
>  > May 11 19:32:44 xenon kernel: [   29.708279]  [<c014d441>] sys_init_=
module+0x1883/0x1a34
>  > May 11 19:32:44 xenon kernel: [   29.713176]  [<c0106b63>] sysenter_=
past_esp+0x78/0xd1
>  > May 11 19:32:44 xenon kernel: [   29.718586]  =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  > May 11 19:32:44 xenon kernel: [   29.723414] ---[ end trace da2515dc=
0122d0b1 ]---
>=20
> And then we freak out when we init the next cpufreq module, acpi-cpufre=
q, which gets further
> and tries to actually get registered.
>=20
> I don't really understand what's happening that makes sysfs so unhappy.=

> I guess if we had a clue what driver 'c0439804' was me might have some =
clues.
> What symbols are near that address in /proc/kallsyms ?

According to /proc/kallsyms, c0439804 =3D cpufreq_sysdev_driver.

HTH
T.


--------------enigEDE993C090B7CBD9AC736F43
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIKK9QQ3+did9BuFsRAtqTAKCMZ7GOVwyogM3zl1r1oUuiXAxLEQCfeIWr
Who8M+t5Il3ozlCT6m0QPIk=
=lAl/
-----END PGP SIGNATURE-----

--------------enigEDE993C090B7CBD9AC736F43--
