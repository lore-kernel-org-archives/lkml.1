Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYJYCFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYJYCFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 22:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYJYCFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 22:05:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43961 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYJYCFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 22:05:38 -0400
Date: Sat, 25 Oct 2008 13:05:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Message-Id: <20081025130531.ca063206.sfr@canb.auug.org.au>
In-Reply-To: <20081024174838.GA24466@us.ibm.com>
References: <20081024174838.GA24466@us.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__25_Oct_2008_13_05_31_+1100_mrE8gbUqdLCt/Xc/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__25_Oct_2008_13_05_31_+1100_mrE8gbUqdLCt/Xc/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Serge,

On Fri, 24 Oct 2008 12:48:38 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wro=
te:
>
> would you mind applying the patch below behind
> git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/cred-2.6.git#creds=
-v3?
>=20
> Assuming David has no objections?
>=20
> I've just tested with David's plain creds-v3 tree and had no problems.
> (compiled with CONFIG_USER_NS=3Dy|n and CONFIG_KEYS=3Dy|n, boot+ltp with
> both =3Dy)
>=20
> Or would it fit your model better if I found a place to keep a quilt
> patchset or git tree?

Better if you can set up a git tree (or quilt series) somewhere as I
intend to only carry fixup patches myself in linux-next (so far).  Also
that means when you update your patches, I will just fetch them
automatically.

If this stuff depends on David's work, then I need to know that
explicitly so I can do ordering.  If it depends closely (i.e. changes in
Davids tree need to be reflected in yours) then you and David need to
come to some arrangement (maybe David could host your tree as a branch of
his (managing conflicts/updates).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__25_Oct_2008_13_05_31_+1100_mrE8gbUqdLCt/Xc/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkCfusACgkQjjKRsyhoI8yqeQCeLJ3srBifA68QmPMHIyJoe8AY
jK4AnihgYUZHeKAQBmaxhMXHLg09VX8s
=EJOG
-----END PGP SIGNATURE-----

--Signature=_Sat__25_Oct_2008_13_05_31_+1100_mrE8gbUqdLCt/Xc/--
