Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXKWFTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXKWFTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 00:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXKWFTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 00:19:14 -0500
Received: from partizan.velesys.com ([213.184.230.195]:57284 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXKWFTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 00:19:13 -0500
Date: Fri, 23 Nov 2007 07:19:55 +0200
From: "Kirill A. Shutemov" <k.shutemov@velesys.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Marin Mitov <mitov@issp.bas.bg>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] 2.6.24-rc3-mm1: usb mouse doesn't work
Message-ID: <20071123051955.GA28946@localhost.localdomain>
References: <200711221941.44646.mitov@issp.bas.bg> <Pine.LNX.4.44L0.0711222148590.5327-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711222148590.5327-100000@netrider.rowland.org>
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel
	2.6.18-std-smp-alt8)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On [Thu, 22.11.2007 21:51], Alan Stern wrote:
> On Thu, 22 Nov 2007, Marin Mitov wrote:
>=20
> > > > > I've had some strangenesses with USB lately.  Sometimes running `=
lsusb'
> > > > > makes the USB system notice a newly attached device.
> > > >
> > > > No. But I have new messages in dmesg:
> > > >
> > > > uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> > > > uhci_hcd 0000:00:1d.2: FGR not stopped yet!
> > > > uhci_hcd 0000:00:1d.1: FGR not stopped yet!
> > > > uhci_hcd 0000:00:1d.0: FGR not stopped yet!
> > > >
> > > > > Is that "FGR not stopped yet!" messgae new behaviour?
> > > >
> > > > It is a new message since 2.6.24-rc3. I have never try -mm tree bef=
ore.
> > >
> > > These messages could indicate a timing problem.  You can see the code
> > > that writes the messages near the end of wakeup_rh() in
> > > drivers/usb/host/uhci-hcd.c.
> > >
> > > The message gets written if the controller hardware hasn't turned off=
 a
> > > particular bit after a 4-us delay.  If the udelay() function wasn't
> > > working right, it could cause this problem.
> >=20
> > udelay() _is_ OK for 2.6.24-rc3, so it is not the cause of the problem
>=20
> But is it OK for 2.6.24-rc3-mm1?  Kirill said specifically that=20
> 2.6.24-rc3 does not display the message but 2.6.24-rc3-mm1 does.

How can I test it?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHRmL6bWYnhzC5v6oRAo56AJ9VaETfNesvewi6kfvm9vCRejfyPwCfVXIj
jHwrzSKl0iTG63JUH8d0nUg=
=OZnh
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
