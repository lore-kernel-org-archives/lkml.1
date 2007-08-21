Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXHUM52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXHUM52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbXHUM5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:57:20 -0400
Received: from iucha.net ([209.98.146.184]:43106 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbXHUM5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:57:19 -0400
Date: Tue, 21 Aug 2007 07:57:18 -0500
From: Florin Iucha <florin@iucha.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070821125718.GH10422@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz> <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xs+9IvWevLaxKUtW"
Content-Disposition: inline
In-Reply-To: <20070821115115.GD10422@iucha.net>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--xs+9IvWevLaxKUtW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2007 at 06:51:15AM -0500, Florin Iucha wrote:
> On Wed, Aug 15, 2007 at 04:58:33PM +0200, Jiri Kosina wrote:
> > On Wed, 15 Aug 2007, Florin Iucha wrote:
> >=20
> > > [See my message to Alan]: It happened twice, within 15 minutes of=20
> > > boot+login, with 2.6.23-rc3-$whatever .  I does not happen with=20
> > > 2.6.2[123](-rc*)?  After the two incidents, I rebooted in 2.6.23-rc2 =
and=20
> > > it is working for an hour now.
> >=20
> > It is not immediately clear what might be causing this, 2.6.23-rc3 didn=
't=20
> > get any USB nor HID updates at all compared to 2.6.23-rc2.
> >=20
> > Could you please enable USB and HID debugging to see whether we can see=
=20
> > anything spurious in the logs at the time the keyboard gets stuck?
>=20
> Jiri,
>=20
> I have enabled USB debugging and I see a bunch (=3D46) of these messages:
>=20
>    [  $timestamp] usb 1-9: usb auto-suspend
>    [  $timestamp] usb 1-9: usb auto-resume
>    [  $timestamp] ehci_hcd 0000:00:02.1: GetStatus port 9 status 001005 P=
OWER sig=3Dse0 PE CONNECT
>    [  $timestamp] usb 1-9: finish resume
>=20
> The messages continued to be logged, even after the keyboard has
> become unresponsive.

[snip]

> Do you need me to build a -rc2 with USB debug enabled to compare and
> contrast?

With 2.6.23-rc2 and USB_DEBUG enabled, I see the same messages but no
keyboard "dissapearance".

I have rebuilt 2.6.23-rc3 with 'CONFIG_USB_EHCI_HCD=3Dm' and
'CONFIG_USB_SUSPEND is not set' and will use it for a while, to see if=20
the keyboard/usb behaves or not.

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--xs+9IvWevLaxKUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGyuEuND0rFCN2b1sRAt94AKCcWIELPwKMGxtdwKOzo362qTPS6QCfYT8a
7jXC8sCR5JYYbUlhyTkzSVg=
=x6wR
-----END PGP SIGNATURE-----

--xs+9IvWevLaxKUtW--
