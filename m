Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbXFQXzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbXFQXzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXFQXzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:55:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51384 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbXFQXza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:55:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390 byteorder.h
Date: Sun, 17 Jun 2007 19:55:32 -0400
User-Agent: KMail/1.9.7
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       rmk@arm.linux.org.uk
References: <200706171833.29046.vapier@gentoo.org> <1182120674.22999.4.camel@laptopd505.fenrus.org> <200706180124.25574.arnd@arndb.de>
In-Reply-To: <200706180124.25574.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4660292.UO7Q3EYMze";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706171955.34044.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4660292.UO7Q3EYMze
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 17 June 2007, Arnd Bergmann wrote:
> On Monday 18 June 2007, Arjan van de Ven wrote:
> > On Sun, 2007-06-17 at 18:33 -0400, Mike Frysinger wrote:
> > > This changes asm() to __asm__() and volatile to __volatile__ so that
> > > these headers can be used with gcc's -std=3Dc99.
> >
> > hmm but the kernel doesn't use -std=3Dc99...
>
> The byteorder headers are exported to user space through
> include/asm-generic/Kbuild.asm, and they are used by a number
> of other exported headers, so they should work with any
> gcc flags that a user might want to use.

yeah, sorry, i should have mentioned the point here was that these are=20
exported headers
=2Dmike

--nextPart4660292.UO7Q3EYMze
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARnXJ9UFjO5/oN/WBAQJ6tw//c/wTRos4hMQhyWzGfGYgzoddTJrImjyc
Kv9qa5PcYoRnePUpE9ixfZNYgJJAMmIVz4UbLuj6cx6rtvz5DgFUL32Qql2U1NNJ
J35v72+eofz/HiM0hC8ZrfrHQ4wyg/ZshyI2gtMI4y2z5EUJ1z0JiGTf0R61K2T/
IQGMdYn3vLiJMe80Ixi4BWzXvZ4W+HJBiOEpX5GqOainRkl8ZgIYLgR6whP9A2pX
mCpElIDzwff8spMuaIMlCjfW53y6dt0bywHvo1OPVta45iI7MxvC+5VWiB7ILnhc
Jts7OqomDpM0VSWIADecqofASqX0X+IbucUDzT4f5NDrdRHsH9j1eYLE30ceAYpD
Xu57LD6q7qltohYWE/YbOOqPBhkfbL11IEdiY45Q8jDHANzsbyKrM2w7cFbrLTLa
YoLShpyXuzTUFz+7ue94V0g4lokZJErH+/TrmgDqOqPT2VtBXCUgO8jfZPd+DPpH
7Byije/kyTn9//l2rp5pX3RX8jY3gGI+ib4asr8soe5MXL+AxLNwe9EFp7Vq7cVI
Drh1laSRJALI9fyFIAcgdDduMsprzhsNGIFncdKZMICu284pCNGxegC7YMU3fV+Q
TX+XCk3XrKYMK87rTtQ24Xgn8fDcEQoU0gHDT7RBzu674OncAmU/NUf86I2Zuu4C
sMNO/GvAjwI=
=eUhk
-----END PGP SIGNATURE-----

--nextPart4660292.UO7Q3EYMze--
