Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXCMPiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXCMPiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXCMPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:38:16 -0400
Received: from hydra.gt.owl.de ([195.71.99.218]:49537 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbXCMPiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:38:14 -0400
X-Greylist: delayed 2017 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 11:38:14 EDT
Date: Tue, 13 Mar 2007 16:04:35 +0100
From: Florian Lohoff <flo@rfc822.org>
To: linux-kernel@vger.kernel.org
Subject: Boot fails with 2.6.20-rc3 / git-current Was: 2.6.20-rc3: Clocksource tsc unstable
Message-ID: <20070313150435.GA26303@paradigm.rfc822.org>
References: <4af2d03a0703090941hfebc1e5u5def6152847c965a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <4af2d03a0703090941hfebc1e5u5def6152847c965a@mail.gmail.com>
Organization: rfc822 - pure communication
X-SpiderMe: mh-200703131555@listme.rfc822.org
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 09, 2007 at 06:41:45PM +0100, Jiri Slaby wrote:
> Hi.
>=20
> I got this message after suspend;resume on my notebook
> Clocksource tsc unstable (delta =3D -154983451 ns)
>=20

I am getting the exact same line on bootup on my Fujitsu Siemens
Lifebook E8110. After that line the boot halts with current git:

Last lines on current git were:

	IPMI System Interface driver
	Clocksource tsc unstable ( delta =3D -160251929ns )

Now running:
	Linux laptop 2.6.21-rc2 #1 SMP PREEMPT Thu Mar 1 07:41:52 CET 2007 i686 GN=
U/Linux

which comes up with the same line when initializing IDE but continues
to run:

[    9.912917] ICH7: IDE controller at PCI slot 0000:00:1f.1
[    9.913025] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -=
> IRQ 20
[    9.913210] ICH7: chipset revision 2
[    9.913300] ICH7: not 100% native mode: will probe irqs later
[    9.913403]     ide0: BM-DMA at 0x1810-0x1817, BIOS settings: hda:DMA, h=
db:pio
[    9.913637] Probing IDE interface ide0...
[    9.997936] Clocksource tsc unstable (delta =3D -430882190 ns)
[   10.002393] hda: MATSHITAUJ-841Db, ATAPI CD/DVD-ROM drive
[   10.003539] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00000e10036532=
e4]
[   10.052945] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

CPU info:

flo@laptop:~$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Genuine Intel(R) CPU           T2400  @ 1.83GHz
stepping        : 8
cpu MHz         : 1333.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc pn=
i monitor vmx est tm2 xtpr
bogomips        : 3662.23
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Genuine Intel(R) CPU           T2400  @ 1.83GHz
stepping        : 8
cpu MHz         : 1333.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc pn=
i monitor vmx est tm2 xtpr
bogomips        : 3657.63
clflush size    : 64

--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF9r2DUaz2rXW+gJcRAjPOAJ41nJVWRXWriHz7E1RhPJqHGUcRdgCg0m2d
CkJXJcCE8SWU7HwlLzk4br8=
=KQz8
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
