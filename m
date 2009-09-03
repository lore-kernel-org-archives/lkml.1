Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZICN2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZICN2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZICN17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:27:59 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZICN17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:27:59 -0400
Subject: Re: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20090903122727.GA4465@matterhorn.verdurent.com>
References: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
	 <a32f33a40909030454y51905525g15a65cc8364b8eb5@mail.gmail.com>
	 <20090903122727.GA4465@matterhorn.verdurent.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UmUxuO13z/WtU84s0z3I"
Date: Thu, 03 Sep 2009 15:27:35 +0200
Message-Id: <1251984455.3336.24.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UmUxuO13z/WtU84s0z3I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-03 at 15:27 +0300, Amit Kucheria wrote:
> On 09 Sep 03, Ivo Van Doorn wrote:
> > > USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it i=
s already
> > > defined. Remove it from rt2500usb.
> > >
> > > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> >=20
> > NACK
> >=20
> > Users have reported that this is a valid rt2500usb ID. You can thank th=
e
> > manufacturer of the dongle to produce dongles with the same USB ID but
> > with different chipsets.
> >=20
> > Ivo
>=20
> Interesting. On my laptop, without this patch both the drivers are loaded
> (lsmod), rt2500usb aborts without allocating a device successfully but I =
am
> unable to associate to the AP.

Sounds like the detection logic is somehow messing with the device, or
rt2500usb isn't actually freeing the device for rt73usb to bind?

johannes

--=-UmUxuO13z/WtU84s0z3I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKn8RBAAoJEODzc/N7+Qma4gAQAKXh/jjxoFltEjuJFDfVTnHk
6j0Rgcbg+1zFXB1MzffNduRIkqE+8ZPIUORpyLfpFDD3H69RxP4wgEbcqlzmptaL
Sik3ClK9//J7revTMHwhzNVnLODiTJOa3MYqTWDFEAHsezlSY0PMpdCxKgv92SCD
hz+dAZySzHsiSYShLrf6NcI4nbDDxmt+jfwjNaVFHRwN8pRwmnxoKg+uIs0YqB8d
4IuX9xnbre414ffV/vC0klB57V/6a6s4qad+ZPqNJIwp1TyE5VGpXfiGXwbJX4Ka
72Pox2/AGQu0iLxdu3NyBekOTHmyp2kQ0D4KyA3onIhx0c9grZHYFETucrxcLus5
fTAXwDSTGEKbVyCiPNWA5DZVVCNnc0tL82JCARDZI5pt9x3HkxyiF3Cez4s+dKx4
dLd+N2I+/0QBxp7dhXyw0iZlbj/wtrY4zE9KaUJP1KM1cC+gxuGd4TQSLch4tho1
Nxs7ojxvTNOuZ9NP/8wM0uruRWxU/wy4xG1QpUtpi2byRwW9J49QGERtxkPO6Dta
dalhi9VwWQZ+9Wak5Hes4bwzR4ntViGfsQkfBW2rZIqPdscYrV7utLhBVTPt9V8t
UbhRaIxaHh8YIUqCJzByIoyIOGoa5J6q9EWhH99paJNoW5UpJKos83BR0vTDZCju
OLWPDe1MqVGRFOcarm8r
=TUqu
-----END PGP SIGNATURE-----

--=-UmUxuO13z/WtU84s0z3I--

