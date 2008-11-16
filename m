Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYKPMvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYKPMvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYKPMu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:50:56 -0500
Received: from mx34.mail.ru ([194.67.23.200]:3862 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbYKPMuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:50:55 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] ACPI toshiba: only register rfkill if bt is enabled
Date: Sun, 16 Nov 2008 15:50:43 +0300
User-Agent: KMail/1.9.10
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       philipl@overt.org
References: <20081029081934.GB26314@gambetta> <200811161129.02028.arvidjaar@mail.ru> <200811161340.36798.rjw@sisk.pl>
In-Reply-To: <200811161340.36798.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1464691.HkxFBc6c8y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811161550.49957.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1464691.HkxFBc6c8y
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 16 November 2008, Rafael J. Wysocki wrote:
> On Sunday, 16 of November 2008, Andrey Borzenkov wrote:
> > On Wednesday 29 October 2008, Frederik Deweerdt wrote:
> > > [resending as it didn't make it to the list, removing netdev from cc
> > > also]
> > > Hello  Andrey,
> > >=20
> > > It looks like a part of the rfkill initialization was done whenever
> > > BT was on or not. The following patch checks for BT presence before
> > > registering the rfkill to the input layer. Does it solve the problem =
for
> > > you?
> > >=20
> >=20
> > This patch fixes regression in 2.6.28. Patch has been tested and
> > acnowledged. Rafael, could you add it to list of open regressions?
> > Thank you!
>=20
> I will, if you provide me with a link to the patch and (optionally) to the
> original bug report.
>=20

Original bug report:
http://marc.info/?l=3Dlinux-kernel&m=3D122522113619025&w=3D2

Patch:
http://marc.info/?l=3Dlinux-kernel&m=3D122526843117478&w=3D2

Thank you!

--nextPart1464691.HkxFBc6c8y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkgFyUACgkQR6LMutpd94zw3QCfU8WuBw5wwiIQ3zVOF61F617b
15kAoKkh0zAQOmxeUKkHJ/+ZCnUx1edV
=v4jb
-----END PGP SIGNATURE-----

--nextPart1464691.HkxFBc6c8y--
