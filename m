Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZJQWBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZJQWBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 18:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZJQWBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 18:01:03 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZJQWBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 18:01:01 -0400
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091017183320.GF16532@elf.ucw.cz>
References: <20090929171249.GB14405@elf.ucw.cz>
	 <1254431783.3959.45.camel@johannes.local>
	 <1254432469.3959.46.camel@johannes.local>
	 <20091017183320.GF16532@elf.ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tnRoSLjxL8TdRps0VU97"
Date: Sun, 18 Oct 2009 07:00:57 +0900
Message-Id: <1255816857.3434.3.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tnRoSLjxL8TdRps0VU97
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-17 at 20:33 +0200, Pavel Machek wrote:
> On Thu 2009-10-01 23:27:49, Johannes Berg wrote:
> > On Thu, 2009-10-01 at 23:16 +0200, Johannes Berg wrote:
> >=20
> > > > wlan0: Selected IBSS BSSID 02:18:41:de:3f:02 based on configured SS=
ID
> > > > wlan0: Trigger new scan to find an IBSS to join
> > > > wlan0: Trigger new scan to find an IBSS to join
> > > > wlan0: Creating new IBSS network, BSSID f2:d3:80:82:ed:6a
> > > > wlan0: Creating new IBSS network, BSSID 52:17:bf:45:d6:9d
> > > > skb_over_panic: text:c07b4113 len:130 put:36 head:e4c3edf0
> > >=20
> > > This entire log is very odd ... can you reproduce this easily? printk
> > > timestamps would be useful.
> >=20
> > Kinda looks like a race condition, but it's rather odd. I think there's
> > a race condition, so I'm going to submit this patch regardless after
> > some testing, but if you want please try the patch below.
>=20
> Well, the problem is not exactly reproducible... it failed to happen
> again. So... thanks and I'll keep my eyes open if it returns.=20

Felix also found a bad condition (inverted) in the adhoc code, so that
might be related too.

johannes

--=-tnRoSLjxL8TdRps0VU97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2j6TAAoJEODzc/N7+QmaFooP/A/rbGa2s7/puW5Wy6p1pY4e
0R6IHrP1aNc/DXrJ5MpPBozD6R+qcEQveQKKlcm3MFLZ0ccZoIkhGhwlYHg+9cmB
7XlQ/je+OmP7TnZdKNypGuraBsuFITdYGeX++cCFC6BTbq0uToGJea7dtrnq6zgU
IrkzKETCUwvk6P/AQhex+yhi3bXiUpmtNpWFKKmLykiY+c3BpqJvqr69K/4cLKJa
iTVe428VDcvnTqtuvNf9JIjw7yk49o79QVz1aEnYCiCWHTyVcJfVu5/7DcFXnYUH
UmRfmSJhdfwbrlagnse+yt+XQaojPDAskKdujqR/r3PlBQOnfK9gkcGL3wKPN8we
SpVBhVCnpS2h32PNSunETZFYRM+OH//O48e3b7PTPVv9IRBqY8hkQOCOKOdzM+lS
vxn2UN8DRGHtLD2DCfTCZZCKFwyRgoqzjxEP8+UrZZFQrcbhMektm66czuC48blr
zoFjPLCgFNZCf2yQghpyxFmqKtR4vQ72XbRzU2e0BeDkF9Jn1AjhVgNO0MnwFbTK
Q+MuOiag9c8V98zWeLyOcfdr+yExujY6GdL5cCDU/8P4pIosNiZK93MMtCw9NRes
HDdJa3qX1GbzEaBLBvGW4N4mX6BhgMj5+eOKmxLKs+GdpqwZArGm/tgk/pFMNs+h
pO7sbZp78aUum+W9JWGI
=+yOS
-----END PGP SIGNATURE-----

--=-tnRoSLjxL8TdRps0VU97--

