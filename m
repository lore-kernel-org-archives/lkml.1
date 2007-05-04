Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXEDPc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXEDPc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXEDPc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:32:28 -0400
Received: from home.keithp.com ([63.227.221.253]:3821 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148AbXEDPc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:32:27 -0400
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
From: Keith Packard <keithp@keithp.com>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: keithp@keithp.com, Jerome Glisse <j.glisse@gmail.com>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <463B27C4.3040304@tungstengraphics.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <1178137279.53297.114.camel@vonnegut>
	 <46391860.3070409@tungstengraphics.com>
	 <1178251621.27028.9.camel@neko.keithp.com>
	 <463AE9AE.7070806@tungstengraphics.com>
	 <4240b9160705040149v3c97413fg54f1486f55ffbc11@mail.gmail.com>
	 <463B12F9.8060900@tungstengraphics.com>
	 <4240b9160705040457n46be9b62p7c760fb54898ba37@mail.gmail.com>
	 <463B27C4.3040304@tungstengraphics.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cbkDLrRFaSyNOo4CUzND"
Date: Fri, 04 May 2007 08:32:06 -0700
Message-Id: <1178292726.27028.45.camel@neko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cbkDLrRFaSyNOo4CUzND
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-04 at 14:32 +0200, Thomas Hellstr=C3=B6m wrote:
>  If there isn't we can at least consider other=20
> alternatives that resolve the deadlock issue but that also will help=20
> clients synchronize and keep data coherent.

If clients want coherence, they're welcome to implement their own
locking. Let's make sure we separate the semantics required for GPU
operation from semantics required by DRM users.

--=20
keith.packard@intel.com

--=-cbkDLrRFaSyNOo4CUzND
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGO1H2Qp8BWwlsTdMRAkcbAKDIXJR+8y7hgVF1bBFq8cyGXE/2kgCgw4cY
+ShgJ+YzcrhyVsSMT2jWg90=
=VAsA
-----END PGP SIGNATURE-----

--=-cbkDLrRFaSyNOo4CUzND--
