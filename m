Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZJNGjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZJNGjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZJNGjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:39:08 -0400
Received: from k66.ru ([87.224.128.21]:60444 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZJNGjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:39:07 -0400
Date: Wed, 14 Oct 2009 12:38:24 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: drivers/staging/rt2860 doesn't compile
Message-ID: <20091014063824.GD6298@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sk6NRVTC9kZ6Mrgo"
Content-Disposition: inline
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-06-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sk6NRVTC9kZ6Mrgo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

drivers/staging/rt2860/common/cmm_info.c: In function
'RTMPIoctlGetSiteSurvey':                                                  =
          =20
drivers/staging/rt2860/common/cmm_info.c:1817: error: 'TASK_INTERRUPTIBLE'
undeclared (first use in this function)                         =20
drivers/staging/rt2860/common/cmm_info.c:1817: error: (Each undeclared
identifier is reported only once                                    =20
drivers/staging/rt2860/common/cmm_info.c:1817: error: for each function it
appears in.)                                                    =20
drivers/staging/rt2860/common/cmm_info.c:1817: error: implicit declaration
of function 'signal_pending'                                    =20
drivers/staging/rt2860/common/cmm_info.c:1817: error: implicit declaration
of function 'schedule_timeout'    =20

drivers/staging/rt2860/rt_linux.h doesn't include <linux/sched.h>. It
includes <linux/interrupt.h>, which included <linux/sched.h> until
d43c36dc6b357fa1806800f18aa30123c747a6d1

--=20
WBR, wRAR (ALT Linux Team)

--sk6NRVTC9kZ6Mrgo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJK1XHfAAoJEOih81koZvPBsvsH/A/F6kxguzVLA18A/vDunFOY
ZipMyHSrnZq4tPxVeKHAAqGRzHuCNuNXH36tqxUWrBnRr65qIbo+87HnLk4n91VY
Chzq60Hc/88jRtgnnE7Ji/iOe+nuJUYXUD3bEg/Q9ckxFZhbsI42WsW1DWy2YyNI
IumF8JFkfOmhE1CEcMtTjRPQzKPtZ0st6JZ008GAyN0eSsp1wnJ2PicH0RM4+UdV
Xqr9N6KC9UCjg8v3sENqNMjlMWBXOrvrza79uRnbyU/lKIZLC23AKqY0Hjq+Z0ZW
SuQxFneLsCdsUHh8CIrozPZ7LSmQ7xKiGFHNW2zUfmSeNrh7ZcHnbpt+mFTxClI=
=sPae
-----END PGP SIGNATURE-----

--sk6NRVTC9kZ6Mrgo--
