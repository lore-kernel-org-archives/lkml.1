Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZF0MHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZF0MHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 08:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZF0MGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 08:06:54 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36364 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbZF0MGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 08:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=KGKL9ebNpVUZSyJ61SkOiIEckAZ/n/b2hoscvg0tdVo6X3BMFxacntheHpfUQxA6y7
         K06uZhuRqDjNU+L4WmY0/BFeu3TH1mZeZVmt4lQ0G6HOF9lcU0kQeuugwQc4m1ji9ar9
         JBkadlpIajVM8HCsfy1KUULh+tPkYFU6CSNGg=
Date: Sat, 27 Jun 2009 15:07:08 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Oops] 2.6.31-rc1: tun
Message-ID: <20090627150708.53fdfb6b@mosly.slynet.org>
In-Reply-To: <20090627111832.GA22621@gondor.apana.org.au>
References: <20090625235335.42ba26be@mosly.slynet.org>
 <20090627111832.GA22621@gondor.apana.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZKgh+6_1HVZX12u6j/p5gur";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZKgh+6_1HVZX12u6j/p5gur
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > All my tun interfaces stopped working. ICMP works but IP(TCP/UDP) does =
not.
> > Machine started to hang. I tried to reproduce in linux console. You see=
 the .png result.
> > .config attached
>=20
> This patch should help (already merged by davem).
>=20
cherry-picked 71f9dacd2e4d233029e9e956ca3f79531f411827 from
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
onto current master from Linus.

openvpn works perfectly.

Thanks!

--=20

  Sergei

--Sig_/ZKgh+6_1HVZX12u6j/p5gur
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpGC3IACgkQcaHudmEf86p6/wCbBV1Gxyg1Nt2YBEWno8i1msDv
IPIAoIBDjbu9YqkDOE8PLPf742poZ58E
=58Sc
-----END PGP SIGNATURE-----

--Sig_/ZKgh+6_1HVZX12u6j/p5gur--
