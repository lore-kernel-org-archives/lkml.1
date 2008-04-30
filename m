Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbYD3IXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbYD3IXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYD3IXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:23:11 -0400
Received: from systemlinux.org ([83.151.29.59]:34079 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbYD3IXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:23:09 -0400
X-Greylist: delayed 1486 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 04:23:08 EDT
Date: Wed, 30 Apr 2008 09:58:08 +0200
From: Andre Noll <maan@systemlinux.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [00/37] 2.6.25-stable review
Message-ID: <20080430075808.GB23944@skl-net.de>
References: <20080429171730.GA14724@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:17, Greg KH wrote:

> This is the start of the stable review cycle for the 2.6.25.1 release.

Neil sent out the following patch for md which is not contained in
the list.

Please consider adding it to the list.

Thanks
Andre


=46rom: Dan Williams <dan.j.williams@intel.com>

rdev->mddev is no longer valid upon return from entry->store() when the
'remove' command is given.

This should go in 2.6.25.stable.

Cc: stable@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:50.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:55.000000000 +1000
@@ -2096,7 +2096,7 @@ rdev_attr_store(struct kobject *kobj, st
 			rv =3D -EBUSY;
 		else
 			rv =3D entry->store(rdev, page, length);
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(mddev);
 	}
 	return rv;
 }
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIGCaQWto1QDEAkw8RAkxbAJ4xY06pVFRK/8cMLXadpC1NMb+uWACdG42i
H+q2I80yG61Y2PbW4zD+r6U=
=2KxL
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
