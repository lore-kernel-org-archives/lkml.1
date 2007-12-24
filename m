Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbXLXKmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbXLXKmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 05:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLXKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 05:42:41 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39550 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbXLXKmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 05:42:40 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Subject: Re: [PATCH - SH/Dreamcast] CD-Rom (GD-Rom) support for the SEGA Dreamcast
Date: Mon, 24 Dec 2007 05:38:35 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Paul Mundt" <lethal@linux-sh.org>
References: <8b67d60712231143n51a17cdeu536b501855e870b2@mail.gmail.com> <8b67d60712231241y5c44e444yf011643e048255b9@mail.gmail.com>
In-Reply-To: <8b67d60712231241y5c44e444yf011643e048255b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart47941697.u0i09Dy8ye";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712240540.47501.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart47941697.u0i09Dy8ye
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 23 December 2007, Adrian McMenamin wrote:
> On 23/12/2007, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> > This patch adds support for the CD-Rom (the so-called "GD-Rom") on the
> > SEGA Dreamcast.
> >
> > The GD-Rom is based on the ATA-3 standard but implements a proprietary
> > packet interface - the so-called Sega Packet Interface (SPI) and
> > supports a proprietary CD format (the "Giga Disk"). This driver
> > implements the SPI at least partially and will also read GD disks.
> >
> > There was a CD Rom driver for the 2.4 kernel series (out of mainline).
> > This, though, is new code and unlike the previous driver uses DMA and
> > not PIO to read disks.
> >
> > This is the third iteration of this patch - there remains the issue of
> > __init versus __devinit - see http://lkml.org/lkml/2007/12/23/130 but
> > I think otherwise it has dealt with most people's suggestions. The one
> > exception is that Jens suggested using sector_div, though I found that
> >  did not work.
>
> Unfortunately that patch was lined wrapped.

what e-mail client do you use ?  they usually have options for you to turn =
off=20
line wrapping ...

> Here it is (actually, slightly fixed) again.

running it through checkpatch finds a few syntax issues ... might want to d=
o=20
that real quick and post a new one (just ignore the 80 chars warning as you=
=20
see fit).
=2Dmike

--nextPart47941697.u0i09Dy8ye
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iQIcBAABAgAGBQJHb4yvAAoJEEFjO5/oN/WBsJUP+gOfJxmqbyNadHHwSXtyqSGT
beeZ4f7roOjweLEuc1PkTKBIe5AX2j1zQ8I8yGOeXObGw4FlMmUyev4i/BXI5qtL
iOw/kjRlXxYbJs9/Q1/4OViDnQo/o2b1QAd+Sqy1Qe30jbbUpgVVV/+LXcy1rUHg
vUWG1I3bSdPKFKsasqdh/oQr4ozqaVYqA3RyFLMrmxknTWrGm4ukmIo4QZeW0XWm
It7YaHwLcKkHACMrnH910vxy/uLp+l5FSeysWmwBpjavDL6CSJZzGp/KJz9ZJ0xv
ULtSWl3eJhSctEOc4CzHEAQA3OTGfIuK5m5HKZqgOzgtJPjXO+Pn0VbSZVZdVMUo
7MFZlmH4y0qZsBndoDEaMwTjU5tOWIxrIr6ZtelU/oITUfqvhaP/XJf8QxYYdibZ
o8Llyrfb33/aOZInEckqf+NtciYxCM/slABs0xXUGlMb9pVeGIA3EM8rmCAvYcbq
KrvSkrFIm8Vtm/NXSeCcKUiCInL/wK3j78OcvvOqu3t4gVTGSx7JEwXwlfqE0c69
6JbNGPkpOGDeK79EHnt0Hq/ki72MwSWn2lVS6ZoE2wgOqW2EDB/G02GB3xllNPOZ
K+QWFshrDwReFKn3c+cf8u3/T8UL2iekzd78MVsyQRCr/9lqxp80OC+3LUOO+JOs
tlz4zO43LyIDp9bg4jbd
=FTJO
-----END PGP SIGNATURE-----

--nextPart47941697.u0i09Dy8ye--
