Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbYHEARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbYHEARS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbYHEARE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:17:04 -0400
Received: from ozlabs.org ([203.10.76.45]:60658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324AbYHEARD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:17:03 -0400
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux,
	post-2.6.27-rc1
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Paul Collins <paul@burly.ondioline.org>, Neil Brown <neilb@suse.de>,
       linuxppc-dev@ozlabs.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080804205908.GA29890@fieldses.org>
References: <20080802184554.GB715@fieldses.org>
	 <87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	 <877iayy4qc.fsf@burly.wgtn.ondioline.org>
	 <18581.40960.737792.454035@notabene.brown>
	 <87r696l1yo.fsf@burly.wgtn.ondioline.org>
	 <18582.32935.501672.689845@notabene.brown>
	 <87fxpll5zq.fsf@burly.wgtn.ondioline.org>
	 <87y73dcd60.fsf@burly.wgtn.ondioline.org>
	 <1217860597.12535.2.camel@localhost>
	 <87hca05ws4.fsf@burly.wgtn.ondioline.org>
	 <20080804205908.GA29890@fieldses.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+ixDnOjyyG3o7gE++zF7"
Date: Tue, 05 Aug 2008 10:16:58 +1000
Message-Id: <1217895418.7951.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+ixDnOjyyG3o7gE++zF7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 16:59 -0400, J. Bruce Fields wrote:
> On Tue, Aug 05, 2008 at 08:51:23AM +1200, Paul Collins wrote:
> > Michael Ellerman <michael@ellerman.id.au> writes:
> >=20
> > > On Mon, 2008-08-04 at 22:00 +1200, Paul Collins wrote:
> > >> Paul Collins <paul@burly.ondioline.org> writes:
> > >>=20
> > >> > Neil Brown <neilb@suse.de> writes:
> > >> >> Could you try removing the 'static' declaration for nfsd_acceptab=
le
> > >> >> and recompile?
> > >> >> Or maybe try a different compiler?
> > >> >
> > >> > I will give these a try this evening.
> > >>=20
> > >> I built myself a nice new cross compiler:
> > >>=20
> > >>         powerpc-linux-gnu-gcc-4.1 (GCC) 4.1.3 20080623 (prerelease) =
(Debian 4.1.2-23)
> > >>=20
> > >> and rebuilt 94ad374a0751f40d25e22e036c37f7263569d24c.  Running that =
on
> > >> the server and 2.6.26 on the client, I got yet another Oops.  This o=
ne
> > >> locked the machine up pretty good, so all I have is a picture:
> > >>=20
> > >> http://ondioline.org/~paul/DSCN1608.JPG
> > >
> > > Wow.
> > >
> > > Can you try building a kernel on the server? ie. not over NFS.
> >=20
> > Built kernels on the server with native gcc 4.2.4 and 4.3.1 and repeate=
d
> > the build test.
> =20
> But the build test itself was over nfs?  (And you can't reproduce the
> same problem without nfs?)

Yeah, I'm not clear on that either. What I was aiming at was can you get
it to oops somewhere else by not building over NFS - in which case we
can rule NFS (more or less) out.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-+ixDnOjyyG3o7gE++zF7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIl5v6dSjSd0sB4dIRAsjlAJ9tZtOzK3BT9Wz6eGJ3yhIjzsOTSACcCX94
yVsiEvvlHItT46eesIKSGTg=
=iU3B
-----END PGP SIGNATURE-----

--=-+ixDnOjyyG3o7gE++zF7--

