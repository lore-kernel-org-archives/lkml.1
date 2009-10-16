Return-Path: <linux-kernel-owner+w=401wt.eu-S935638AbZJPAwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638AbZJPAwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbZJPAwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:52:43 -0400
Received: from ozlabs.org ([203.10.76.45]:39707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZJPAwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:52:42 -0400
Subject: Re: [PATCH 5/5 v2] kernel handling of CPU DLPAR
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AD74261.9040504@austin.ibm.com>
References: <4AB39FB3.1020608@austin.ibm.com>
	 <4AB3A172.4090601@austin.ibm.com>  <4AD4C3A3.5050103@austin.ibm.com>
	 <1255473054.21871.39.camel@concordia>  <4AD74261.9040504@austin.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LiCUG5fWpGldCZ7cbDZY"
Date: Fri, 16 Oct 2009 11:52:04 +1100
Message-Id: <1255654324.5626.53.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LiCUG5fWpGldCZ7cbDZY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-15 at 10:40 -0500, Nathan Fontenot wrote:
> Michael Ellerman wrote:
> > On Tue, 2009-10-13 at 13:14 -0500, Nathan Fontenot wrote:
> >> This adds the capability to DLPAR add and remove CPUs from the kernel.=
 The
> >> creates two new files /sys/devices/system/cpu/probe and
> >> /sys/devices/system/cpu/release to handle the DLPAR addition and remov=
al of
> >> CPUs respectively.
> >=20
> > How does this relate to the existing cpu hotplug mechanism? Or is this
> > making the cpu exist (possible), vs marking it as online?
>=20
> This update makes the cpu exist, it does not mark the cpu online.
>=20
> >=20
> > Is some other platform going to want to do the same? ie. should the
> > probe/release part be in generic code?
>=20
> I thought about making this generic code, perhaps a follow-on patch to mo=
ve
> the creation of the probe/release files to generic code to see what the
> community thinks.  I would assume there would still need to be a arch and=
/or
> platforms specific callout to do the real work.

I'm not so worried about the code being generic, there's not much that
would be generic. More the mechanism. We don't want to add probe/release
to powerpc, and then have a different mechanism get added later by some
other platform, or generically.

But I guess you CC'ed lkml and there's not much more to do, I don't know
specifically who'd care about it.

cheers


--=-LiCUG5fWpGldCZ7cbDZY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrXw7QACgkQdSjSd0sB4dLuBQCfcDS+jmkHlLnWg2pgCNz6nFOB
2KoAmgPG7D5Rl2pPRvPTaafaJJssS3Di
=1D4M
-----END PGP SIGNATURE-----

--=-LiCUG5fWpGldCZ7cbDZY--

