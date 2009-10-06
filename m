Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZJFDzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZJFDzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 23:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbZJFDzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 23:55:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43987 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbZJFDzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 23:55:10 -0400
Date: Tue, 6 Oct 2009 14:54:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: Samuel Ortiz <sameo@openedhand.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: mfd tree build failure
Message-Id: <20091006145425.a9cc611a.sfr@canb.auug.org.au>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04B6A3794F@SC-VEXCH1.marvell.com>
References: <20091006130202.5e18a332.sfr@canb.auug.org.au>
	<25B60CDC2F704E4E9D88FFD52780CB4C04B6A3794F@SC-VEXCH1.marvell.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Oct_2009_14_54_25_+1100_JnI1TB.TLR+Y0j=C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Oct_2009_14_54_25_+1100_JnI1TB.TLR+Y0j=C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Haojian,

On Mon, 5 Oct 2009 19:35:05 -0700 Haojian Zhuang <hzhuang1@marvell.com> wro=
te:
>
> Could you send your .config file to me? The 88pm8607 patch is just for mf=
d-2.6 git tree. I didn't try it in linux-next git tree before. I can try it=
 now. If I could have your .config file, it would be better.

I am sorry, but I don't have the exact .config file any more (I have
moved on in my creation of linux-next)  however, as I said, this was an
allmodconfig build on x86_64.  I also noted that CONFIG_I2C=3Dm and
CONFIG_MFD_CORE=3Dm, while the config entry that controls the building of
this driver is a bool so must have been 'y'.  So from a builtin driver,
you are referring to symbols that are only defined in modules.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Oct_2009_14_54_25_+1100_JnI1TB.TLR+Y0j=C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrKv3EACgkQjjKRsyhoI8zD6QCfXQLIeQSMYelk1WOkuEU9q0yx
0PQAn1bMHMavSvudvDTKt96LPukNr0v4
=SYXZ
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Oct_2009_14_54_25_+1100_JnI1TB.TLR+Y0j=C--
