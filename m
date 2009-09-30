Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZI3S5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZI3S5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 14:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZI3S5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 14:57:09 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:57709 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZI3S5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 14:57:07 -0400
Date: Wed, 30 Sep 2009 15:57:07 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
Message-ID: <20090930185707.GI17475@vespa.holoscopio.com>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com> <200909300950.39332.bjorn.helgaas@hp.com> <20090930175141.GG17475@vespa.holoscopio.com> <200909301227.49916.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0XMZdl/q8hSSmFeD"
Content-Disposition: inline
In-Reply-To: <200909301227.49916.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0XMZdl/q8hSSmFeD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2009 at 12:27:48PM -0600, Bjorn Helgaas wrote:
> On Wednesday 30 September 2009 11:51:43 am Thadeu Lima de Souza Cascardo =
wrote:
> > On Wed, Sep 30, 2009 at 09:50:38AM -0600, Bjorn Helgaas wrote:
> > > On Monday 28 September 2009 07:38:00 pm Thadeu Lima de Souza Cascardo=
 wrote:
> > > > This add supports for devices like keyboard, backlight, tablet and
> > > > accelerometer.
> > >=20
> > > Something about the PNP IDs bothered me yesterday, but I couldn't
> > > figure out what.  You're using:
> > >=20
> > >   ACCE0000
> > >   TBLT0000
> > >   IPML200
> > >   FnBT0000
> > >=20
> > > Normally these OEM-specific ACPI drivers claim PNP IDs like ATK0100,
> > > TOS6200, FUJ02B1, etc., that are obviously OEM-specific.
> > >=20
> > > But the ones you're claiming seem pretty generic, like things
> > > we could imagine appearing on machines other than the Classmate.
> > >=20
> > > So I guess my question is, "Are these really generic?  If so, should
> > > this be split into separate, non-Classmate named drivers, such as
> > > 'accelerometer', 'tablet', etc.?"
> > >=20
> >=20
> > Although I agree that {ATK,TOS,FUJ,IBM}* give pretty much a certainty
> > these are OEM-specific, I think we'd need some evidence that
> > {ACCE,TBLT,IPML,FnBT}* are generic enough to grant them a non-classmate
> > driver.
> >=20
> > What I mean is that we should push this driver forward and turn these
> > into a generic driver if we get some evidence these are not
> > Classmate-specific. And that will happen when we hit some other system
> > with these devices.
>=20
> Yep, I agree with you that it's not worth splitting things up until
> we find these devices on more systems.  Just out of curiosity, where
> did you find specs for these devices?  If there's a public spec, it'd
> be nice to have a pointer to it in the driver.
>=20
> Bjorn

There was no public spec. I used as reference some source code released
as GPL. This implementation used proc files as user interface. Other
references are the dumped tables, which I am using to implement what is
very likely a rfkill device. We are still doing some tests before adding
it to the driver.

Regards,
Cascardo.

--0XMZdl/q8hSSmFeD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrDqgMACgkQyTpryRcqtS2FMACgkfz4FT+M4itIFJ5zAa0gj7wu
QeYAn0pwOMsf34RTSbkzWiJ2alOb/KBh
=4ms0
-----END PGP SIGNATURE-----

--0XMZdl/q8hSSmFeD--
