Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXGWAoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXGWAoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764536AbXGWAoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:44:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60448 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764012AbXGWAog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:44:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
Date: Sun, 22 Jul 2007 20:45:14 -0400
User-Agent: KMail/1.9.7
Cc: Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200706180209.36762.vapier@gentoo.org> <200706182053.04116.ak@suse.de> <46794BE2.5020108@zytor.com>
In-Reply-To: <46794BE2.5020108@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3663358.dbr6gXfI3x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707222045.15935.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3663358.dbr6gXfI3x
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 20 June 2007, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> asm-i386/msr.h should not be exported to userspace at all, it contains
> >> nothing but kernel-internal helpers.
> >
> > Actually rdtsc and rdtscll and potentially rdpmc which is in there can =
be
> > very useful in user space if you know what you're doing. Unfortunately a
> > lot of its users don't, but not having the include probably won't stop
> > them either.
>
> More likely, people will just re-implement them incorrectly.
>
> However, the rdtsc() definition in the kernel is weird (and removable, I
> think there are no more users -- I have it removed in my MSR driver
> rewrite tree which I need to get off my arse and push.)  Most users
> would expect the rdtscll() functionality with the rdtsc() name.

does that mean you'll also take care of cleaning up msr.h ?  or do i need t=
o=20
post another patch ?
=2Dmike

--nextPart3663358.dbr6gXfI3x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iQIVAwUARqP6G0FjO5/oN/WBAQIxEw/+NSz8FFeIY/S5cGAZ/Y5B+V92lsNhC25H
iosSYUXPo+9Gos+lHv1LzfFzg5LT3BFxb2qheS3yeANWTx0bmyGQlqLsVRU5nGs9
AB4J8pwq6rC+C3m+4etLue2KepBenASrrUozwY3CzOEFVNyFeoIaJQVeoFJ55osA
hyYlrguJLpLVTPkbYua9wVpyYWtsxNqIjOuQrCtsREIvpUlNtfMzp+2q/9S88ezd
514s6tfqo5Z0LD1FO/jHEaw3y+GybTnAapt/LoJXccQRdW8wp7MeF0Sr6oGzRCvh
FWF1OgM9EaDZonlCC42LpnrKVtPHWehqKacSn6Q+ezhkA3qaSRN/ybGSi36Va1hT
sdLAXEDin+i7q4Z5Oe97PQZ28t0sJxomsg6pqqDvj0XnYexgGQyGJPQnHtvWTWY9
9e9Id4PjAg79DVG6DNSJ0lzg9HKiHRGQCn/gXZpe1tvhc2kGA601sVvqmKx4FDpa
AD6U3BItO3CzCMSuy2ZKeTIBlfyTUq/nAcLbwFDs9fF86sNj95QRVeU21Kbu90x9
zQtsmnLXe1pfkNXg5ha5/AavpgRnsnZXhyFfpF4nE2Tw5PJLEe8xoOK1lYC6BvY8
MW482fMfQ5G73IhW8HZa6iQiJDpxgGyHVF1iVW7jVx2jjFZIfDASpaRTi8F/l4fE
NpM5e6DNVnE=
=2eO3
-----END PGP SIGNATURE-----

--nextPart3663358.dbr6gXfI3x--
