Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYJWVbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYJWVbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYJWVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:31:45 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:59098 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYJWVbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:31:44 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2008 17:31:44 EDT
Date: Thu, 23 Oct 2008 22:43:26 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Current suspend issues on Lenovo X200
Message-ID: <20081023204326.GB4175@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.27-next-20081023-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

All recent kernels can suspend the Lenovo X200, but almost none
can awake:

 - 2.6.27-rc9: can suspend once, wakeup: ok
   second suspend: system freeze instead of wakeup
   -> shows parts of the X screen, but does not react on ping
 - 2.6.27: system freeze instead of wakeup
   -> shows parts of the X screen, but does not react on ping
 - 2.6.27-next-20081023:
   -> no X running (because xorg does not work with that kernel)
   -> wakes up
   -> console is blank after suspend
   -> can reboot / shutdown blindly

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkA4e4ACgkQuL75KpiFGIyJdACglo14p0qimleKVHcp6k40CUYj
YSEAnRytBFpWXeN20Giyr8q1H1TODvzx
=cKRG
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
