Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXHULvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXHULvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbXHULvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:51:17 -0400
Received: from iucha.net ([209.98.146.184]:52855 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXHULvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:51:17 -0400
Date: Tue, 21 Aug 2007 06:51:15 -0500
From: Florin Iucha <florin@iucha.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070821115115.GD10422@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz> <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 15, 2007 at 04:58:33PM +0200, Jiri Kosina wrote:
> On Wed, 15 Aug 2007, Florin Iucha wrote:
>=20
> > [See my message to Alan]: It happened twice, within 15 minutes of=20
> > boot+login, with 2.6.23-rc3-$whatever .  I does not happen with=20
> > 2.6.2[123](-rc*)?  After the two incidents, I rebooted in 2.6.23-rc2 an=
d=20
> > it is working for an hour now.
>=20
> It is not immediately clear what might be causing this, 2.6.23-rc3 didn't=
=20
> get any USB nor HID updates at all compared to 2.6.23-rc2.
>=20
> Could you please enable USB and HID debugging to see whether we can see=
=20
> anything spurious in the logs at the time the keyboard gets stuck?

Jiri,

I have enabled USB debugging and I see a bunch (=3D46) of these messages:

   [  $timestamp] usb 1-9: usb auto-suspend
   [  $timestamp] usb 1-9: usb auto-resume
   [  $timestamp] ehci_hcd 0000:00:02.1: GetStatus port 9 status 001005 POW=
ER sig=3Dse0 PE CONNECT
   [  $timestamp] usb 1-9: finish resume

The messages continued to be logged, even after the keyboard has
become unresponsive.

The entire kernel log is at http://iucha.net/usb/log-2.6.23-rc3-2 .
The dump of /proc/bus/usb/devices is at http://iucha.net/usb/devices .
The output of 'lsusb -t' is at http://iucha.net/usb/lsusb-t .  Plain
lsusb is not working.  The version of usbutils is '0.72-7ubuntu2' .

Do you need me to build a -rc2 with USB debug enabled to compare and
contrast?

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGytGzND0rFCN2b1sRAgeQAJ9kMdZ/JHKLcmA92O3NZFgOmiTm6ACfSMqp
MOFWmb9Va+Iu73oCRH92L0g=
=3fBl
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
