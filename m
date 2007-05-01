Return-Path: <linux-kernel-owner+w=401wt.eu-S1423678AbXEAV2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423678AbXEAV2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423671AbXEAV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:28:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4114 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423672AbXEAV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:28:38 -0400
Date: Tue, 1 May 2007 22:27:51 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: =?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Message-ID: <20070501212750.GC31630@sirena.org.uk>
Mail-Followup-To: =?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <46365887.3010705@interia.pl> <20070430205522.abad2481.akpm@linux-foundation.org> <20070501084639.GA528@sirena.org.uk> <46371590.4090004@interia.pl> <20070501180830.GA31630@sirena.org.uk> <46379A7E.3000109@interia.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <46379A7E.3000109@interia.pl>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 82.32.140.119
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Natsemi DP83815 driver spaming
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 01, 2007 at 09:52:30PM +0200, Rafa=C5=82 Bilski wrote:

> >  * 2) check for sudden death of the NIC:
> >  *    It seems that a reference set for this chip went out with incorre=
ct info,
> >  *    and there exist boards that aren't quite right.  An unexpected vo=
ltage
> >  *    drop can cause the PHY to get itself in a weird state (basically =
reset).
> >  *    NOTE: this only seems to affect revC chips.

> Code commented out and NIC is working OK. Strange.
> eth0: DSPCFG accepted after 0 usec.
> eth0: link up.
> eth0: Setting full-duplex based on negotiated link capability.
> dspcfg =3D 0x00000000  np->dspcfg =3D 0x00005060

Oh, that's entertaining.  I have to confess that I've never seen an that
triggered the workaround before - adding the maintainer, Tim Hockin, who
may be able to shed some light on the expected behaviour here?

--=20
"You grabbed my hand and we fell into it, like a daydream - or a fever."

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUBRjew0g2erOLNe+68AQLB7gP/UF8EfsfYk3DpjOXTDxpq3sQULwcfwbKx
AqbjNFlQU+W/LuIBYIuUN5yYGRGHzGYE8u8lrjz25xXPDlia/K7YPbR6kJa68cTM
JUmeX6HD3h1PoYt5jUwzq4ZiIQP9mZJObGA5VLQ10erd+aKEE5Mz25wxVq0xX9ix
ZUn0gafqhM4=
=bjmt
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
