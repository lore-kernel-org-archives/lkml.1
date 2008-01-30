Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbYA3Tsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbYA3Tsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYA3Tse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:48:34 -0500
Received: from main.gmane.org ([80.91.229.2]:58375 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYA3Tsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:48:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>
Subject: [BUG?] GDTH driver not working after upgrade to 2.6.24
Date: Wed, 30 Jan 2008 20:47:34 +0100
Message-ID: <fnqka6$l46$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6A01A40DF1C3A97B29F162BD"
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dslb-084-061-143-009.pools.arcor-ip.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
X-Enigmail-Version: 0.95.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6A01A40DF1C3A97B29F162BD
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

so i have upgraded a system to kernel 2.6.24. After that, it failed to=20
boot with the usual message telling, that the rootfs on device /dev/sda1 =

  cannot be mounted (a raid1 run by the controller below).

With 2.6.23.12, everything is working fine.

# lspci -v:

03:01.0 RAID bus controller: Intel Corporation RAID Controller
         Subsystem: Intel Corporation Unknown device 01db
         Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 17
         Memory at ddffc000 (32-bit, prefetchable) [size=3D16K]
         [virtual] Expansion ROM at deef0000 [disabled] [size=3D32K]
         Capabilities: [80] Power Management version 2

# GDT-related dmesg output (2.6.23.12):

GDT-HA: Storage RAID Controller Driver. Version: 3.05
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 24 (level, low) -> IRQ 17
GDT-HA: Found 1 PCI Storage RAID Controllers
Configuring GDT-PCI HA at 3/1 IRQ 17
GDT-HA 0: Name: SRCU42L
scsi0 : SRCU42L
scsi 0:0:0:0: Direct-Access     Intel    Host Drive  #00       PQ: 0 ANSI=
: 2
scsi 0:2:6:0: Processor         ESG-SHV  SCA HSBP M29     1.06 PQ: 0 ANSI=
: 2
sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
sd 0:0:0:0: [sda] Assuming Write Enabled
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
sd 0:0:0:0: [sda] Assuming Write Enabled
sd 0:0:0:0: [sda] Assuming drive cache: write through
  sda: sda1 sda2 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk

# cat /boot/config-2.6.24 |grep GDT

CONFIG_SCSI_GDTH=3Dy




Any ideas?

http://www.kernel.org/diff/diffview.cgi?file=3D%2Fpub%2Flinux%2Fkernel%2F=
v2.6%2Fpatch-2.6.24.bz2=20
show huge drivers/scsi/gdth* related changes.

Can't test at the moment. System went production.


Regards,
   Sven


--------------enig6A01A40DF1C3A97B29F162BD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHoNRW7Ww7FjRBE4ARAtofAKCAza4ps1dUfI6f2id78O1mxGQdfgCgqXeJ
D7P5E7+EOiYXZ+jBNAUa+S8=
=NT5k
-----END PGP SIGNATURE-----

--------------enig6A01A40DF1C3A97B29F162BD--

