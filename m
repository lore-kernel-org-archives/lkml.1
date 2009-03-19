Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZCSOve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZCSOve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZCSOv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:51:26 -0400
Received: from mx1.mxtelecom.com ([87.86.212.101]:43017 "EHLO
	puma.mxtelecom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752489AbZCSOvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:51:25 -0400
Date: Thu, 19 Mar 2009 14:51:18 +0000
From: Paul Evans <paul@mxtelecom.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slow long-term increase in dirty pages
Message-ID: <20090319145118.32c5bfb0@nacelle.mxtelecom.com>
In-Reply-To: <20090319044751.GA12918@localhost>
References: <20090318145347.3d709de8@nacelle.mxtelecom.com>
	<20090319044751.GA12918@localhost>
Organization: MX Telecom
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6Gk6O83w+cYM0+5U71Zut8H";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6Gk6O83w+cYM0+5U71Zut8H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Mar 2009 12:47:51 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> The attached filecache patch shall help identify the dirty
> files/pages.
>=20
> Usage:
>         # run patched kernel
>         modprobe filecache
>         cat /proc/filecache
>=20
> The dirty files will have the 'D' flag in its "state" field.

Wow, that looks very useful. I'll have a play with it and see if it
yields anything of interest.

Thanks,

--=20
Paul Evans <paul@mxtelecom.com>
Tel: +44 (0) 845 666 7778
Fax: +44 (0) 870 163 4694
http://www.mxtelecom.com

--Sig_/6Gk6O83w+cYM0+5U71Zut8H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknCW+cACgkQcGehlx3Gqx4mjwCdGUeogoO+d1m5/qhj6UYBnV8o
SPMAnizJU8Tv0hOTul7P5M6zRXijYanM
=ZzM9
-----END PGP SIGNATURE-----

--Sig_/6Gk6O83w+cYM0+5U71Zut8H--
