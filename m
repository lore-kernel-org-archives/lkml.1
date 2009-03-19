Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbZCST3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbZCST3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZCST3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:29:10 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZCST3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:29:09 -0400
Subject: Re: Required sequence to set wireless parameters?
From: Johannes Berg <johannes@sipsolutions.net>
To: Frans Pop <elendil@planet.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>, jeff.chua.linux@gmail.com,
       mingo@elte.hu, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, bunk@kernel.org,
       akpm@linux-foundation.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <200903192024.30562.elendil@planet.nl>
References: <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
	 <200903191602.58790.elendil@planet.nl>
	 <1237481630.5100.92.camel@johannes.local>
	 <200903192024.30562.elendil@planet.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZhM0Po8Oz/Os7hCPMZ+B"
Date: Thu, 19 Mar 2009 20:27:51 +0100
Message-Id: <1237490871.5100.113.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZhM0Po8Oz/Os7hCPMZ+B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 20:24 +0100, Frans Pop wrote:

> > > Reason I ask is that for example when writing wireless support for
> > > e.g. a distro installation system, it seems most logical to *first*
> > > ask the user what network (ESSID) he wants to connect to. Next to
> > > check if we can connect to that network without additional
> > > authentication and only then, if needed, ask for keys etc.
> > > If it's not possible to set that info in that logical order that
> > > seems rather restrictive to me and would probably mean that you'd
> > > have to reset AP, ESSID and possibly other settings before each
> > > incremental attempt.
> >
> > That's a pretty wrong argument, nothing says your software cannot
> > collect all the information and then give it to the kernel at once
> > later, I think... In fact, this is required anyway when you use RSN or
> > WPA (wpa_supplicant needs all information at once), for example.
>=20
> Well, the thing is that we'll already have tried just setting essid to=20
> check if it's an open network. However, I can see the point of needing to=
=20
> set the essid _again_ after asking the key info and setting that.

Ah.

> I can also see how you might have to unset some settings in some cases,=20
> for example if the NIC has already associated with the wrong network=20
> (e.g. because there's a totally open network in range).

No, there should be no need for that really, an
	iwconfig wlan0 ap any
should always make it associate with the current settings.

Now, this thread is about why it doesn't for Jeff :)

johannes

--=-ZhM0Po8Oz/Os7hCPMZ+B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwpyxAAoJEKVg1VMiehFYQjkP/34xvJY2NUEOLUvCMXlKzpIg
lAurmN3Cnn4u2jKBPO74QOi0m6/YEsms3et7kc1NNwqPXsvQ3rhJfQEfKUq1sh+O
PR3Go6eHy8IlayilTYDzgVIbsT9nCuSiVQs2u+YQ5OJA2aDHxW6z/3eYZrHE0fj2
dwHfRMpeF7aTemvxPKv1wF8YCrkWiVM3T741NxSp63AXYlBbZ5MQitHx1g4osvf2
vNWVI76xgQq2iTHfr8qPkA49rz4djWECahM4F/PEpbM89yV2OxsE8pH21dOB278D
Hb1CCTuLRZ+c2+srMGHUN8ApWC7QsaX4xAV/wSS2bzTkQSJm9m1RT3SAS8xpz6QE
VVZYsg4i7Dx6Zk/dbHAcw+ry1EuV7n4LFmpAXZqyzKOw2+LcMbl5dDLhOzMveevC
shyAPMgOwHkWZX6G8hgRypgAZL3bYffbh/zI2yfVBRONvlZE6ENztXxMT3ije5oX
KGb0xbO/tB/gEV/vzUl2wkoVNEmzoolcKzb6OIsrpRCEqXPYX6qVHaxByZAug6AV
OuMsTKB6MsxGpZoC55/oL3+YUGuiuIbnJOO86psQwKyrEDCqDu7GO4Kikq5lHaO4
JTOCKlxaXbuWzAnLanhSfQYyVXI6J/AleXiT2/i/SPG2l9HXH/r3YjU7Rj31MOQS
HxxiPDI4Py36hLMB63sf
=EFym
-----END PGP SIGNATURE-----

--=-ZhM0Po8Oz/Os7hCPMZ+B--

