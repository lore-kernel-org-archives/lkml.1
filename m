Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbXEOM23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbXEOM23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbXEOM2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:28:23 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2623 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214AbXEOM2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:28:22 -0400
Date: Tue, 15 May 2007 14:28:19 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Hubertus Grobbel <hubertus@grobbel.net>
Cc: Linux List <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT for FAT
Message-ID: <20070515122819.GK26683@gateway.home>
References: <200705150103.02398.hubertus@grobbel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rnP2AJ7yb1j09OW/"
Content-Disposition: inline
In-Reply-To: <200705150103.02398.hubertus@grobbel.net>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rnP2AJ7yb1j09OW/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 15, 2007 at 01:02:51AM +0100, Hubertus Grobbel wrote:
> I found out, that the option O_DIRECT for opening a file on a fat-
> filesystem successfully completes. But reading and writing to that
> file leads to EINVAL errors (using kernel 2.6.18).

Make sure your buffer is page aligned and read/write in multiples of
the hard block size (use blockdev --getss to figure out).


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--rnP2AJ7yb1j09OW/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSadj/PlVHJtIto0RAoUBAJ4hgLOK1qsoiXiKmSHvyfSbxvwGbgCeO3Vv
glAIQCXLu+tWK8JzFIO4j5w=
=jGLQ
-----END PGP SIGNATURE-----

--rnP2AJ7yb1j09OW/--
