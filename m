Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYHKAQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYHKAQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYHKAQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:16:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51117 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYHKAQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:16:15 -0400
Date: Mon, 11 Aug 2008 10:16:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: Resolved merge conflicts in next-creds
Message-Id: <20080811101602.09555609.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org>
References: <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Aug_2008_10_16_02_+1000_kHu4xOUMxHKK0W6m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Aug_2008_10_16_02_+1000_kHu4xOUMxHKK0W6m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 11 Aug 2008 09:57:44 +1000 (EST) James Morris <jmorris@namei.org> w=
rote:
>
> I manually resolved the following conflicts in
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.=
6#next-creds
>=20
> when merging with latest Linus.  (This branch holds the creds API changes
> from David Howells and is being pulled into linux-next).

Thanks for that.

> The CIFS conflicts were collisions with API changes.  I'm not sure how=20
> best to extract this information from git.  'git-rerere' doesn't seem to=
=20
> do anythig, even with:
>=20
> $ git-config --list
> rerere.enabled=3D1

"git rerere" works behind the scenes to fix up merge conflicts that you
have fixed once before.  All it does is record the diff of conflicted
files after the merge fails and then the new versions of those files when
you do the next commit.  I know of no way to get any useful information
out of it.

The git show below should, however, be sufficient and looks just like
what I did on Friday.

I have a plan for getting rid of these - I will start on it today or
tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Aug_2008_10_16_02_+1000_kHu4xOUMxHKK0W6m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkifhMIACgkQjjKRsyhoI8y/0ACgtUXjXg9F8nPKacUNGTwRtbKH
N/0AnRwN2Gh7bkfAUN4k7XC5dcYsoFuo
=UDmi
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Aug_2008_10_16_02_+1000_kHu4xOUMxHKK0W6m--
