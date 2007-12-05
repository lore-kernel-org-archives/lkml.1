Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbXLEVtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbXLEVtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLEVte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:49:34 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3755 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXLEVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:49:33 -0500
Date: Wed, 5 Dec 2007 22:49:29 +0100
From: Erik Mouw <mouw@nl.linux.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jay Cliburn <jacliburn@bellsouth.net>, linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071205214928.GD3995@gateway.home>
References: <20071204210433.4d7ee66c@osprey.hogchain.net> <20071205210003.GA15366@uranus.ravnborg.org> <20071205213702.GC3995@gateway.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8nsIa27JVQLqB7/C"
Content-Disposition: inline
In-Reply-To: <20071205213702.GC3995@gateway.home>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2007 at 10:37:03PM +0100, Erik Mouw wrote:
> Here's a clue: when I build with ARCH=3Dx86, I get some warnings, but the
> targz-pkg builds succesfully:
>=20
> erik@arthur:~/git/linux-2.6 > make ARCH=3Dx86 allnoconfig
> [...]
> erik@arthur:~/git/linux-2.6 > make ARCH=3Dx86 targz-pkg
> [...]
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> /bin/sh /home/erik/git/linux-2.6/scripts/package/buildtar targz-pkg
> `/home/erik/git/linux-2.6/System.map' ->
> /`/home/erik/git/linux-2.6/tar-install/boot/System.map-2.6.24-rc4'
> `/home/erik/git/linux-2.6/.config' ->
> /`/home/erik/git/linux-2.6/tar-install/boot/config-2.6.24-rc4'
> `/home/erik/git/linux-2.6/vmlinux' ->
> /`/home/erik/git/linux-2.6/tar-install/boot/vmlinux-2.6.24-rc4'
> `arch/x86/boot/bzImage' ->
> /`/home/erik/git/linux-2.6/tar-install/boot/vmlinux-kbuild-2.6.24-rc4'
>=20
> ** ** **  WARNING  ** ** **
>=20
> Your architecture did not define any architecture-dependant files
> to be placed into the tarball. Please add those to
> /home/erik/git/linux-2.6/scripts/package/buildtar ...
>=20
> Tarball successfully created in
> /home/erik/git/linux-2.6/linux-2.6.24-rc4.tar.gz
>=20
> So it looks like the i386-x86_64 merge has something to do with it.

Sorry, wrong clue. It builds because there are no modules to be made
(allnoconfig).


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--8nsIa27JVQLqB7/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHVxzo/PlVHJtIto0RAsv3AJ0WqrjaXaesATv1zJlf/3bZKIIt1QCffHPI
7V6sBQPXhwvOdZdWYWRmIeg=
=hPdj
-----END PGP SIGNATURE-----

--8nsIa27JVQLqB7/C--
