Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZJPV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZJPV7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZJPV7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:59:20 -0400
Received: from dovecot.org ([82.118.211.50]:55429 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZJPV7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:59:19 -0400
Subject: Re: [PATCH] proc/pid/cmdline: Handle invalid cmdline change
 failures correctly.
From: Timo Sirainen <tss@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091016145431.ed00922e.akpm@linux-foundation.org>
References: <1254542832.5405.6.camel@hurina>
	 <20091016145431.ed00922e.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uo2yfrBGocGumoDLOZ3q"
Date: Fri, 16 Oct 2009 17:59:20 -0400
Message-Id: <1255730360.4605.754.camel@timo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uo2yfrBGocGumoDLOZ3q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-16 at 14:54 -0700, Andrew Morton wrote:
> On Sat, 03 Oct 2009 00:07:12 -0400
> Timo Sirainen <tss@iki.fi> wrote:
>=20
> > Handle access_process_vm() failures correctly in /proc/pid/cmdline.
> > This bug might have leaked kernel memory to userspace.
> >=20
>=20
> And I don't see what it is.  afacit the current code is correct.

It is, sorry. Someone had mentioned access_process_vm() could fail by
returning negative values and I didn't verify that myself before sending
this "fix".


--=-uo2yfrBGocGumoDLOZ3q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkrY7LgACgkQyUhSUUBVisnF2QCY+kxRvUDC91rlyIDX0bScPKWV
GwCbBIRDP1MANKHXDMK/fKpqT/2aNbc=
=Xjss
-----END PGP SIGNATURE-----

--=-uo2yfrBGocGumoDLOZ3q--

