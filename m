Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYLCJJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYLCJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYLCJJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:09:13 -0500
Received: from home.keithp.com ([63.227.221.253]:52373 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYLCJJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:09:11 -0500
Subject: Re: [PATCH] usb/serial/cp2101: Add support for cp2103 GPIO pins
From: Keith Packard <keithp@keithp.com>
To: Greg KH <gregkh@suse.de>
Cc: keithp@keithp.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081203071225.GC12582@suse.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com>
	 <1227774576-5503-2-git-send-email-keithp@keithp.com>
	 <20081127105823.30786bf4@lxorguk.ukuu.org.uk>
	 <1227810026.4277.48.camel@aiko.keithp.com> <20081127184109.GA20479@suse.de>
	 <1227835903.4277.69.camel@aiko.keithp.com> <20081203071225.GC12582@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iL4aTuibLmVqqNtPH+ql"
Date: Wed, 03 Dec 2008 00:11:11 -0800
Message-Id: <1228291871.6187.23.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iL4aTuibLmVqqNtPH+ql
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-02 at 23:12 -0800, Greg KH wrote:

> Ick.  Ok, care to come up with some kind of hook into the gpio subsystem
> of the kernel so we don't create a new user/kernel interface for
> something that we already support?

Yeah, it does seem like exposing GPIOs to user space would be really
useful. Coming up with credible semantics seems a bit tricky though, and
may not fit the read/write model that we know and love.

> libusb can be very fast.  The new version handles multiple urbs in
> flight, and threaded applications very easily.  You might want to take a
> look at it again if it has been a while.

Sigh. Yes, I can probably use libusb for this application. Not as easily
as I can hack up the kernel, but it should do the trick.

--=20
keith.packard@intel.com

--=-iL4aTuibLmVqqNtPH+ql
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJNj8fQp8BWwlsTdMRAibAAKDg0h7ifdDXy1jsbH8AS+P+EZ4+HwCZAbcj
TDhyCYbR1fPuBwJ0YpkcATw=
=+gLS
-----END PGP SIGNATURE-----

--=-iL4aTuibLmVqqNtPH+ql--

