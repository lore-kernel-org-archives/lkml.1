Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYDJLS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYDJLS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 07:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYDJLSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 07:18:17 -0400
Received: from crypt.ethx.net ([82.165.27.140]:34301 "EHLO crypt.ethx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbYDJLSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:18:16 -0400
X-Greylist: delayed 1297 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2008 07:18:16 EDT
Subject: Samsung Q45 hard freeze during boot
From: Sam Morris <sam@robots.org.uk>
To: linux-kernel@vger.kernel.org
Cc: 475319-forwarded@bugs.debian.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PvuPcevSL/15chAQRuTz"
Date: Thu, 10 Apr 2008 11:38:51 +0100
Message-Id: <1207823931.8277.10.camel@tycho.robots.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
X-Spam-Bars: -
X-Spam-Report: hits=-1.4: ALL_TRUSTED=-1.44 with SpamAssassin 3.2.3 (2007-08-08) on crypt.ethx.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PvuPcevSL/15chAQRuTz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi there, I'm trying to get Linux working on a Samsung Q45 laptop.
2.6.22 works fine, but 2.6.24.3 and 2.6.25-rc8 both freeze hard during
boot time after the following messages:

        Waiting for /dev to be fully populated...
        agpgart: Detected an Intel 965GM Chipset.
        agpgart: AGP aperture is 256M @ 0xd0000000
        input: Power Button (FF) as /class/input/input2
        ACPI: Power Button (FF) [PWSRF]
        inputL Lid Switch as /class/input/input3
        ACPI: Lid Switch [LID0]
        input: Power Button (CM) as /class/input/input4
        ACPI: Power Button (CM) [PWRB]
        input: Sleep Button (CM) as /class/input/input5
        ACPI: Sleep Button (CM) [SLPB]
        ACPI: AC Adapter [ADP1] (on-line)
        ACPI: Battery Slot [BAT1] (battery present)

lspci output is as follows:

        00:00.0 Host bridge [0600]: Intel Corporation Mobile PM965/GM965/GL=
960 Memory Controller Hub [8086:2a00] (rev 03)
        00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile =
GM965/GL960 Integrated Graphics Controller [8086:2a02] (rev 03)
        00:02.1 Display controller [0380]: Intel Corporation Mobile GM965/G=
L960 Integrated Graphics Controller [8086:2a03] (rev 03)
        00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Famil=
y) USB UHCI Contoller #4 [8086:2834] (rev 03)
        00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Famil=
y) USB UHCI Controller #5 [8086:2835] (rev 03)
        00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Famil=
y) USB2 EHCI Controller #2 [8086:283a] (rev 03)
        00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family)=
 HD Audio Controller [8086:284b] (rev 03)
        00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) P=
CI Express Port 1 [8086:283f] (rev 03)
        00:1c.1 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) P=
CI Express Port 2 [8086:2841] (rev 03)
        00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Famil=
y) USB UHCI Controller #1 [8086:2830] (rev 03)
        00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Famil=
y) USB UHCI Controller #2 [8086:2831] (rev 03)
        00:1d.2 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Famil=
y) USB UHCI Controller #3 [8086:2832] (rev 03)
        00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Famil=
y) USB2 EHCI Controller #1 [8086:2836] (rev 03)
        00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridg=
e [8086:2448] (rev f3)
        00:1f.0 ISA bridge [0601]: Intel Corporation 82801HEM (ICH8M) LPC I=
nterface Controller [8086:2815] (rev 03)
        00:1f.2 IDE interface [0101]: Intel Corporation 82801HBM/HEM (ICH8M=
/ICH8M-E) SATA IDE Controller [8086:2828] (rev 03)
        00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus =
Controller [8086:283e] (rev 03)
        02:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 3=
945ABG Network Connection [8086:4222] (rev 02)
        03:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 8=
8E8039 PCI-E Fast Ethernet Controller [11ab:4353] (rev 15)
        04:09.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] =
(rev b4)
        04:09.1 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C552 IEEE 1394 =
Controller [1180:0552] (rev 09)
        04:09.2 SD Host controller [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/=
MS/MSPro Host Adapter [1180:0822] (rev 18)
        04:09.3 System peripheral [0880]: Ricoh Co Ltd R5C843 MMC Host Cont=
roller [1180:0843]
        04:09.4 System peripheral [0880]: Ricoh Co Ltd R5C592 Memory Stick =
Bus Host Adapter [1180:0592] (rev 09)
        04:09.5 System peripheral [0880]: Ricoh Co Ltd xD-Picture Card Cont=
roller [1180:0852] (rev 04)

These are Debian kernel images; I've uploaded their .config files to
<http://robots.org.uk/stuff/kernel-configs/>.

Please CC me in responses as I am not subscribed to lkml. :)

--=20
Sam Morris <sam@robots.org.uk>

--=-PvuPcevSL/15chAQRuTz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH/e47shl/216gEHgRAk8KAKDRkJn4rfd37lw2z8ut1zbm7G+GjgCdFtbN
Tkjnf8he5gMfZHP4oZSGlEU=
=4xHF
-----END PGP SIGNATURE-----

--=-PvuPcevSL/15chAQRuTz--
