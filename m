Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYDNA2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYDNA2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYDNA2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:28:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51081 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbYDNA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:28:43 -0400
X-Sasl-enc: c30zwca3VZgEmXM0xKSaCI+6k/cXX050ZCvdKVDPqkMI 1208132922
Message-ID: <4802A538.9040107@imap.cc>
Date: Mon, 14 Apr 2008 02:28:40 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.25-rc8-mm1: Intel SATA boot failure
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>	<47F56363.4090002@imap.cc> <20080403161733.c05dac53.akpm@linux-foundation.org>
In-Reply-To: <20080403161733.c05dac53.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD0D290390308BF7439E8D25D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD0D290390308BF7439E8D25D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Final report, seeing -mm2 is out:

- Netconsole works. (grumblestupidsusefirewallgrumble)

- The hang during boot only happens with kernels compiled with
  CONFIG_CIFS_EXPERIMENTAL=3Dy
  It also doesn't always happen at the same point in the boot sequence.
  I'm suspecting it might be triggered by some network packet.
  Anyway, it's obviously *not* a SATA problem.
  (That was just me jumping to conclusions, because ...)

- That leaves only the messages

  ata1: port is slow to respond, please be patient (Status 0x80)
  ata1: COMRESET failed (errno=3D-16)

  and accompanying delays during boot, for each installed SATA disk.
  I'll try to find the time to retest this with 2.6.25-rc8-mm2.

Thanks,
Tilman

--=20
Tilman Schmidt                                  E-Mail: tilman@imap.cc
Wehrhausweg 66                                  Fax: +49 228 4299019
53227 Bonn, Germany


--------------enigD0D290390308BF7439E8D25D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIAqU4MdB4Whm86/kRAkuQAJ996P0box0gl+95xNfjWurYzUUimQCZAZIk
edjS6UJ0YthQHL1YMZRIO5I=
=gjNn
-----END PGP SIGNATURE-----

--------------enigD0D290390308BF7439E8D25D--
