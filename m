Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997Ab0AKWof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0AKWof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828Ab0AKWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:44:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46209 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab0AKWod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:44:33 -0500
Date: Tue, 12 Jan 2010 09:44:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build failure
Message-Id: <20100112094425.a2b8de8f.sfr@canb.auug.org.au>
In-Reply-To: <20100111123338.GA15938@sortiz.org>
References: <20100111160232.e37e5393.sfr@canb.auug.org.au>
	<20100111105126.GD3440@sirena.org.uk>
	<771cded01001110402p1d2c475bgdde077f066e7f22d@mail.gmail.com>
	<20100111123338.GA15938@sortiz.org>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Jan_2010_09_44_25_+1100__s0cxOF1/axlaX0."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jan_2010_09_44_25_+1100__s0cxOF1/axlaX0.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Mon, 11 Jan 2010 13:33:39 +0100 Samuel Ortiz <sameo@linux.intel.com> wro=
te:
>
> Actually, I fixed it. The problem was caused by the mfd and regulator dri=
vers
> having the same name, i.e. max8925.ko. I renamed the regulator driver to
> max8925-regulator.ko, which also makes it more consistent with the rest o=
f the
> regulator drivers.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Jan_2010_09_44_25_+1100__s0cxOF1/axlaX0.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktLqckACgkQjjKRsyhoI8y3iQCggC1SP9J19F9ftmMH3u3VTDbN
O0sAoJ+BUQae3NET0KhhMI5ud9C5X3cy
=e+ZW
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jan_2010_09_44_25_+1100__s0cxOF1/axlaX0.--
