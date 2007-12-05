Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbXLEUR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbXLEUR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXLEURv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:17:51 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3278 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXLEURv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:17:51 -0500
X-Greylist: delayed 895 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2007 15:17:50 EST
Date: Wed, 5 Dec 2007 21:02:43 +0100
From: Erik Mouw <mouw@nl.linux.org>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071205200242.GB3995@gateway.home>
References: <20071204210433.4d7ee66c@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20071204210433.4d7ee66c@osprey.hogchain.net>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 04, 2007 at 09:04:33PM -0600, Jay Cliburn wrote:
> Sam,
>=20
> This piece of the top-level Makefile in current git causes an
> out-of-tree driver Makefile to fail.
>=20
> 101 ifdef O
> 102   ifeq ("$(origin O)", "command line")
> 103     KBUILD_OUTPUT :=3D $(O)
> 104   endif
> 105 endif
>=20
> The out-of-tree driver Makefile contains an O=3D... directive that
> (correctly) does _not_ specify the kernel source dir, and apparently
> isn't overridden by the command line either. If in the above Makefile
> snippet I change "command line" to "file", my out-of-tree make
> succeeds. What do you think about allowing O=3D to come from a file in
> addition to the command line?

Oh great, changing "command line" to "file" fixes my problem as well
(see http://lkml.org/lkml/2007/11/19/146 ). "make targz-pkg" works
flawless again.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHVwPi/PlVHJtIto0RAnmCAJ0QelDMUMlq0fytgaCtQaf3oSmA6wCfQbpY
mwVVuV6g1GTuUyFB5h4j6Zg=
=V/oM
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
