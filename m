Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327Ab0A2WCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0A2WCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600Ab0A2WCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:02:12 -0500
Received: from vserver.emeraldcity.de ([91.204.170.123]:48386 "EHLO
	smtphost.emeraldcity.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0A2WCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:02:11 -0500
X-Spam-ASN: 
From: Michail Bachmann <mb@emeraldcity.de>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: PROBLEM: kernel BUG at mm/page_alloc.c:775
Date: Fri, 29 Jan 2010 23:01:57 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-686; KDE/4.3.4; i686; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <201001092232.21841.mb@emeraldcity.de> <20100118120315.GD7499@csn.ul.ie> <201001210110.18569.mb@emeraldcity.de>
In-Reply-To: <201001210110.18569.mb@emeraldcity.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7036799.4qDCbclDcj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201001292302.04105.mb@emeraldcity.de>
X-Envelope-From: <mb@emeraldcity.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7036799.4qDCbclDcj
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> > On Tue, Jan 12, 2010 at 03:25:23PM -0600, Christoph Lameter wrote:
> > > On Sat, 9 Jan 2010, Michail Bachmann wrote:
> > > > [   48.505381] kernel BUG at mm/page_alloc.c:775!
> > >
> > > Somehow nodes got mixed up or the lookup tables for pages / zones are
> > > not giving the right node numbers.
> >
> > Agreed. On this type of machine, I'm not sure how that could happen
> > short of struct page information being corrupted. The range should
> > always be aligned to a pageblock boundary and I cannot see how that
> > would cross a zone boundary on this machine.
> >
> > Does this machine pass memtest?
>=20
> I ran one pass with memtest86 without errors before posting this bug, but=
 I
> can let it run "all tests" for a while just to be sure it is not caused by
> broken hw.

Please disregard this bug report. After running memtest for more than 10 ho=
urs=20
it found a memory error. The funny thing is, linux found it much faster...

Thanks for your time.

CU Micha

--nextPart7036799.4qDCbclDcj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCAAGBQJLY1rWAAoJEDOFMLjtzdvOJrgP/A6Hpalr96+T5A5IaZRA2SPd
gp5s6ZSPnTD6gN7YC/yDJsONZ4dZRU6eEQFoH2CK2Bp7aXFzdOFiA0QNsHUZNE5z
LZiTdcCCCU56kxTUVR1LyLBPYaHwoKPo5rsJQLDlrX1eDXxtKHlXu6M6yX1DcptG
HYnbT665Jhr0/gDMP1lwzZHMTyRKuk+tdapfqU+dNxft466VVmERewhtn5WnaKoR
YxAUfTn+G3Im7ccetSzSm3GQybicU1isQpCbUQH9mVxXyvJ1usLeV0c6FeUcRsKU
wiiWKx3IrebpYNS0KshgO16/z2QKNtsgLHQVBw9UKUIKTf8/KaiH/5A3KW24H6Pj
7fMO/D1PDxkvw2UNyeu7JDgY6l8XkWoqngszJC+JtJPupTWyErDpoJ6euxHk/s67
Fx5t/6Z38n5UTzHhOqh+0+oyjTmhmlrLhi5XkJqYPcpzIv0Vo7mapmt5jSmNgA8X
hOfTiYUMNDrbZlPgHHtJDHR2VeqsvfY6JLzUULB7Ctr4IW+IiSg+0miCldJTpE1h
wxq2LeelB9EI3L0rgdsJAx+tHK6E8JsosHmfkSsvJEqCWHqS3/saKOp7Z7VHrUJZ
IutnobNri2Qyt6cqHjg5J+OzBldKUR9sJfUEOLtd5IND5INAtd/XzN6/KbQcBlts
1/OMirLEr0zIIccxdD5p
=OA0D
-----END PGP SIGNATURE-----

--nextPart7036799.4qDCbclDcj--
