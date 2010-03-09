Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0CIKrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:47:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35292 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab0CIKrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:47:11 -0500
Date: Tue, 9 Mar 2010 21:47:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] i2c: update for semaphore to mutex conversion of 
 devices
Message-Id: <20100309214702.307a1f5a.sfr@canb.auug.org.au>
In-Reply-To: <20100309113950.48be08a1@hyperion.delvare>
References: <20100309102828.18351564.sfr@canb.auug.org.au>
	<20100309092508.02b7b2e8@hyperion.delvare>
	<20100309213650.e22c9908.sfr@canb.auug.org.au>
	<20100309113950.48be08a1@hyperion.delvare>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Mar_2010_21_47_02_+1100_45Mb/SNsaScoO_3X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Mar_2010_21_47_02_+1100_45Mb/SNsaScoO_3X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Tue, 9 Mar 2010 11:39:50 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>
> > Thanks.  The include of mutex.h is not actually needed yet as Greg didn=
't
> > send the semaphore to mutex change to Linus due to other issues.
>=20
> It will never be needed, and I also removed the include of semaphore.h.
> The beauty of the new API is that it hides the implementation details
> from the caller!

Yeah, except it scares me a little since device.h currently does not
directly include semaphore.h and the patch that changes the semaphore to
a mutex does not include mutex.h in device.h either ...

I guess that is a problem for Greg, though.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Mar_2010_21_47_02_+1100_45Mb/SNsaScoO_3X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuWJycACgkQjjKRsyhoI8y80QCgigS3Nlq4/szCXmSL9loTRbeN
4yQAoLMvYprsAt7JE6Wj4jrCYvxBXn2z
=zTSo
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Mar_2010_21_47_02_+1100_45Mb/SNsaScoO_3X--
