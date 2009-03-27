Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbZC0U6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbZC0U6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZC0U6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:58:24 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:37266 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbZC0U6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=SSlYoSw1x2rNGKltgySWbJ8uHuST6E40AXBaxrw809lPeFd7yWb9PsE4ZxPptIBNR3
         qQpoBxJucrY4pdno2DeXDUXRBN5UR4YC9sPMc4XNq9BmFvX75Kv9K8cp6g+WJxlpTY//
         vlhllYDLIGyvjJIsmIbv2yuWwcr25x4QNNsW0=
Date: Fri, 27 Mar 2009 21:59:21 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: avorontsov@ru.mvista.com
Cc: cbou@mail.ru,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using POWER or APM for battery handling
Message-Id: <20090327215921.eb6761f9.kristoffer.ericson@gmail.com>
In-Reply-To: <20090327205513.GA32692@oksana.dev.rtsoft.ru>
References: <20090327202406.60885d4a.kristoffer.ericson@gmail.com>
	<20090327192947.GA13609@oksana.dev.rtsoft.ru>
	<20090327214106.dbf36adf.kristoffer.ericson@gmail.com>
	<20090327205513.GA32692@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Mar_2009_21_59_21_+0100_6DV3TOJQDGNfliCe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Mar_2009_21_59_21_+0100_6DV3TOJQDGNfliCe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Mar 2009 23:55:13 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Fri, Mar 27, 2009 at 09:41:06PM +0100, Kristoffer Ericson wrote:
> [...]
> > > The driver is already there:
> > > drivers/power/apm_power.c
> > >=20
> > > So all you need is Jornada driver for the power supply class,
> > > and then apm_power.c will work for your battery driver.
> > >=20
> > > Feel free to ask if there is anything still not clear.
> >=20
> > Great!
> >=20
> > I think I understand, but should I create this driver
> > inside /drivers/power or inside the mach folder (in this case arch/arm/=
mach-sa1100)?
>=20
> I would prefer drivers/power/.

roger, big thanks for help.

>=20
> Thanks,
>=20
> --=20
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Fri__27_Mar_2009_21_59_21_+0100_6DV3TOJQDGNfliCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknNPikACgkQPQls10ERAGfhBgCguBQbRF3+10Q0mSoY2LUPdbAf
lFUAoMb+B07f8cws1kFNC9enRvaZALRr
=PG1l
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Mar_2009_21_59_21_+0100_6DV3TOJQDGNfliCe--
