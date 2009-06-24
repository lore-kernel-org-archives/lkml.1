Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbZFXVff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbZFXVff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZFXVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:35:22 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:47542 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbZFXVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:35:22 -0400
Date: Wed, 24 Jun 2009 18:35:23 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org, oliver@neukum.name
Subject: Re: [PATCH 2/3] Fix oops when closing ACM tty device right after
	open has failed.
Message-ID: <20090624213522.GH5299@vespa.holoscopio.com>
References: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com> <1245843077-4442-2-git-send-email-cascardo@holoscopio.com> <20090624204106.GE28516@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ISKrrfpKsPiF35CV"
Content-Disposition: inline
In-Reply-To: <20090624204106.GE28516@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ISKrrfpKsPiF35CV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2009 at 01:41:06PM -0700, Greg KH wrote:
> On Wed, Jun 24, 2009 at 08:31:16AM -0300, Thadeu Lima de Souza Cascardo w=
rote:
> > This commit 10077d4a6674f535abdbe25cdecb1202af7948f1 has stopped
>=20
> Please don't reference git commit ids that are not in Linus's tree, as
> it doesn't make any sense to anyone.
>=20

It is in Linus's tree. git log torvalds/master..10077d4 gives me
nothing.

cascardo@vespa:~/linux$ git remote show torvalds
* remote torvalds
  URL:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/

> > checking if there was a valid acm device associated to the tty, which is
> > not true right after open fails and tty subsystem tries to close the
> > device.
>=20
> Why would open fail?
>=20

Explained in a second version submitted already, but basically because
there's no such device.

> thanks,
>=20
> greg k-h

--ISKrrfpKsPiF35CV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpCnBoACgkQyTpryRcqtS19nwCfT0m0PVWXDkquc7OiMX6yrpvI
3JQAn2J026LRRI1Lunmw4lZQ7TUgoTO0
=y/wQ
-----END PGP SIGNATURE-----

--ISKrrfpKsPiF35CV--
