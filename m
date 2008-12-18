Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752625AbYLRTB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYLRTB3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYLRTBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:01:18 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:48848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYLRTBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:01:17 -0500
Subject: Re: [PATCH] documentation: how to use DOC: section blocks
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
In-Reply-To: <20081218105709.a9733304.randy.dunlap@oracle.com>
References: <20081218105709.a9733304.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GwsbUAiQtP5NEwxXtH9D"
Date: Thu, 18 Dec 2008 20:01:15 +0100
Message-Id: <1229626875.3601.34.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GwsbUAiQtP5NEwxXtH9D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 10:57 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Add info on how to use DOC: sections in kernel-doc.
> DOC: sections enable the addition of inline source file comments
> that are general in nature instead of being specific to a
> function, struct, union, enum, or typedef.

Nice, thanks for the documentation Randy, looks great to me.

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Johannes Berg <johannes@sipsolutions.net>
> ---
>  Documentation/kernel-doc-nano-HOWTO.txt |   29 +++++++++++++++++++++++++=
++++
>  1 file changed, 29 insertions(+)
>=20
> --- linux-next-20081218.orig/Documentation/kernel-doc-nano-HOWTO.txt
> +++ linux-next-20081218/Documentation/kernel-doc-nano-HOWTO.txt
> @@ -282,6 +282,32 @@ struct my_struct {
>  };
> =20
>=20
> +Including documentation blocks in source files
> +----------------------------------------------
> +
> +To facilitate having source code and comments close together, you can
> +include kernel-doc documentation blocks that are free-form comments
> +instead of being kernel-doc for functions, structures, unions,
> +enums, or typedefs.  This could be used for something like a
> +theory of operation for a driver or library code, for example.
> +
> +This is done by using a DOC: section keyword with a section title.  E.g.=
:
> +
> +/**
> + * DOC: Theory of Operation
> + *
> + * The whizbang foobar is a dilly of a gizmo.  It can do whatever you
> + * want it to do, at any time.  It reads your mind.  Here's how it works=
.
> + *
> + * foo bar splat
> + *
> + * The only drawback to this gizmo is that is can sometimes damage
> + * hardware, software, or its subject(s).
> + */
> +
> +DOC: sections are used in SGML templates files as indicated below.
> +
> +
>  How to make new SGML template files
>  -----------------------------------
> =20
> @@ -302,6 +328,9 @@ exported using EXPORT_SYMBOL.
>  !F<filename> <function [functions...]> is replaced by the
>  documentation, in <filename>, for the functions listed.
> =20
> +!P<filename> <section title> is replaced by the contents of the DOC:
> +section titled <section title> from <filename>.
> +Spaces are allowed in <section title>; do not quote the <section title>.
> =20
>  Tim.
>  */ <twaugh@redhat.com>
>=20

--=-GwsbUAiQtP5NEwxXtH9D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSp33AAoJEKVg1VMiehFYBUsP/iavj7ELZRHUUz2PpBMCr4jD
Rk5vWfX1BaID/D705rYpsu6K7W/hf5QJHliTl+IxHcX1oElVG+SuIj72Mql5Lfw2
2zhdFKHyI4Y0pZ4dbKU6TrMzkrj1UBrXUuaBYeQO5vc+SWtF8rYEw2xH05GAnchx
71CQksNhIwO1bgoMM7dPRyN6ltfVT2qNWANYphl5Uje+bOPmveUmbV2PiMQWRJRU
9ortWVPeZE+yXNjB+fihBnTvLDp4cAerNj8Qn2aADjGHp7wwGrjHRHuHypMtZ3v1
CBHCUYBxSFeDNPlU5u7AiszJ4jUjykMw2zy/863c7oKLJxuA/k9FpTEmOgRwxnl1
tSc6AkOODSlejf5fXd22JxBvuqDTErCnXutD2+HY9CCRzoLbLr4/1ufVj5evFxYl
zpRCoz2xaLi7EeSwnQldz8o9cmTJjs70HAypPZHUMEdtED7wtSs0Lm/6jugvzCdR
kxpf2q9qcrj3YfqJvRp84r7fMsmxjHZAdGUweEQfDrY40O3CAqHGC8/03pOAaiAx
pXRFqNic1uE8jqFS0XQq7nDbICBj7g9bNLOonsfh09qfTjegijQ5k0ZWzWeZ/r0x
yH7mDP6VvfadvP61b0vLrmkaTAcgAuQTt2ZmYZZpYm5G1ghq9td5j7JRFz23netU
1kLQgHYIoGc2FwIKnCFq
=OgQU
-----END PGP SIGNATURE-----

--=-GwsbUAiQtP5NEwxXtH9D--

