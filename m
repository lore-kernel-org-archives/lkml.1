Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYHLLTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYHLLTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYHLLTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:19:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48834 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYHLLTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:19:24 -0400
Date: Tue, 12 Aug 2008 21:19:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: Resolved merge conflicts in next-creds
Message-Id: <20080812211904.01f9291d.sfr@canb.auug.org.au>
In-Reply-To: <22136.1218533228@redhat.com>
References: <20080812093624.de7d4ad8.sfr@canb.auug.org.au>
	<alpine.LRH.1.10.0808110950530.3636@tundra.namei.org>
	<20080811101602.09555609.sfr@canb.auug.org.au>
	<20080811153536.02ac0561.sfr@canb.auug.org.au>
	<alpine.LRH.1.10.0808120751001.10017@tundra.namei.org>
	<22136.1218533228@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Aug_2008_21_19_04_+1000_54=UEX/jKXzvs=Zx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Aug_2008_21_19_04_+1000_54=UEX/jKXzvs=Zx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 12 Aug 2008 10:27:08 +0100 David Howells <dhowells@redhat.com> wrot=
e:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > The important thing (and what is different in what I have proposed) is
> > that what you are asking Linus to take here has zero impact (i.e. you j=
ust
> > add a header file that noone uses and whose contents are clearly noops)
> > and then it is very obvious that when people start to use it, the chang=
es
> > really cannot introduce a regression.
>=20
> Actually, you do have to modify XFS too.  It declares current_fsuid(),
> current_fsgid() and struct cred within itself.  The first two just require
> some simple renames, and the third just requires using my struct cred ins=
tead
> when it appears.

One step at a time ... the rename is clearly necessary, but adding
"struct cred" can wait.  We may not be able to get all the conflicts
solved by adding stuff to Linus' tree early.  My aim is just to reduce my
pain level.  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Aug_2008_21_19_04_+1000_54=UEX/jKXzvs=Zx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkihcagACgkQjjKRsyhoI8xIDwCeOvzsB7XahZx9+Um9Lwujg300
YDEAnivvK/U8AZtXjhQR3Nvrved0jqI+
=at/P
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Aug_2008_21_19_04_+1000_54=UEX/jKXzvs=Zx--
