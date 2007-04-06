Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXDFVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXDFVul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933165AbXDFVuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:50:40 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33427 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933161AbXDFVuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:50:39 -0400
Subject: Re: coding style for long conditions
From: Zan Lynx <zlynx@acm.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: David Brownell <david-b@pacbell.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
In-Reply-To: <adabqi16v5a.fsf@cisco.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	 <200704061029.55710.david-b@pacbell.net>
	 <46169968.2050006@s5r6.in-berlin.de>
	 <200704061405.50169.david-b@pacbell.net>  <adabqi16v5a.fsf@cisco.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H+bQrWz4h4BnrWPT2j1g"
Date: Fri, 06 Apr 2007 21:50:23 +0000
Message-Id: <1175896223.6644.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H+bQrWz4h4BnrWPT2j1g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-06 at 14:38 -0700, Roland Dreier wrote:
[snip]
> If you have a git tree handy, you can do "git show 68380b58" and see
> that Linus himself wrote:
>=20
> 	if (get_wq_data(work) =3D=3D cwq
> 	    && work_pending(work)
> 	    && !list_empty(&work->entry)) {
>=20
> I have to admit that I would have put the &&s at the ends of the
> previous lines rather than where Linus put them, but... egads!  Linus
> put spaces before the &&s to line them up nicely!

My favorite form uses only tabs and would make that look like:
	if(
		get_wq_data(work) =3D=3D cwq &&
		work_pending(work) &&
		!list_empty(&work->entry)
	) {
		...
		...
	}

Putting the && at the front would be OK with me too, it does make them
more obvious and easier to find.

I don't find too many people who like my style but that's OK.  I think
it makes everything a lot easier to read and everything lines up with
8-space tabs or 2 or 3 space tabs.  Plus, reformatting other people's
code gives me a good chance to read it as I go. :-)
--=20
Zan Lynx <zlynx@acm.org>

--=-H+bQrWz4h4BnrWPT2j1g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGFsCfG8fHaOLTWwgRAs3pAJ0X6pL6XG/GVYYUMWtDL+O7iV/w3wCePeVY
isxzRI287/n6ON8Z94OlKg8=
=B70v
-----END PGP SIGNATURE-----

--=-H+bQrWz4h4BnrWPT2j1g--

