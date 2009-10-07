Return-Path: <linux-kernel-owner+w=401wt.eu-S934325AbZJGSUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbZJGSUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZJGSUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:20:08 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45829 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZJGSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=fdtQcqmXMDl3d54OnK8oIT/PKSqtzMi4bE8OEpwAT81JenAsNI5r9yr1N5gb71uS+i
         PEGzeIhZNoiDz2EY+A8o+uiMmIGCeXN5tjLVq9MFYabR9vLpVUvdetiAkbjbNwdIJNux
         Uv4tSCBAuVg20eb0KrgZMbRry36ixJxivZCwU=
Message-ID: <4ACCDBAC.8040608@gmail.com>
Date: Wed, 07 Oct 2009 14:19:24 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Gregory Haskins <ghaskins@novell.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] vbus: proxy uses, select IOQ
References: <20091007173517.abfcfa2a.sfr@canb.auug.org.au> <20091007102259.ae014b15.randy.dunlap@oracle.com>
In-Reply-To: <20091007102259.ae014b15.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3497D467835B74A75CDDBDE3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3497D467835B74A75CDDBDE3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> vbus-proxy also uses ioq, so it should select IOQ.
>=20
> When CONFIG_VBUS_PROXY=3D[ym] and VBUS_PCIBRIDGE=3Dn:
>=20
> ERROR: "ioq_init" [drivers/vbus/vbus-proxy.ko] undefined!
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Gregory Haskins <ghaskins@novell.com>

Thanks Randy, applied.

Kind Regards,
-Greg


--------------enig3497D467835B74A75CDDBDE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrM26wACgkQP5K2CMvXmqFj2ACfWWEP31tPkL1FQBg1Iie0MseW
+0oAniLB+DSGr7Oz1fULtSsExrenDKUk
=3MnT
-----END PGP SIGNATURE-----

--------------enig3497D467835B74A75CDDBDE3--
