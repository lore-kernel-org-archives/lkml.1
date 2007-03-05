Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXCELVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXCELVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXCELVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:21:49 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:50810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXCELVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:21:48 -0500
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
In-Reply-To: <20070305011729.GB7681@kroah.com>
References: <20070304220857.GH23311@waste.org>
	 <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org>
	 <20070305011729.GB7681@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WaY/ydGDzBbpcLWjiA3+"
Date: Mon, 05 Mar 2007 12:20:51 +0100
Message-Id: <1173093651.6131.47.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WaY/ydGDzBbpcLWjiA3+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-03-04 at 17:17 -0800, Greg KH wrote:

> > > This is due to the recent sysfs restructuring I think. IIRC the fix i=
s
> > > to upgrade hal to a current git version.
> >=20
> > If that's the cause, the fix is to back out whatever was done to break
> > userspace. Breaking userspace is not ok. Upgrading from 2.6.x to
> > 2.6.x+1 should not entail replacing substantial parts of userspace,
> > especially with NOT-EVEN-FRAKKING-RELEASED-YET CODE.=20
>=20
> I should not have broken any userspace if CONFIG_SYSFS_DEPRECATED is
> enabled with that patch.  If that is enabled, and that patch still
> causes problems, please let me know.

Yeah, sorry for not mentioning that in my original email and the
discussion it stirred.

johannes

--=-WaY/ydGDzBbpcLWjiA3+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6/0T/ETPhpq3jKURAiozAJsGdNBKnO4F5KILsz5xkFeI1guIhQCgu4Ab
ZLbtATQiHXpB5fnsD/JwaV8=
=93wK
-----END PGP SIGNATURE-----

--=-WaY/ydGDzBbpcLWjiA3+--

