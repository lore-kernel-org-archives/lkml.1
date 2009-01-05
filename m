Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZAESlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZAESlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZAESlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:41:42 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49739 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZAESlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:41:42 -0500
Message-ID: <49625519.4050902@novell.com>
Date: Mon, 05 Jan 2009 13:44:41 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long
 periods
References: <20090105175641.GA17055@sgi.com>
In-Reply-To: <20090105175641.GA17055@sgi.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig51930D9271615C24FB92E189"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig51930D9271615C24FB92E189
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dimitri Sivanich wrote:
>
> I'm wondering if anyone else has run into this problem, and whether the=
y've
> found a resolution for it?
>
>  =20

Hi Dimitri,
  I have observed similar problems on my opensuse 11.0 box (2.6.25
based) when doing kernel builds.  Often times other apps will get
starved (like firefox, etc).  I was talking to peterz about it and he
pointed me at a commit that went into 28-rcx that fixes this (the sha
escapes me at the moment).  I've been meaning to pull the patch into our
2.6.25 and 2.6.27 trees to verify if it fixes it, but I have fairly high
confidence it will.  Perhaps Peter can point you at the same patch and
you can give it a whirl.  For the time being, can you see if 28 is fixed?=


-Greg


--------------enig51930D9271615C24FB92E189
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkliVRkACgkQlOSOBdgZUxlvJACgjdfzbZadhdGdvm2TUWSPm+3M
cTQAn0DqNxCyRrjiMrINX1KXvdZ6Na+a
=8PGa
-----END PGP SIGNATURE-----

--------------enig51930D9271615C24FB92E189--
