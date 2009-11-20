Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZKTHeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZKTHeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZKTHeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:34:24 -0500
Received: from zbasel.fortytwo.ch ([193.138.215.60]:43116 "EHLO
	zbasel.fortytwo.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZKTHeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:34:23 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 02:34:23 EST
From: Adrian von Bidder <avbidder@fortytwo.ch>
To: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: acerhdf: stilll fighting between kernel and BIOS?
Date: Fri, 20 Nov 2009 08:23:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-1-686; KDE/4.3.2; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2460158.9NKtNMPYko";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200911200823.58897@fortytwo.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2460158.9NKtNMPYko
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Heyho!

With 2.6.31 (as packaged by Debian), kernel and BIOS are still fighting ove=
r=20
who controls the fan on my Acer AOA-150.

If the system is idle, I see repeated=20

Nov 20 08:07:12 laeggerli kernel: [100246.224141] acerhdf: temp 51     =20
Nov 20 08:07:12 laeggerli kernel: [100246.272136] acerhdf: fan OFF     =20
Nov 20 08:07:22 laeggerli kernel: [100256.328145] acerhdf: temp 51     =20
Nov 20 08:07:22 laeggerli kernel: [100256.376072] acerhdf: fan OFF     =20

(and the fan is turned on and off accordingly, using a rather noisy speed=20
for ca. .5s every time.)

As soon as the system gets a bit warmer, fan is running on low speed and th=
e=20
system is much quieter.

ISTR reading that this should have been fixed in 2.6.31, or was that wrong?=
 =20
Did anything change in current kernels or the separate releases of the=20
acerhdf driver?  I might be able to run newer driver releases, or at least =
I=20
can provide more info if desired (and if you're patient to deal with quite=
=20
slow round trip times from my side.  It's not an urgent problem either.)


cheers
=2D- vbi

=2D-=20
featured product: ClamAV Antivirus - http://www.clamav.net/

--nextPart2460158.9NKtNMPYko
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAksGRAdgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6494An0HEvc08B/J49b9zyf3lHFF2
R8wsAJ4zdaidiSSV91LZrIFpeVNSM65WRQ==
=79Dg
-----END PGP SIGNATURE-----

--nextPart2460158.9NKtNMPYko--
