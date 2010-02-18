Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab0BRRGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:06:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49150 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab0BRRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:06:37 -0500
Date: Thu, 18 Feb 2010 17:06:25 +0000
From: Eric B Munson <ebmunson@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf record and multiple events
Message-ID: <20100218170625.GB3856@us.ibm.com>
References: <20100217173822.GA4137@us.ibm.com>
 <1266500821.26719.649.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <1266500821.26719.649.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Feb 2010, Peter Zijlstra wrote:

> On Wed, 2010-02-17 at 17:38 +0000, Eric B Munson wrote:
> > While testing perf record I found that when multiple events are specifi=
ed
> > on the command line, i.e. perf record -e dTLB-misses -e cache-misses,
> > the are lumped into a single category on output from perf report.  The
> > same event specification gives two event categories when using perf sta=
t.
> > Is this working as expected or should I see seperate entries in the rep=
ort
> > for each event?
>=20
> The tools currently lack support for this, but patches are welcome.
>=20

Thanks, I'll start looking into it.

--=20
Eric B Munson
IBM Linux Technology Center
ebmunson@us.ibm.com


--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkt9c5EACgkQsnv9E83jkzounwCghe7RxBxg3bqRx7UaWoJV/2bd
JSMAoLsUg8O7Z9F9zIUFiOasj9zvKdUi
=XE4f
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
