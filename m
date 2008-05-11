Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYEKQI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYEKQI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbYEKQIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:08:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:13917 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbYEKQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:08:43 -0400
Date: Sun, 11 May 2008 17:08:32 +0100
From: Ricardo Martins <ricardo@scarybox.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: julia@diku.dk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH 1/4] sound/isa: use unsigned for loop index
Message-ID: <20080511160832.GA4709@macbookpro>
References: <Pine.LNX.4.64.0805111450000.29620@ask.diku.dk> <20080511164335.GA19745@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20080511164335.GA19745@martell.zuzino.mipt.ru>
X-PGP-Key-URL: http://scarybox.net/zomg/ricardo.asc
X-OS: Linux 2.6.24-ARCH x86_64
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 11 May 2008 20:43, Alexey Dobriyan wrote:
> On Sun, May 11, 2008 at 02:50:33PM +0200, Julia Lawall wrote:
> > A few more cases in the spirit of the patch "Trivial: Replacement of al=
ways
> > >0 ints with unsigned ints" submitted by Ricardo Martins <ricardo@scary=
box.net>
>=20
> And rationale for those would be ...?

Acccording to the kernel-janitors TODO [1], Jeff Garzik suggested the follo=
wing:

  2) "unsigned int" is preferred to "int", it generates better asm code
  on all platforms except sh5. This replacement needs to be done manually,
  because often 'int' is required due to negative values -Exxx commonly
  passed as error values.

Since (most) loop counters such as "int i" are always either zero or a posi=
tive
number, they are perfect candidates for using unsigned int instead, imho.
It goes without saying, that each case must be considered separately in
case a negative value is indeed needed.

[1] http://kernelnewbies.org/KernelJanitors/Todo

Regards,
--=20
 Ricardo Martins  *  scarybox.net  *  GPG key: 0x1308F1B4

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkgnGgAACgkQkH81LRMI8bQveQCeODXoXvWmBuC7O1eUT0U1KYSt
Jy8An2UKw1kePvGuejlyesIHOQr/4eE5
=BYjF
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
