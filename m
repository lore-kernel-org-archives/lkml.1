Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYEQNzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYEQNzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYEQNzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:55:25 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYEQNzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:55:24 -0400
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: netdev <netdev@vger.kernel.org>, Jean Tourrilhes <jt@hpl.hp.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org> (sfid-20080517_154639_384202_6D3479C2)
References: <1211026337.3827.25.camel@johannes.berg>
	 <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
	 (sfid-20080517_154639_384202_6D3479C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eQT+wYqySa7VBCfpCOZp"
Date: Sat, 17 May 2008 15:54:35 +0200
Message-Id: <1211032475.6252.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eQT+wYqySa7VBCfpCOZp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-17 at 15:45 +0200, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> > The /sys/class/net/*/wireless/ direcory is, as far as I know, not
> > used by anyone. Additionally, the same data is available via wext
> > ioctls. Hence the sysfs files are pretty much useless. This patch
> > makes them optional and schedules them for removal.
>=20
> it is used by HAL to classify WiFi network cards as net.80211 instead =20
> of net.80203 and so we do have an actual user. However HAL only tests =20
> for the existence of the directory wireless/.

Oh, ok, I didn't know that, thanks.

> Please fix HAL first before submitting such a patch.

Sure, I'll take a look at that.

johannes

--=-eQT+wYqySa7VBCfpCOZp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC7jmaVg1VMiehFYAQJU7Q//dzg2z8o2MoN9NDpNTsy6AXspidCEExDl
HLAipu/S95C/rZmjPOEobGUMJgFj01gUSLNXgByh8Te3RyayfnB4rEQeqhwZ0Hqn
G6p8LYcB4xmL+PO8EV5TNxEq2w8a4pmlFGRu5onxlOWnlJDcJHvlGBfNoQbfQtJm
ppmRSsddcdJtV7dznLRJJ/KM3TEDiNpmjRdKRbmBBUsZn105ftj7N6F7ulBBD5Ep
ogVUfJYAU0lCD78OAw/hNR0dOYtsFMVR9SGmqVFOvO1YtaPJ8vXCT6Ft0a0ieGnB
GgP1oCBQaXwIolYYn/1VKNDE5si7J0HFXxistDf1TtFiIJyldnxOXYSGcCDKXYl/
yd0ecd4kmySlJsT/Y8b/7LuR3OOckrdCg/B3VWoWdHtoO3Pcewf5YZ1OBb70l1l5
E1a2a8GwMEVQ5E9tJOBkKlRv3owIUNf1DAvU09K09DydCyxgOFZAkUTbOKn4b1MY
AH/wvkQgO1lKn1LOQCMqm1412MJewrUWCycmlxGCJLrtOoUfEGseZt0WlagH609b
ka3njAZX8tWdOBlvF30wtk2s7mXYZuK/nr5tMY+8UA0I+HJKi/NXV0k23L/KqzFE
FTVIKCz1qCU8RraThn6+dTZyysG9FCDKvwB2n3DPHiYVy3JE1lzphTOJJfiqesgE
QP5Lgo/TzWo=
=HnoH
-----END PGP SIGNATURE-----

--=-eQT+wYqySa7VBCfpCOZp--

