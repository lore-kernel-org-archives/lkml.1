Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZLWTLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZLWTLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZLWTLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:11:33 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:33202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZLWTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:11:32 -0500
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend
 issue and mac80211 suspend corner) case
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
In-Reply-To: <20091223190840.GI2609@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
	 <20091222193010.GB30201@bombadil.infradead.org>
	 <1261570081.25008.1.camel@johannes.local> <20091223162813.GB2609@tux>
	 <1261586828.7304.13.camel@johannes.local>  <20091223190840.GI2609@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NHjkRrkRgTDekm1uhOE3"
Date: Wed, 23 Dec 2009 20:11:29 +0100
Message-ID: <1261595489.27798.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NHjkRrkRgTDekm1uhOE3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-23 at 11:08 -0800, Luis R. Rodriguez wrote:

> So you want drivers to handle start() failures (even if its not for
> resume) with an unregistration to mac80211?

Not necessarily. If it's a temporary error, that's fine, of course, but
if the hardware is suddenly inaccessible for whatever reason then yes,
of course, unregistering is the only good choice no matter when it
happens.

johannes

--=-NHjkRrkRgTDekm1uhOE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLMmtcAAoJEODzc/N7+QmaslYP/2Yqd0Br00j0+ghZCj571DFK
NRBrmWPLm3GadH7ZXFBG7PBtSkzZzbwHbP6xNp4Js21CR6ZWMX0WSLV0exFf6UMZ
CUYVQpiiU1bGfDIxTGXtwgTPE5/Vt3gTVZkONZ2Ii5FTxxygsrKk4SloCo54y+4y
7GYJwXhy92dX/3ZqPw1uCwp8NClowbFzNFKLjvmRNDSSQY5Hm9Y9HQTqqOVI6aN5
/nfREiqIbjRgY1rucpX2Cf8ol/jpcvUXvz/5KP8PlJlCBs71MpkKBr2Kx9/C1iOh
unTAwR9QpIb7yWZxjKwaogDAWWOWvMrPpW2XMuFfqx66InPPjtnX2W6lHqp+RUml
nZpztCrw5RzUeL+gQuQZfhVsFN1c1uagl8qfsGEaJnO6iOEr4dZWFOnW0ehUxkLg
k0+IVdY/M2lxoZJ9qUOTPO9SuVdFw7CjdkGKuJniDmXoP6uewmGw0BYlWi6Prpnb
diEKO/dA9XwBxwTzKt/PaUivo/akjQcJFhXgWuiGd4RLQm1nKyIv6wDxMYW0d9yn
LxQzS8qrxXSktej2m25fHJm5Fg+BeWx+yo6rZckWN2Gbz80V6hVa40DJYzIvJtbs
UMZrObXnU+7i7xbF6ZiUuFrR4BaP/xqbJF8igMXhr7FIw3fwjVWdyH06lxmXkBeX
VVjdd6uU5VDNTk9/srVe
=Iljo
-----END PGP SIGNATURE-----

--=-NHjkRrkRgTDekm1uhOE3--

