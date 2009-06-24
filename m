Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZFXVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZFXVTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZFXVT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:19:26 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:54598 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZFXVTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:19:25 -0400
Date: Wed, 24 Jun 2009 18:19:25 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] Return ENODEV instead of EINVAL when trying to
	open ACM device.
Message-ID: <20090624211924.GG5299@vespa.holoscopio.com>
References: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com> <20090624204015.GD28516@suse.de> <200906242317.05307.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GUPx2O/K0ibUojHx"
Content-Disposition: inline
In-Reply-To: <200906242317.05307.oliver@neukum.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GUPx2O/K0ibUojHx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2009 at 11:17:04PM +0200, Oliver Neukum wrote:
> Am Mittwoch, 24. Juni 2009 22:40:15 schrieb Greg KH:
> > On Wed, Jun 24, 2009 at 08:31:15AM -0300, Thadeu Lima de Souza Cascardo=
 wrote:
> > > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > > ---
> > >  drivers/usb/class/cdc-acm.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> > > index 38bfdb0..02eb60b 100644
> > > --- a/drivers/usb/class/cdc-acm.c
> > > +++ b/drivers/usb/class/cdc-acm.c
> > > @@ -550,7 +550,7 @@ static void acm_waker(struct work_struct *waker)
> > >  static int acm_tty_open(struct tty_struct *tty, struct file *filp)
> > >  {
> > >  	struct acm *acm;
> > > -	int rv =3D -EINVAL;
> > > +	int rv =3D -ENODEV;
> >
> > Why is this needed?
>=20
> The current error return is incorrect. If the table entry is gone, the
> device has been disconnected, hence -ENODEV.
>=20
> 	Regards
> 		Oliver
> Acked-by: Oliver Neukum <oliver@neukum.org>
>=20

Or if the device has never been connected at all.

--GUPx2O/K0ibUojHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpCmFwACgkQyTpryRcqtS25NACfUunwuMK9GuW0raT5nyUdXviG
3McAnixhFnsyaRPAq+CUzzclRo1CWDIA
=9IkR
-----END PGP SIGNATURE-----

--GUPx2O/K0ibUojHx--
