Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZICIuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZICIuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZICIue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:50:34 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbZICIue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:50:34 -0400
Subject: Re: Staging tree status for the .32 kernel merge
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
In-Reply-To: <20090903041429.GA29875@kroah.com>
References: <20090903041429.GA29875@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AZ/b5nTNm6R3On9Aa0D2"
Date: Thu, 03 Sep 2009 10:49:46 +0200
Message-Id: <1251967786.3336.19.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AZ/b5nTNm6R3On9Aa0D2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Greg,

> 	- rt* wireless drivers.  Bart has done amazing work merging all
> 	  of these together into something much better than they
> 	  originally were.  And even better, they still work!   Great
> 	  job Bart!

Work on the rt2x00 project has also progressed to a point where the
drivers are getting much closer to being useful, so eventually all this
work will have been in vain.

> 	- vt66* wireless drivers.  These VIA drivers are being actively
> 	  worked on to get into a much better shape.  Nice job.

And do they come with their own wireless stack too?

> 	- otus.  This is sitting here until a "real" wireless driver
> 	  will be merged through the wireless tree.  Hopefully that
> 	  happens soon.

ar9170 has been in for a while now, it's just not quite at feature
parity yet -- however that also means otus will get no work whatsoever
from any of the wireless folks. Draw your own conclusions. Personally, I
would drop it and let the users figure out whether they can live with
ar9170 or need to support work on it.

> 	- agnx wireless driver.  No one seems to care about it.  If no
> 	  one steps up soon, it will be removed in .33.

Never really worked and the reverse engineered (!) hardware specs are
incomplete, with the main developer having given up. I think it's fair
to say that this is a dead end. I suspect the hardware isn't even
manufactured any more, at least I haven't recently seen it.

> 	- at76_usb wireless driver.  Again, no one working on it, it
> 	  will be dropped in .33.

There's at76c...something...-usb now, with a situation similar to the
ar9170/otus one.

> 	- stlc45xx.  Another wireless driver that no one seems to care
> 	  about.  So sad.  I guess no one will miss it when it goes away
> 	  in .33.

p54spi has gotten probably 95% of the functionality of this, so it's
only really useful for looking at the calibration data loading on the
N800/N810 platform...

johannes

--=-AZ/b5nTNm6R3On9Aa0D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKn4MnAAoJEODzc/N7+QmaP1kQAMePSWRpjuPFPwCa5eKeySeb
UrGJbq/vYj73cmiKse2Zgb1eRqCpq3LAbbZreHrU5fTYYuc83DcbMJ1WELDMbX83
Vbe7t6PLMgEhJyDVJr/Lj4b/GBV8zy1lc375oIe3XFszaSLpMb3auDExe1ZxiJDE
XwhjwIqBgZ0pG7yDncu4kWrxHL42ylxCzIaItt7j1v8F8BiA8uMjlFqdVOEPpWkY
y98XtYtObrPxQ44KvP3qtt81/wmk1CjQ40Wupm9FjDmex2kAOkYqAB77zSRAQsrA
Bu7h2q3mIaYD630EvMtJP1SbRQQJKu7iFESkwXZtTeKt8YKoyyQbMFZ1zRnO/lrm
2jGmfha+eMxXJZ0RhdilvhdpEpkm5Q7nFxr1aLiMkQvTmuwqJzhf9vP8544qBPKA
T8jvPm5jGdRzJMfROs0Z4XCUbAktuDJWwhuvbiGX6Wkx1xzepAPfxXDERgO1TZ1i
i8qbzAPm2WcYwtaL88jzVGgWegVS6IqOGMbV6H3M1km8jYtMYB/kd4PYtQ/OUOJs
6+DI7HlBsKscp6R4ra+kep9q7nXctca8MPrgjwpICVM5Xw22gxxDT34bA8eaKtC+
C6fZa+d5dvUjiEe7xhp7ly8YMXpinlE1R2pqrPP6WJd8JtDdvPjKnq4aGUzL3kLq
HADZZfIQltZlXB8C4GNJ
=tDgz
-----END PGP SIGNATURE-----

--=-AZ/b5nTNm6R3On9Aa0D2--

