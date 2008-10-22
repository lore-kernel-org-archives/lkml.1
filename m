Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYJVKif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYJVKif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYJVKiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:38:22 -0400
Received: from bioshock.netsplit.com ([89.16.172.233]:51606 "EHLO
	bioshock.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbYJVKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:38:19 -0400
X-Greylist: delayed 2900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 06:38:19 EDT
Subject: Re: [PATCH v2] add MODULE_ALIAS to load ipmi_devintf with ipmi_si
From: Scott James Remnant <scott@canonical.com>
To: Corey Minyard <minyard@acm.org>
Cc: Tim Gardner <timg@tpi.com>, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
In-Reply-To: <48FE3EE2.6040009@acm.org>
References: <20081021161536.D7CD65A15E@sepang.rtg.net>
	 <48FE3EE2.6040009@acm.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Fs0s2FKqjQH3fYHfRhql"
Date: Wed, 22 Oct 2008 10:50:02 +0100
Message-Id: <1224669002.8541.15.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Fs0s2FKqjQH3fYHfRhql
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 15:43 -0500, Corey Minyard wrote:

> Yes, this is certainly a good idea.  I'm not 100% sure of the string,=20
> but it looks reasonable.
>=20
The string matches the one in the platform device created by the ipmi_si
module for each device:

UEVENT[1224021721.100748] add      /devices/platform/ipmi_si.0 (platform)
ACTION=3Dadd
DEVPATH=3D/devices/platform/ipmi_si.0
SUBSYSTEM=3Dplatform
DRIVER=3Dipmi_si
MODALIAS=3Dplatform:ipmi_si
SEQNUM=3D2812

You also get an "ipmi_bmc.NNNN.NN" device, with a platform:ipmi_bmc.NNNN
MODALIAS, but it wasn't clear to me what that was.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-Fs0s2FKqjQH3fYHfRhql
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj+90oACgkQSnQiFMl4yK5jaACfXy3c/SrH2cTIrGH8Zug1ow8V
D74An0yVtDJr9zHjy1FIjZ+is3XGEsk4
=VFww
-----END PGP SIGNATURE-----

--=-Fs0s2FKqjQH3fYHfRhql--

