Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYKCPko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYKCPko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYKCPkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:40:36 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:54655 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYKCPkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:40:35 -0500
Date: Mon, 3 Nov 2008 16:39:45 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc3(-next20081103) suspend issues on Lenovo X200
Message-ID: <20081103153945.GA20618@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Updating my last post, system now runs with
the new Debian xserver-xorg-intel package:

2.6.28-rc3 and 2.6.28-rc3-next-20081103: acpi_sleep=3Ds3_bios
   - suspend on console works
   - wakeup on console works
   - xorg (intel 2.3.2-2+lenny5) works
   - suspend on xorg works
   - wakeup on xorg is BROKEN:
      - console (kernel messages) is seen for a few seconds
      - kernel switches back to X
      - screen is partly drawn: X cursor is shown, background, no windows
      - system hard reboots after about 20 seconds (watchdog?)

The Debian packages includes the lates G45 bugfix:

http://packages.debian.org/changelogs/pool/main/x/xserver-xorg-video-intel/=
xserver-xorg-video-intel_2.3.2-2+lenny5/changelog

So I'm waiting for your input on where to update what next ;-)

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkPG0EACgkQuL75KpiFGIwWHACfdaw83DOMQNN4j9re8Q8bTc7k
k6EAmwWzfs/1+PCPXmViPmIULolKkeB6
=DgId
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
