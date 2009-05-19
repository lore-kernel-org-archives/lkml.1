Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZESNGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZESNGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZESNGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:06:36 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:48620 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZESNGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:06:34 -0400
Date: Tue, 19 May 2009 15:06:16 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: make clean drivers/staging/cpc_usb fails on linux-next: Tree for
	May 19
Message-ID: <20090519130616.GA15430@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090519183044.a910aa7a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20090519183044.a910aa7a.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc5-next-20090515-05297-g9bbe396 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Stephen Rothwell [Tue, May 19, 2009 at 06:30:44PM +1000]:
> Hi all,
>=20
> Changes since 20090518:

Just tried to make clean && make all:

Switched to a new branch 'next-20090519'
+ make -j8 clean
  CLEAN   /home/users/compiler/linux/linux-next
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/vdso
  CLEAN   init
  CLEAN   arch/x86/kernel
  CLEAN   kernel
  CLEAN   lib
  CLEAN   arch/x86/boot
  CLEAN   firmware
  CLEAN   drivers/char
  CLEAN   usr
  CLEAN   drivers/md
  CLEAN   drivers/scsi/aic7xxx
scripts/Makefile.clean:17: /home/users/compiler/linux/linux-next/drivers/st=
aging/cpc_usb/Makefile: No such file or directory
make[3]: *** No rule to make target `/home/users/compiler/linux/linux-next/=
drivers/staging/cpc_usb/Makefile'.  Stop.
make[2]: *** [drivers/staging/cpc_usb] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/staging] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [_clean_drivers] Error 2
ikn%=20

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoSrscACgkQuL75KpiFGIxTXwCfdgEE/nFrsL2DKiA5Fej715Bi
rRMAoK967yMmpLdlH8AXabF3U1H5KSxy
=YEN8
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
