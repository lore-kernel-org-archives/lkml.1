Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbYKFSyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbYKFSyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYKFSyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:54:07 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:55267 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYKFSyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:54:05 -0500
From: Peter Alfredsen <loki_val@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Date: Thu, 6 Nov 2008 20:52:31 +0200
User-Agent: KMail/1.9.10
References: <20081106174341.GA8155@xolotl.n0ano.com>
In-Reply-To: <20081106174341.GA8155@xolotl.n0ano.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1721112.6vrcq5roqt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811061952.37490.loki_val@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1721112.6vrcq5roqt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 06 November 2008, n0ano@n0ano.com wrote:
> I notice that many of the files that make up the serial driver
> are licensed as "either version 2 of the License, or (at your
> option) any later version".  Unfortunatley, I would like to use
> some of the code from `drivers/serial/8250_pci.c' in grub2,
> which is a GPL v3 project, but the copyright for this file
> says:
>
>  * This program is free software; you can redistribute it and/or
> modify * it under the terms of the GNU General Public License as
> published by * the Free Software Foundation; either version 2 of the
> License.
>
> The `either' in that sentence would lead me to believe that there
> was a typo and the `or later' clause was dropped off but, as it
> stands, it's just bad English that says version 2 only.
>
> Anyone know what the true intent was and how to resolve this?

It seems like a typo to me to.. That wording has been constant since the=20
file drivers/serial/serial_8250_pci.c was created based on work in=20
drivers/char/serial.c:
http://git.kernel.org/?p=3Dlinux/kernel/git/tglx/history.git;a=3Dcommitdiff=
;h=3D33c0d1b0c3ebb61243d9b19ce70d9063acff2aac
serial_8250.c has the "or later" clause there.

But I suppose the best way is to ask the originator of that file.=20
Russell, what say you?
Did you mean to license that file under GPL-2 or GPL-2+?

=2D-=20
/PA

--nextPart1721112.6vrcq5roqt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkTPPUACgkQtEGUx4TfHiTg2wCeLFgBFdoORNRFUCe5aPHAek9V
dv4AnRup2tHqRUiY1KKH9V4e2/bk3/MT
=HYf9
-----END PGP SIGNATURE-----

--nextPart1721112.6vrcq5roqt--
