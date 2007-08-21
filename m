Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbXHUNSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbXHUNSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 09:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXHUNSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 09:18:01 -0400
Received: from iucha.net ([209.98.146.184]:59649 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758831AbXHUNSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 09:18:00 -0400
Date: Tue, 21 Aug 2007 08:17:59 -0500
From: Florin Iucha <florin@iucha.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070821131759.GI10422@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz> <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net> <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKYYegg/GYAC5JIZ"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--TKYYegg/GYAC5JIZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2007 at 03:05:25PM +0200, Jiri Kosina wrote:
> > I have rebuilt 2.6.23-rc3 with 'CONFIG_USB_EHCI_HCD=3Dm' and=20
> > 'CONFIG_USB_SUSPEND is not set' and will use it for a while, to see if=
=20
> > the keyboard/usb behaves or not.
>=20
> Thanks. If this doesn't give us any hint, it would be useful if you could=
=20
> do git-bisect between rc2 and rc3, I really can't immediately see anythin=
g=20
> in the list of commits that might directly cause the behavior you are=20
> seeing (most importantly because there were no USB and no HID updates in=
=20
> this window).

The keyboard still locked up.  There is absolutely nothing in the
kernel log.

> There are approximately 290 commits, so it shouldn't require more than 9=
=20
> reboots plus the time needed to check whether the bug triggers or not.

The top commit is not v2.6.23-rc3 but

   commit 28e8351ac22de25034e048c680014ad824323c65
   Merge: 3b993e8... d18c4d6...
   Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
   Date:   Tue Aug 14 10:00:29 2007 -0700

       Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-f=
ixes

I'll try to make time to bisect it...

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--TKYYegg/GYAC5JIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGyuYGND0rFCN2b1sRAuU3AJ40id1ghVbsYjp4RPyih7jKm991QgCfaepq
LhQ0wTHPI3ermlhZZeoVLAw=
=Z9t0
-----END PGP SIGNATURE-----

--TKYYegg/GYAC5JIZ--
