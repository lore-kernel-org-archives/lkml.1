Return-Path: <linux-kernel-owner+w=401wt.eu-S967240AbXEGXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967240AbXEGXs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXEGXsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:48:55 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:35359 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755250AbXEGXsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:48:54 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
Date: Tue, 8 May 2007 02:47:48 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>
References: <20070507202734.GA3926@linux-os.sc.intel.com>
In-Reply-To: <20070507202734.GA3926@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2190289.AdOUzTgegd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705080247.54463.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2190289.AdOUzTgegd
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

07 May 2007 Pts tarihinde, Venki Pallipadi =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> i386 HPET changes.
>
> Patchset does the following changes to HPET support:
> * Add HPET force detect to ICH chipsets, and detect the
>   presence of HPET through PCI quirk.
> * Enable HPET timer to function in standard interrupt delivery mode,
> against the current legacy replacement mode
> * Enable HPET as a PER CPU time event, which will help in laptops that
>   supports C3 and hence has unreliable LAPIC timer.
>
> The changes enable processors to stay in idle longer, by increasing the
> average time spend in an idle state per call, by more than twice, on
> my dual core laptop. It reduces the number of interrupts on a totally
> idle system, compared to when I use PIT.

My machine (SONY VAIO FS-215B) just hangs/freezes (no oops, no MAGIC_SYSRQ)=
=20
after writing "ACPI: Power Button (CM) [PWRB]" on screen

=2E..
Machine check exception polling timer started.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
audit(1178591695.734:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
ACPI: AC Adapter [ADP1] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]

Normal boot sequence continues with following;

ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
=20
present [20070126]
ACPI: Thermal Zone [THRM] (98 C)
isapnp: Scanning for PnP cards...
Time: acpi_pm clocksource has been installed.
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Clocksource tsc unstable (delta =3D -490158796 ns)
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
loop: loaded (max 8 devices)
=2E..

System boots fine with hpet=3Ddisable and by the way, i tried the first ver=
sion=20
of this patchset without a problem (if i remembered correctly, it was just=
=20
force detects the hpet but only enables for x86_64)

zangetsu ~ # lspci
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express=20
Processor to DRAM Controller (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GM=
L=20
Express Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Expre=
ss=20
Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)=
=20
High Definition Audio Controller (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Famil=
y)=20
USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Famil=
y)=20
USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Famil=
y)=20
USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Famil=
y)=20
USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Famil=
y)=20
USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge=
=20
(rev 03)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family=
)=20
IDE Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus=
=20
Controller (rev 03)
06:03.0 CardBus bridge: Texas Instruments PCI7420 CardBus Controller
06:03.2 FireWire (IEEE 1394): Texas Instruments PCI7x20 1394a-2000 OHCI=20
Two-Port PHY/Link-Layer Controller
06:03.3 Mass storage controller: Texas Instruments PCI7420/7620 Combo CardB=
us,=20
1394a-2000 OHCI and SD/MS-Pro Controller
06:04.0 Network controller: Intel Corporation PRO/Wireless 2200BG Network=20
Connection (rev 05)
06:08.0 Ethernet controller: Intel Corporation 82562ET/EZ/GT/GZ - PRO/100 V=
E=20
(LOM) Ethernet Controller Mobile (rev 03)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2190289.AdOUzTgegd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGP7qqy7E6i0LKo6YRAjH0AKCKkTd360JhKqFDezi1ZvxDWNS1oQCgqhHk
h/2MUhQqLYdouzR47qojPgM=
=tMSE
-----END PGP SIGNATURE-----

--nextPart2190289.AdOUzTgegd--
