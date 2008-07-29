Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYG2AIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYG2AIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYG2AIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:08:47 -0400
Received: from mail9.tpgi.com.au ([203.12.160.104]:42533 "EHLO
	mail9.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYG2AIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:08:46 -0400
X-TPG-Antivirus: Passed
Date: Tue, 29 Jul 2008 10:06:18 +1000
From: Alex Samad <alex@samad.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@skynet.ie>
Subject: Re: page swap allocation error/failure in 2.6.25
Message-ID: <20080729000618.GE1747@samad.com.au>
References: <20080725072015.GA17688@samad.com.au> <1216971601.7257.345.camel@twins> <20080727060701.GA7157@samad.com.au> <1217239487.6331.24.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <1217239487.6331.24.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2008 at 12:04:47PM +0200, Peter Zijlstra wrote:
> On Sun, 2008-07-27 at 16:07 +1000, Alex Samad wrote:
> > On Fri, Jul 25, 2008 at 09:40:01AM +0200, Peter Zijlstra wrote:
> > > On Fri, 2008-07-25 at 17:20 +1000, Alex Samad wrote:
> > > > Hi
> >=20
> > [snip]
> >=20
> > >=20
> > >=20
> > > Its harmless if it happens sporadically.=20
> > >=20
> > > Atomic order 2 allocations are just bound to go wrong under pressure.
> > can you point me to any doco that explains this ?
>=20
> An order 2 allocation means allocating 1<<2 or 4 physically contiguous
> pages. Atomic allocation means not being able to sleep.
>=20
> Now if the free page lists don't have any order 2 pages available due to
> fragmentation there is currently nothing we can do about it.

Strange cause I don't normal have a high swap usage, I have 2G ram and
2G swap space. There is not that much memory being used squid, apache is
about it.

>=20
> I've been meaning to try and play with 'atomic' page migration to try
> and assemble a higher order page on demand with something like memory
> compaction.
>=20
> But its never managed to get high enough on the todo list..
>=20
>=20

--=20
"I looked the man in the eye. I found him to be very straightforward and tr=
ustworthy... I was able to get a sense of his soul."

	- George W. Bush
06/16/2001
after meeting Russian President Vladimir Putin

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiOXvoACgkQkZz88chpJ2MImQCgvjaJnBndpImB/JdJyxT2jyJW
XoQAn1IyGLnIuZn/uWjJTOaHhTl6cgZv
=GP6O
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
