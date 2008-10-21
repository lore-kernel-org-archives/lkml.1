Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbYJUINv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbYJUINv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYJUINh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:13:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33527 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYJUINg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:13:36 -0400
Date: Tue, 21 Oct 2008 19:13:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mackerras <paulus@samba.org>
Cc: "Chris Friesen" <cfriesen@nortel.com>, linuxppc-dev@ozlabs.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: build failure on powerpc with current -git
Message-Id: <20081021191324.d4810d40.sfr@canb.auug.org.au>
In-Reply-To: <18685.27030.529655.761257@cargo.ozlabs.ibm.com>
References: <48F8E86B.702@nortel.com>
	<18685.27030.529655.761257@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Oct_2008_19_13_24_+1100_yTaNXRAow3v+=FeB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Oct_2008_19_13_24_+1100_yTaNXRAow3v+=FeB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paulus,

On Tue, 21 Oct 2008 16:33:10 +1100 Paul Mackerras <paulus@samba.org> wrote:
>
> It's a bug in older versions of ld (including 2.16.1) that's fixed in
> the current version (2.18).  However, this patch appears to work
> around the problem - at least, it let me build a 32-bit kernel with a
> cross-toolchain including a 2.16.1 ld.  Let me know if this gets it
> working for you.

With that patch applied I got these errors for a powerpc ppc64_defconfig
build (linux-next).

/usr/bin/objcopy: Warning: '/dev/null' is not an ordinary file
make[2]: *** [arch/powerpc/boot/zImage.pmac] Error 1
make[2]: *** Waiting for unfinished jobs....
/usr/bin/objcopy: Warning: '/dev/null' is not an ordinary file
make[2]: *** [arch/powerpc/boot/zImage.pseries] Error 1
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Oct_2008_19_13_24_+1100_yTaNXRAow3v+=FeB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj9jyQACgkQjjKRsyhoI8w9yACfWKeMDbrd+UnysP1+LceONeGj
UxEAoLbraQzCB2HYZzYx2BX2EYytkenX
=gnzE
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Oct_2008_19_13_24_+1100_yTaNXRAow3v+=FeB--
