Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbYA3QwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbYA3QwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYA3QwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:52:13 -0500
Received: from hydra.gt.owl.de ([195.71.99.218]:37805 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbYA3QwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:52:13 -0500
Date: Wed, 30 Jan 2008 17:49:20 +0100
From: Florian Lohoff <flo@rfc822.org>
To: linux-kernel@vger.kernel.org
Cc: marcel@holtmann.org
Subject: [2.6.24] bcm203x bluetooth dongle does not work
Message-ID: <20080130164920.GA15071@paradigm.rfc822.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
Organization: rfc822 - pure communication
X-SpiderMe: mh-200801301741@listme.rfc822.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

after trying around with my ancient bcm2033 bluetooth dongle i found it
not working in 2.6.24 - I debugged udev and found it loading the
firmware correctly but the device seems to have problems disconnecting.

I found an Ubuntu bug which mentions a patch which supposed to be
2.6.20 material. It still applies and fixes my problem:

Ubuntu Bug:
	https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/85247

Patch:
	http://launchpadlibrarian.net/7058766/bcm203x-2.6.20-backport.diff

So it seems this patch never went in but most likely should.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHoKqQUaz2rXW+gJcRAtwaAJ9NphT/yzdqC5jQN6AVrRdr/YdTFACeMmkZ
Dprm/CqdLam0Jaf16FK3NVU=
=hc7W
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
