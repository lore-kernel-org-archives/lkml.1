Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZI3Rvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZI3Rvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZI3Rvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:51:44 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:52331 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbZI3Rvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:51:42 -0400
Date: Wed, 30 Sep 2009 14:51:43 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
Message-ID: <20090930175141.GG17475@vespa.holoscopio.com>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com> <200909300950.39332.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HB4mHL4PVvkpZAgW"
Content-Disposition: inline
In-Reply-To: <200909300950.39332.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HB4mHL4PVvkpZAgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2009 at 09:50:38AM -0600, Bjorn Helgaas wrote:
> On Monday 28 September 2009 07:38:00 pm Thadeu Lima de Souza Cascardo wro=
te:
> > This add supports for devices like keyboard, backlight, tablet and
> > accelerometer.
>=20
> Something about the PNP IDs bothered me yesterday, but I couldn't
> figure out what.  You're using:
>=20
>   ACCE0000
>   TBLT0000
>   IPML200
>   FnBT0000
>=20
> Normally these OEM-specific ACPI drivers claim PNP IDs like ATK0100,
> TOS6200, FUJ02B1, etc., that are obviously OEM-specific.
>=20
> But the ones you're claiming seem pretty generic, like things
> we could imagine appearing on machines other than the Classmate.
>=20
> So I guess my question is, "Are these really generic?  If so, should
> this be split into separate, non-Classmate named drivers, such as
> 'accelerometer', 'tablet', etc.?"
>=20

Although I agree that {ATK,TOS,FUJ,IBM}* give pretty much a certainty
these are OEM-specific, I think we'd need some evidence that
{ACCE,TBLT,IPML,FnBT}* are generic enough to grant them a non-classmate
driver.

What I mean is that we should push this driver forward and turn these
into a generic driver if we get some evidence these are not
Classmate-specific. And that will happen when we hit some other system
with these devices.

And what would be the consequences to this decision? Renaming the
driver, changing the config location and documentation. Splitting them.
I can't think of anything else. If splitting them would be interesting
by now, we can do it.

That's my opinion. Please, tell me what you think of it.

> Bjorn
>=20

Thanks for the comments and best regards,
Cascardo.

--HB4mHL4PVvkpZAgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrDmq0ACgkQyTpryRcqtS2/UgCZAYwTw5VlHxRVrFGAm0xWkeB5
pMgAn2Af2Ccl0+P9xPOMN5lI1MSmz70D
=zK4R
-----END PGP SIGNATURE-----

--HB4mHL4PVvkpZAgW--
