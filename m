Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbXHUM3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbXHUM3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbXHUM3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:29:00 -0400
Received: from iucha.net ([209.98.146.184]:50669 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbXHUM3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:29:00 -0400
Date: Tue, 21 Aug 2007 07:28:59 -0500
From: Florin Iucha <florin@iucha.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070821122859.GF10422@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz> <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net> <Pine.LNX.4.64.0708211402000.2460@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211402000.2460@twin.jikos.cz>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2007 at 02:04:26PM +0200, Jiri Kosina wrote:
> > I have enabled USB debugging and I see a bunch (=3D46) of these message=
s:
>=20
> >    [  $timestamp] usb 1-9: usb auto-suspend
> >    [  $timestamp] usb 1-9: usb auto-resume
> >    [  $timestamp] ehci_hcd 0000:00:02.1: GetStatus port 9 status 001005=
 POWER sig=3Dse0 PE CONNECT
> >    [  $timestamp] usb 1-9: finish resume
> > The messages continued to be logged, even after the keyboard has
> > become unresponsive.
>=20
> I guess that this is the card reader being suspended and resumed=20
> afterwards. Do you by any chance see any improvement when you
>=20
> - rmmod ehci_hcd

It's built-in.  Should I build it as a module?  This machine has only
usb 2.0 ports.  If I rmmod it, will my USB keyboard still work?

[The card reader is one of those that fit into a 3.5" bay, connected
straight to the motherboard controller, so it's a bit of a pain to
disconnect.]

> - disable USB_AUTOSUSPEND

You mean CONFIG_USB_SUSPEND?

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGytqLND0rFCN2b1sRAjGUAJ9ZWv0KWNaQ8PCHOqRmq04B8TRYOACfSZUO
pQdjhemhdoAixwg4KD6oKM0=
=gypn
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
