Return-Path: <linux-kernel-owner+w=401wt.eu-S934697AbZHEQeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697AbZHEQeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934641AbZHEQeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:34:07 -0400
Received: from mx.ugf.br ([200.222.48.3]:41150 "EHLO mx.ugf.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934638AbZHEQeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:34:06 -0400
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer
 check
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org,
       mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com
In-Reply-To: <20090805151750.GA16080@infradead.org>
References: <1249329808.7686.26.camel@logos>
	 <20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>
	 <4A786110.8090404@sandeen.net> <1249411898.7576.19.camel@logos>
	 <20090805151750.GA16080@infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xqidu5ctlIFo7+IpVFyG"
Date: Wed, 05 Aug 2009 13:34:02 -0300
Message-Id: <1249490042.7725.16.camel@logos>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xqidu5ctlIFo7+IpVFyG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 11:17 -0400, Christoph Hellwig wrote:
> On Tue, Aug 04, 2009 at 03:51:38PM -0300, Ramon de Carvalho Valle wrote:
> > The xfs_iformat function does not check if the realtime device target p=
ointer
> > is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
> > structure.
>=20
> Same as Eric I don't think there's much of a point renumbering the error
> cases.  Instead I'll do another patch with a couple of cleanups in this
> function replacing all the numbers with short alphabetic tags.

Great. Thanks.

>=20
> I don't really see the point of printing the flags either, if we have
> this bit flipped it's pretty clear that we had random corruption of this
> dinode.
>=20

Printing the flags is just for debugging purposes and it keeps the code
consistent with the other calls to xfs_fs_repair_cmn_err.

-Ramon

--=-xqidu5ctlIFo7+IpVFyG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp5tHcACgkQGIS0iEuhp4O3PQCeP/9dDXY3tVUkWpuijgipepol
B5UAoJ7U1BRRR/vDmVy/0RUO8n7YItMF
=g7j/
-----END PGP SIGNATURE-----

--=-xqidu5ctlIFo7+IpVFyG--

