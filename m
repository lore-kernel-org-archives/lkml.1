Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYJIQAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYJIQAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYJIQAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:00:30 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:41345 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750996AbYJIQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:00:30 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Date: Thu, 9 Oct 2008 19:59:53 +0400
User-Agent: KMail/1.9.10
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-pcmcia@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810091722.56812.arvidjaar@newmail.ru> <20081009133125.GW25780@parisc-linux.org>
In-Reply-To: <20081009133125.GW25780@parisc-linux.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart38241674.49egKP3mVG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810091959.54987.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart38241674.49egKP3mVG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 09 October 2008, Matthew Wilcox wrote:
>=20
> On Thu, Oct 09, 2008 at 05:22:55PM +0400, Andrey Borzenkov wrote:
> > After loading orinoco and "inserting" adapter I get either BUG with
> > endless loop (attached) or kernel panic on NULL pointer dereference
> > (was not able capture). Adapter works fine with wlags49 driver.
>=20
> It looks like you've fallen off the bottom of the kernel stack.  Do you
> have 4k stacks enabled in your config?
>=20

You are right. Using 8K stacks load and runs fine. Hmm ... not nice
from it :p

--nextPart38241674.49egKP3mVG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjuKnoACgkQR6LMutpd94zyZwCgjue5AtOk7/Yk+zjWvjTk27ef
z6wAn2OsgNDzMS2SfmRgpy6ASBzjEexZ
=HPpY
-----END PGP SIGNATURE-----

--nextPart38241674.49egKP3mVG--
