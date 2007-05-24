Return-Path: <linux-kernel-owner+w=401wt.eu-S1763757AbXEXETR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763757AbXEXETR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbXEXETH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:19:07 -0400
Received: from mail.ipom.com ([69.73.131.218]:47595 "EHLO mail.ipom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759421AbXEXETG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:19:06 -0400
X-Greylist: delayed 1166 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 00:19:06 EDT
Message-ID: <46550DA7.60504@ipom.com>
Date: Wed, 23 May 2007 20:59:35 -0700
From: Phil Dibowitz <phil@ipom.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Ben Collins <bcollins@ubuntu.com>
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/6] UNUSUAL_DEV: Sync up some reported devices from Ubuntu
References: <98cd38b5.git.bcollins@ubuntu.com> <317339ef5cb48f652b8eb33c3a1a44d8a2b31493.1179964369.git.bcollins@ubuntu.com>
In-Reply-To: <317339ef5cb48f652b8eb33c3a1a44d8a2b31493.1179964369.git.bcollins@ubuntu.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig53DCD9B10DB4E9D49F6AD3BB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig53DCD9B10DB4E9D49F6AD3BB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ben Collins wrote:
> Various unusual dev entries accumulated from Ubuntu bug reports.
>=20
> CC: Phil Dibowitz <phil@ipom.com>

NACK. Two fixes I'd like to see fixed.

> +/* SanDisk that has a second LUN for a driver ISO, reported by
> + * Ben Collins <bcollins@ubuntu.com> */
> +UNUSUAL_DEV( 0x0781, 0x5406, 0x0000, 0xffff,

Please use specific device IDs unless you have reason to believe the rang=
e
as a whole is affected (or large portions at least)

> +/* Reported by Edward Chapman <[EMAIL PROTECTED]>
> +   Netac OnlyDisk Mini U2CV2 512MB USB 2.0 Flash Drive */
> +UNUSUAL_DEV( 0x0dd8, 0xd202, 0x0000, 0x9999,

Same here.

Thanks.
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enig53DCD9B10DB4E9D49F6AD3BB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGVQ2oN5XoxaHnMrsRAkXcAJ9KuhhCCNB6CSE1uZlFR3pHB+ATwgCgmh40
+522t0wLJVqHYE1xgLXLF6Q=
=es+m
-----END PGP SIGNATURE-----

--------------enig53DCD9B10DB4E9D49F6AD3BB--
