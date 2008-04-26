Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbYDZSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbYDZSGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYDZSGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:06:12 -0400
Received: from virgo.iok.hu ([193.202.89.103]:44720 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYDZSGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:06:11 -0400
X-Greylist: delayed 869 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Apr 2008 14:06:11 EDT
Date: Sat, 26 Apr 2008 19:51:38 +0200
From: Miklos Vajna <vmiklos@frugalware.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [git pull] generic bitops, take 2
Message-ID: <20080426175138.GL4012@genesis.frugalware.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Kwy1es1GwkEJhNg"
Content-Disposition: inline
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Kwy1es1GwkEJhNg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> then it fails with:
>
>  mm/filemap.c: In function '__generic_file_aio_write_nolock':
>  mm/filemap.c:1831: sorry, unimplemented: inlining failed in call to 'generic_write_checks': function body not available
>
> i used:
>
>    make ARCH=um SUBARCH=x86_64 -j64 linux
>
> on x86-64, gcc-4.3.0-0.13. Config is:
>
>    http://redhat.com/~mingo/misc/.config.um

I just hit this bug as well:

        make linux ARCH=um

on i686, gcc 4.3.0, config at
http://uml.nagafix.co.uk/kernels/kernel32-2.6.25.config

Thanks.

--/Kwy1es1GwkEJhNg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkgTa6kACgkQe81tAgORUJZTcQCeIsS34r5UHgOtZ3dvdO+NDhnu
fH8An3G0ELWYyDObvmCLySqkUEGf5VE6
=B5F/
-----END PGP SIGNATURE-----

--/Kwy1es1GwkEJhNg--
