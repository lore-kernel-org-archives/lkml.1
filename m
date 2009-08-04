Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZHDN55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZHDN55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZHDN54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:57:56 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:44655 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZHDN5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=EhxgNqNakEWaUK7keLt4YvbA2ynq8m3CQ12A0xC10Qw4T/pVHQ3STzzetfL3Cz7cfH
         sRkDFoIJmA1gp3JDvkQ2EZ+WGdlpCpzENKLLRwa5boqbutbMki+e168xAIdPgM/6i6nw
         g+E3KxQnGPSC2h412efIHn7uNnxDw+gf0MW4k=
Message-ID: <4A783E60.7080203@gmail.com>
Date: Tue, 04 Aug 2009 09:57:52 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ghaskins@novell.com, netdev@vger.kernel.org, shemminger@vyatta.com,
       linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [Alacrityvm-devel] [PATCH v2] net: Add vbus_enet driver
References: <20090803171801.17268.93846.stgit@dev.haskins.net>	<20090804010915.17855.2660.stgit@dev.haskins.net> <20090803.193836.248921133.davem@davemloft.net>
In-Reply-To: <20090803.193836.248921133.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig436072B2FA6A57E28D19D323"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig436072B2FA6A57E28D19D323
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

David Miller wrote:
> From: Gregory Haskins <ghaskins@novell.com>
> Date: Mon, 03 Aug 2009 21:14:04 -0400
>=20
>> net: Add vbus_enet driver
>>
>> A virtualized 802.x network device based on the VBUS interface. It can=
 be
>> used with any hypervisor/kernel that supports the virtual-ethernet/vbu=
s
>> protocol.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>=20
> I'm fine with this, it depends upon the vbus infrastructure so
> whoever pulls that in can pull this in as well:
>=20
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks, David.

If there are no other comments/objections, I would propose to pull this
into linux-next.  I have prepared a branch specifically for this
purpose, which can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/alacrityvm/linux-2=
=2E6.git
linux-next

I have also folded the following update to MAINTAINERS into the series:

diff --git a/MAINTAINERS b/MAINTAINERS
index d6befb2..7cbcf5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2707,6 +2707,12 @@ L:       linux-mips@linux-mips.org
 S:     Maintained
 F:     drivers/serial/ioc3_serial.c

+IOQ LIBRARY
+M:     Gregory Haskins <ghaskins@novell.com>
+S:     Maintained
+F:     include/linux/ioq.h
+F:     lib/ioq.c
+
 IP MASQUERADING
 M:     Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
 S:     Maintained
@@ -4555,6 +4561,12 @@ F:       drivers/serial/serial_lh7a40x.c
 F:     drivers/usb/gadget/lh7a40*
 F:     drivers/usb/host/ohci-lh7a40*

+SHM-SIGNAL LIBRARY
+M:     Gregory Haskins <ghaskins@novell.com>
+S:     Maintained
+F:     include/linux/shm_signal.h
+F:     lib/shm_signal.c
+
 SHPC HOTPLUG DRIVER
 M:     Kristen Carlson Accardi <kristen.c.accardi@intel.com>
 L:     linux-pci@vger.kernel.org
@@ -5423,6 +5435,19 @@ S:       Maintained
 F:     Documentation/fb/uvesafb.txt
 F:     drivers/video/uvesafb.*

+VBUS
+M:     Gregory Haskins <ghaskins@novell.com>
+S:     Maintained
+F:     include/linux/vbus*
+F:     drivers/vbus/*
+
+VBUS ETHERNET DRIVER
+M:     Gregory Haskins <ghaskins@novell.com>
+S:     Maintained
+W:     http://developer.novell.com/wiki/index.php/AlacrityVM
+F:     include/linux/venet.h
+F:     drivers/net/vbus-enet.c
+
 VFAT/FAT/MSDOS FILESYSTEM
 M:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
 S:     Maintained




--------------enig436072B2FA6A57E28D19D323
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkp4PmAACgkQP5K2CMvXmqFoIACdHaulCPWHEg+xBi4n9uMFk6RG
cTYAn1Bcf1JoHEYrc13nb23igw99tXZq
=hVV/
-----END PGP SIGNATURE-----

--------------enig436072B2FA6A57E28D19D323--
