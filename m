Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZHXXoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZHXXoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZHXXo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:44:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50788 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbZHXXo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:44:29 -0400
Date: Tue, 25 Aug 2009 09:44:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dick Streefland <dick@streefland.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: manual merge of the kconfig tree with the kbuild
 tree
Message-Id: <20090825094427.b91e3329.sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.00.0908241052420.7587@gandalf.stny.rr.com>
References: <20090824113226.b61cccc6.sfr@canb.auug.org.au>
	<20090824083433.GA6147@streefland.net>
	<alpine.DEB.2.00.0908241052420.7587@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Aug_2009_09_44_27_+1000_fzWFKe3CKf_X9Wi6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Aug_2009_09_44_27_+1000_fzWFKe3CKf_X9Wi6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 24 Aug 2009 10:54:04 -0400 (EDT) Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Mon, 24 Aug 2009, Dick Streefland wrote:
>=20
> > My simplified script that you merged from the kbuild tree will also
> > extract config information from ELF files. So both patches from the
> > kconfig tree are not needed anymore.
>=20
> OK what is the proper way to resolve this, before sending anything off to=
=20
> Linus?  Should I pull in Dick's tree and resolve the conficts myself, and=
=20
> let you repull? Or is something else recommended?

You could cherry-pick Dick's commit into your tree (and remove your
conflicting commits by rebasing). Or you could rebase your work on top of
Sam's kbuild tree (or merge Sam's tree) (but that would require Sam to
guarantee that his tree won't be rebased). Or you could do the rebase and
then just submit your tree to Sam for inclusion (instead of, or as well
as, it being included in linux-next directly).  Or you could keep going
the way you are and resolve the conflict once one of the trees has been
merged into Linus' tree.

For the moment, I can keep resolving the conflict.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Aug_2009_09_44_27_+1000_fzWFKe3CKf_X9Wi6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqTJdwACgkQjjKRsyhoI8xD/gCePpkT7v1MURMUty1YQ1IMZBoW
X+8AoIxOdshKjZcZyPDr21lk4cJ5mORF
=zjsR
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Aug_2009_09_44_27_+1000_fzWFKe3CKf_X9Wi6--
