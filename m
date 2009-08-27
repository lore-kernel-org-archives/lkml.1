Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZH0AE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZH0AE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 20:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZH0AE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 20:04:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39336 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbZH0AE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 20:04:57 -0400
Date: Thu, 27 Aug 2009 10:04:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: michael@ellerman.id.au
Cc: Alemao <xcarandiru@gmail.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: PPC driver - generic bus width
Message-Id: <20090827100452.b872c7fd.sfr@canb.auug.org.au>
In-Reply-To: <1251296565.7492.7.camel@concordia>
References: <d970ff420908260625q2d34bc10p62241218f022b5c2@mail.gmail.com>
	<1251296565.7492.7.camel@concordia>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_Aug_2009_10_04_52_+1000_Nxqm+2Yz+bwuMFrG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Aug_2009_10_04_52_+1000_Nxqm+2Yz+bwuMFrG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Aug 2009 00:22:45 +1000 Michael Ellerman <michael@ellerman.id.au=
> wrote:
>
> > struct device_info_t {
> > 	void (*read)();
> > 	void (*write)();

These are not prototypes because there is no parameter list (use "void" for=
 empty).

> > };
> >=20
> > static int __devinit device_probe()

This isn't a prototype either.

> > cc1: warnings being treated as errors
> > drivers/dev_test.c:37: warning: function declaration isn't a prototype
> > drivers/dev_test.c:38: warning: function declaration isn't a prototype
> > drivers/dev_test.c: In function 'device_probe':
> > drivers/dev_test.c:113: warning: assignment from incompatible pointer
> > type
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_Aug_2009_10_04_52_+1000_Nxqm+2Yz+bwuMFrG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqVzaQACgkQjjKRsyhoI8yRfQCgvq09fSY3N41YiJ9Vm0xACqnL
5bkAni6e6kP69a50HmamFzaEF0+OCfWQ
=saha
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Aug_2009_10_04_52_+1000_Nxqm+2Yz+bwuMFrG--
