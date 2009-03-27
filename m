Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbZC0Uka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbZC0Uka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZC0UkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:40:19 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:54087 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbZC0UkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=PEt0kbkIw3cfLpBVobdpi493sM2TdFjVUIXm9NmlzFCq1xZUr98RTIFz+T2cDLwTtl
         EzfIrIh+21hcWi2aQNOakeeaHKXf9YY5Z5xnPPw9AgCCg6JW175zfSSdgu6O7OYSxCk5
         TNUcL7jfJmznon/Hj6EooAdmQH63rmi+FWwT4=
Date: Fri, 27 Mar 2009 21:41:06 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: avorontsov@ru.mvista.com
Cc: cbou@mail.ru,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using POWER or APM for battery handling
Message-Id: <20090327214106.dbf36adf.kristoffer.ericson@gmail.com>
In-Reply-To: <20090327192947.GA13609@oksana.dev.rtsoft.ru>
References: <20090327202406.60885d4a.kristoffer.ericson@gmail.com>
	<20090327192947.GA13609@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Mar_2009_21_41_06_+0100_nb31ckfDkgf7uM.v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Mar_2009_21_41_06_+0100_nb31ckfDkgf7uM.v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Mar 2009 22:29:47 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Hello Kristoffer,
>=20
> On Fri, Mar 27, 2009 at 08:24:06PM +0100, Kristoffer Ericson wrote:
> > Hey Anton,
> >=20
> > My machines (HP Jornada 600-series and HP Jornada 700-series) both
> > rely on batteries for power. Now, in the past it has all
> > been handled by an APM_EMULATION driver that
> > essentially detects the current state (loading YES/NO,=20
> > POWER_LEFT, ESTIMATED TIME LEFT,...) and adjusts
> > the state of the machine.
> >=20
> > My question is should I port this to instead
> > use the power class (drivers/power) or not.
>=20
> The driver is already there:
> drivers/power/apm_power.c
>=20
> So all you need is Jornada driver for the power supply class,
> and then apm_power.c will work for your battery driver.
>=20
> Feel free to ask if there is anything still not clear.

Great!

I think I understand, but should I create this driver
inside /drivers/power or inside the mach folder (in this case arch/arm/mach=
-sa1100)?

>=20
> Thanks,
>=20
> --=20
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Fri__27_Mar_2009_21_41_06_+0100_nb31ckfDkgf7uM.v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknNOeIACgkQPQls10ERAGcO/gCcCVDqWH7Wn8nYKIXXDzC1D44X
tP0An0MwCBQ0HK7/elXnd7VBXRK4Vl35
=mjKp
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Mar_2009_21_41_06_+0100_nb31ckfDkgf7uM.v--
