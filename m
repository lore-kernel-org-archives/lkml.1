Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZF0R1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZF0R1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbZF0R1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:27:17 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:63344 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbZF0R1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=Du/0rReHapGL+0W7/HaFccE+THroEMDsMpZZep1+cDNQxYTuf+Gav0jAgP0qlCdnqR
         k4z6qcbREm4yJIrbGPffTttgN+19kbNzB8Nv0fwAmVS1oF+DPBUlXYc3TNbY3vk/dwQA
         FnUCegEE0V9xjfDmRBhw9tlz3GWTHggvEQ0jM=
Subject: Re: [PATCHv3] PCAP regulator driver (for 2.6.32)
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
In-Reply-To: <20090627105150.GA4780@sirena.org.uk>
References: <1246072682.10360.424.camel@brutus>
	 <20090627105150.GA4780@sirena.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QZMYC4WZuv2oPfPsqaCr"
Date: Sat, 27 Jun 2009 14:26:58 -0300
Message-Id: <1246123618.3727.29.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QZMYC4WZuv2oPfPsqaCr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em S=C3=A1b, 2009-06-27 =C3=A0s 11:51 +0100, Mark Brown escreveu:
> On Sat, Jun 27, 2009 at 12:18:02AM -0300, Daniel Ribeiro wrote:
> > Add (partial) support for the voltage regulators on the PCAP2 PMIC.
> >=20
> > Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
>=20
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>=20
> Looks good.

Thanks.

> > Mark, can you please assert that this only gets merged after Samuel has
> > a chance to merge the set_bits patch? Thanks!
>=20
> It's Liam who manages the regulator tree, though given the set_bits()
> patch perhaps this one might end up getting merged via the MFD tree (or
> both via the regulator tree).

I prefer the set_bits() patch going through the MFD tree. I sent some
other fixes, and a patch to solve a similar race issue for the ADC/TS
driver.

Ideally, Samuel would push the PCAP patches on -rc phase, so the
sub-drivers can all be merged through the respective subsystem trees on
the .32 merge window.

--=20
Daniel Ribeiro

--=-QZMYC4WZuv2oPfPsqaCr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpGVmIACgkQw3OYl0G0liQsiQCdHAP2Glny3cWYoJZP9LyBx7C/
XjAAn07/VypEKB5taXXSG1Cs3U0he17u
=TxJ/
-----END PGP SIGNATURE-----

--=-QZMYC4WZuv2oPfPsqaCr--

