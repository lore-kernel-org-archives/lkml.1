Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbYEPWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbYEPWA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYEPWAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:00:17 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:42935 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750752AbYEPWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:00:16 -0400
Subject: GPL Violation: Compro Technology Inc, 2.6.17 modified binary-only
	kernel distribution
From: Jo Shields <directhex@apebox.org>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WjyOOiNUM5Z7oC0NpK1N"
Date: Fri, 16 May 2008 23:00:12 +0100
Message-Id: <1210975212.7181.26.camel@mortos>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WjyOOiNUM5Z7oC0NpK1N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've discovered a GPL violation by Taiwanese TV card manufacturer Compro
Technology.

On their site, they are offering a "driver" for Mandriva
Linux 2007.1, in the form of an 18 meg "linux.rpm"[1,2,3,4]. This
"driver" is, in fact, an entire kernel image (from snd-emu10k1.ko to
libata.ko, with everything in between), generated from Mandriva's kernel
source package, with local modifications to at least two files (major
file size gap between Compro and Mandriva kernels in tuner.ko and
cx88xx.ko).

Their "driver" is being offered in binary-only form, without any
accompanying license, and I have received no replies to a formal request
for source after 2 (Taiwanese) working days. Obviously, this violates
several GPL clauses, and infringes on the rights of every kernel
developer with code in 2.6.17.

It is also the opinion of a LinuxTV developer with whom I've been
discussing the matter that their modified drivers appear to contain
large un-redistributable portions of code from a chip vendor's
proprietary SDK, but we obviously can't adequately check this with
only .ko files to work with.

They appear to be offering a similar "driver" for Fedora Core 6, which
is non-functional, presumably due to a failed upload (cpio fails to
extract the rpm)[4,5].

I'm not 100% certain what my next step should be, so I decided this was
the best place to give a public airing. One suggestion I've had
suggested is to file a DMCA takedown notice with their (US-based) ISP,
but I've no idea whether it's the right stage to do something like that,
nor do I have any claim to any code contained in the kernel. At any
rate, I wanted to make the kernel developers informed of this discovery.

I'm not on this mailing list, so a CC: would be appreciated.

--Jo Shields


[1] http://www.comprousa.com/downloadfiles/linux.rpm
[2] http://www.comprousa.com/en/download/sseries.html
[3] http://www.comprousa.com/en/download/tseries.html
[4] http://www.comprousa.com/en/download/xseries.html
[5] http://www.comprousa.com/downloadfiles/kernel-2618prep-3i386.rpm


--=-WjyOOiNUM5Z7oC0NpK1N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBILgPsWQvNUd/Cr8ERAptmAKDaHmawXZCvLATNm+cbcs/FhTOgzQCeK5uy
XNF19ANpxtIP2IGZSxFYN9Y=
=bvaf
-----END PGP SIGNATURE-----

--=-WjyOOiNUM5Z7oC0NpK1N--

