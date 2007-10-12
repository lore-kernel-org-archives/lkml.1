Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbXJLO6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbXJLO6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbXJLO6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:58:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:27491 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753676AbXJLO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:58:29 -0400
Subject: Re: [PATCH] mm: avoid dirtying shared mappings on mlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Suleiman Souhlal <ssouhlal@freebsd.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
In-Reply-To: <20071012075317.591212ef@laptopd505.fenrus.org>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
	 <200710120257.05960.nickpiggin@yahoo.com.au>
	 <1192185439.27435.19.camel@twins>
	 <200710120414.11026.nickpiggin@yahoo.com.au>
	 <1192186222.27435.22.camel@twins>
	 <20071012075317.591212ef@laptopd505.fenrus.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qOF/8GImROPovAgsxKc6"
Date: Fri, 12 Oct 2007 16:58:25 +0200
Message-Id: <1192201105.27435.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qOF/8GImROPovAgsxKc6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-12 at 07:53 -0700, Arjan van de Ven wrote:
> On Fri, 12 Oct 2007 12:50:22 +0200
> > > > The pages will still be read-only due to dirty tracking, so the
> > > > first write will still do page_mkwrite().
> > >=20
> > > Which can SIGBUS, no?
> >=20
> > Sure, but that is no different than any other mmap'ed write. I'm not
> > seeing how an mlocked region is special here.
> >=20
> > I agree it would be nice if mmap'ed writes would have better error
> > reporting than SIGBUS, but such is life.
>=20
> well... there's another consideration
> people use mlock() in cases where they don't want to go to the
> filesystem for paging and stuff as well (think the various iscsi
> daemons and other things that get in trouble).. those kind of uses
> really use mlock to avoid
> 1) IO to the filesystem
> 2) Needing memory allocations for pagefault like things
> at least for the more "hidden" cases...
>=20
> prefaulting everything ready pretty much gives them that... letting
> things fault on demand... nicely breaks that.

Non of that is changed. So I'm a little puzzled as to which side you
argue.

--=-qOF/8GImROPovAgsxKc6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHD4uRXA2jU0ANEf4RAukZAJ0aHili0JdvapCCVbqj4PmH93mDkQCghmuN
/4HJojo1ZxKPS3NGPpNzy7M=
=ppQA
-----END PGP SIGNATURE-----

--=-qOF/8GImROPovAgsxKc6--

