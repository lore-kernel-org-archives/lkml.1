Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZIGSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZIGSfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZIGSfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:35:42 -0400
Received: from quackingmoose.com ([63.73.180.143]:60083 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753331AbZIGSfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:35:41 -0400
X-Greylist: delayed 1370 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 14:35:41 EDT
Date: Mon, 7 Sep 2009 11:12:53 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "david@fromorbit.com" <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] mm: write_cache_pages be more sequential
Message-ID: <20090907181253.GA29904@merfinllc.com>
References: <4AA513AA.3010206@nokia.com> <20090907141548.GA28054@wotan.suse.de> <4AA518B3.40401@nokia.com> <20090907144514.GC28054@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20090907144514.GC28054@wotan.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sep 07 04:45 PM, Nick Piggin wrote:
> > I meant that only part of the page was written. e.g.
> > write 10240 bytes, wait for writeback, then write another
> > 10240 bytes.  The pages will be written out in the order
> > 0, 1, 2, 3, 4, 2
>=20
> OK...
>=20
> I guess it is a reasonable workaround for the problem. It is a bit
> unsatisfying to special case on a page basis like this, but anyway
> I don't think there should be a realistic downside in practice.

*NOTE* we also see this in NFS (I think) where a file is written to
sequentially yet readers will see holes in the file.

This is allowed behavior for NFS but annoying.  So a work-around would
be great!

					=3Da=3D


--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aaron Straus
aaron@merfinllc.com

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFKpU0lr/o4YuvB+jgRAv+aAKCe/NfA989GHAvY3LsiKSb4kG6yAQCfT8z7
tURA9YSeObNfKrV6Hb8n4Hg=
=Lu6B
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
