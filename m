Return-Path: <linux-kernel-owner+w=401wt.eu-S1946148AbXBIGiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946148AbXBIGiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 01:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946151AbXBIGiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 01:38:15 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:55626 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946148AbXBIGiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 01:38:14 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Pavel Machek <pavel@ucw.cz>
Subject: [BUG] at drivers/char/vt.c:3332 do_blank_screen() on resume
Date: Fri, 9 Feb 2007 08:38:17 +0200
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2273639.TrpYTcQoch";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702090838.21060.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2273639.TrpYTcQoch
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

With 2.6.20, resuming from disk sometimes cannot returns on vt7 where X run=
s=20
but everything seems working, so just changing to vt1 and returning to vt7=
=20
solves the problem. But dmesg shows some BUG() output like [1] whenever thi=
s=20
problem occurs

I'm using 20070207 snapshot of suspend, s2disk is used to suspend2disk,=20
machine is a Sony Vaio FS-215B which is in the whitelist and works well wit=
h=20
2.6.16/17/18 (all have fbsplash and vesafb-tng patches [from gentoo]=20
applied).

[1] http://cekirdek.pardus.org.tr/~caglar/dmesg.2.6.20

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2273639.TrpYTcQoch
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFzBbcy7E6i0LKo6YRAvrVAKDSmJBykPl9hf975wuhtBglXGCPNACfV6fA
CZPRVSozrYZA+R5OpVh0FUs=
=16mo
-----END PGP SIGNATURE-----

--nextPart2273639.TrpYTcQoch--
