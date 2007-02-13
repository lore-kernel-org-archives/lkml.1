Return-Path: <linux-kernel-owner+w=401wt.eu-S1750844AbXBMTnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750844AbXBMTnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXBMTnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:43:42 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:41490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXBMTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:43:41 -0500
Subject: Re: [PATCH v2] kernel-doc: include struct short description in
	title output
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
In-Reply-To: <20070213113522.8490ddaf.randy.dunlap@oracle.com>
References: <20070213111042.e10a4234.randy.dunlap@oracle.com>
	 <1171394317.10344.111.camel@johannes.berg>
	 <20070213113522.8490ddaf.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hfsNqmr51AFvSmVUVeyE"
Date: Tue, 13 Feb 2007 20:43:38 +0100
Message-Id: <1171395818.10344.126.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hfsNqmr51AFvSmVUVeyE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-13 at 11:35 -0800, Randy Dunlap wrote:
> > Yup, that fixes it for structs. I guess I forgot to mention this earlie=
r
> > because I didn't notice it until now... the same bug exists for
> > functions as well.
>=20
> updated patch.  Thanks.

Thanks, works great.

> ---
>=20
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Output of a function or struct in html mode needs to include the short
> description from the function/struct name line in the output title line.
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

So if anyone cares:

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  scripts/kernel-doc |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> --- linux-2.6.20-git7.orig/scripts/kernel-doc
> +++ linux-2.6.20-git7/scripts/kernel-doc
> @@ -452,7 +452,7 @@ sub output_struct_html(%) {
>      my %args =3D %{$_[0]};
>      my ($parameter);
> =20
> -    print "<h2>".$args{'type'}." ".$args{'struct'}."</h2>\n";
> +    print "<h2>".$args{'type'}." ".$args{'struct'}. " - " .$args{'purpos=
e'}."</h2>\n";
>      print "<b>".$args{'type'}." ".$args{'struct'}."</b> {<br>\n";
>      foreach $parameter (@{$args{'parameterlist'}}) {
>  	if ($parameter =3D~ /^#/) {
> @@ -498,8 +498,8 @@ sub output_function_html(%) {
>      my %args =3D %{$_[0]};
>      my ($parameter, $section);
>      my $count;
> -    print "<h2>Function</h2>\n";
> =20
> +    print "<h2>" .$args{'function'}." - ".$args{'purpose'}."</h2>\n";
>      print "<i>".$args{'functiontype'}."</i>\n";
>      print "<b>".$args{'function'}."</b>\n";
>      print "(";
>=20

--=-hfsNqmr51AFvSmVUVeyE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0hTq/ETPhpq3jKURAk1gAKCngowPJ2hpTqU3ZMKSURpSFsZKdQCePpyC
9zekxLUAZ0iBMYtnVmRo3ro=
=ZMbd
-----END PGP SIGNATURE-----

--=-hfsNqmr51AFvSmVUVeyE--

