Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbXFRWP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbXFRWP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762579AbXFRWPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:15:18 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:42569 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761485AbXFRWPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:15:17 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Date: Tue, 19 Jun 2007 08:15:13 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Uli Luckas <u.luckas@road.de>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200706182329.58917.rjw@sisk.pl>
In-Reply-To: <200706182329.58917.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1281076.UZUROANAlK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706190815.18292.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1281076.UZUROANAlK
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Tuesday 19 June 2007 07:29:58 Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> At present, if a user mode helper is running while=20
usermodehelper_pm_callback()
> is executed, the helper may be frozen and the completion in
> call_usermodehelper_exec() won't be completed until user space processes =
are
> thawed.  As a result, the freezing of kernel threads may fail, which is n=
ot
> desirable.
>=20
> Prevent this from happening by introducing a counter of running user mode
> helpers and allowing usermodehelper_pm_callback() to succeed for
> action =3D PM_HIBERNATION_PREPARE or action =3D PM_SUSPEND_PREPARE only i=
f there
> are no helpers running.  [Namely, usermodehelper_pm_callback() waits for =
at=20
most
> RUNNING_HELPERS_TIMEOUT for the number of running helpers to become zero =
and
> fails if that doesn't happen.]
>=20
> Special thanks to Uli Luckas <u.luckas@road.de> for reviewing the previous
> versions of this patch and for very useful comments.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>

Regards,

Nigel

--nextPart1281076.UZUROANAlK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGdwP2N0y+n1M3mo0RArmbAKDepNuT82mHy+8n6DEGlEDn6xY1UQCgy8bX
wl+3pKR8e1Q9jrB16K/8bkk=
=/xR+
-----END PGP SIGNATURE-----

--nextPart1281076.UZUROANAlK--
