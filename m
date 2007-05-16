Return-Path: <linux-kernel-owner+w=401wt.eu-S1762878AbXEPUXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878AbXEPUXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXEPUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:23:18 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48819 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942AbXEPUXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:23:17 -0400
Date: Wed, 16 May 2007 13:24:50 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
Message-ID: <20070516202450.GG9936@tree>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com> <464AB9B0.9070205@garzik.org> <20070516010459.0435d71c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H4SyuGOnfnj3aJqJ"
Content-Disposition: inline
In-Reply-To: <20070516010459.0435d71c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--H4SyuGOnfnj3aJqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 16, 2007 at 01:04:59AM -0700, Andrew Morton wrote:

> > Looks like SAS needs to require CONFIG_ATA...
> >=20
>=20
> Yes, but it seems wrong to disable all of libsas if !ATA.  Only sas_ata.o
> should depend on that.
>=20
> Darrick, is there any point in me carrying this tree?  It doesn't appear =
to
> be a hotbed of activity...

Nope.  I haven't worked on those bits of code in quite a while, since a
number of scsi/libata reorganizations were discussed at the storage
summit that would make a fair amount of the sas_ata code unnecessary (or
candidates for reworking).

--D

--H4SyuGOnfnj3aJqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGS2iSa6vRYYgWQuURAglTAJwK0rSgfSrJHmiTYWgi/A3Eh5EHoQCfSX59
C/y5rsv98kr5/WGLsGG5Rzc=
=ePm8
-----END PGP SIGNATURE-----

--H4SyuGOnfnj3aJqJ--
