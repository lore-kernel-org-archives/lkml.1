Return-Path: <linux-kernel-owner+w=401wt.eu-S1765792AbYDORAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765792AbYDORAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYDORAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:00:38 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32797 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765615AbYDORAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:00:37 -0400
Subject: Re: 2.6.25-rc8-mm2: Observed problems: Not a detailed bug report
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080410203354.f0a6f464.akpm@linux-foundation.org>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-61HAKXyPOIcLs8Ol+tXt"
Date: Tue, 15 Apr 2008 11:00:29 -0600
Message-Id: <1208278829.7230.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080415/1JloWF-0001Kk-H1-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-61HAKXyPOIcLs8Ol+tXt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-10 at 20:33 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/=
2.6.25-rc8-mm2/

I figured that I would post these without details just so they're out
there.  I've had trouble getting netconsole to dump anything when I need
it to.  I've also had trouble convincing myself to spend the off-work
hours I need to narrow it down.

The general environment is a AMD64 laptop running 64-bit Gentoo, GCC
4.3.

Problem #1:
Compiling with the stack protector option crashes right after initramfs
loads.  I think it might be dying while attempting to mount root.
Simple work around: Don't compile with stack protector.

Problem #2:
Resume from STR.  The laptop suspends and goes into suspend state with
the blinking power indicator.  On resume, it simply boots normally
instead of resuming.  No idea how to debug this one.  Bisect I guess.
--=20
Zan Lynx <zlynx@acm.org>

--=-61HAKXyPOIcLs8Ol+tXt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgE3y0ACgkQolqWs/Y4NLyq/ACgjS7JYp1RlLxxCj9S0lRxdcga
j44AnjHXGXy4QJ+EyR9GK1qhewRgW0sV
=I4Ku
-----END PGP SIGNATURE-----

--=-61HAKXyPOIcLs8Ol+tXt--

