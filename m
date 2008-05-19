Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYESMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYESMSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbYESMSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:18:41 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbYESMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:18:40 -0400
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, netdev <netdev@vger.kernel.org>,
       Jean Tourrilhes <jt@hpl.hp.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1211117795.686.15.camel@localhost.localdomain>
References: <1211026337.3827.25.camel@johannes.berg>
	 <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
	 (sfid-20080517_154639_384202_6D3479C2)  <1211032475.6252.2.camel@johannes.berg>
	 <1211117795.686.15.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2UPt4qKi1GJIRJ0lv493"
Date: Mon, 19 May 2008 14:16:08 +0200
Message-Id: <1211199368.6252.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2UPt4qKi1GJIRJ0lv493
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Instead of testing for wireless/, best thing would probably be to call
> SIOCGIWRANGE on the device and if it returns EOPNOTSUP then it's not
> wireless.  Some drivers may have to load firmware to figure out
> supported rates and encryption capabilities, but to be honest, NM does
> this to detect wireless devices and I haven't run into any issues in 4
> years using it.  If there are issues with drivers, then we need to fix
> the driver too.

I was about to propose calling SIOCGIWNAME since that is what
wireless-tools do and that linux/wireless.h indicates.

johannes

--=-2UPt4qKi1GJIRJ0lv493
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDFvh6Vg1VMiehFYAQJKwxAAxJfeWZ6v5iO3NVKN7OZjWGU/2UeLhwUI
r603e7JOqfCIfBVBvmtHeOOmdSfon4KPAHg/MJPv7dVZEtuWN6iRGfeAHfYWHeee
MUj/jQl1uvj9Pya2MGsBB9MM5te85bvha2bCNEOsTPfcggIkDInzvQ89P1+8CdUy
o/1dk3b56Os4L4jWVyLpttm0QSZ5tKgXfqnKoDSf7KFMfBTktWu9icQaLddwkwSr
lGE+HJyx6a6SMycPO5H2oH3rtCv7hv5CLig7vL1mMruPLdelHd7jgUwAi2qSRJG3
MP8DwS5V8JkzEaSqvPGEqCcU9JcMr71nvWdG0+JhTdQIFzg3mjD7BOI0yD4oUdYQ
otCkmulKr0tEpKiOC13FidNd/J8MHfW+v5TWOJk1n7TVWDJPobCVy9i0EE3NLWlb
ItyZ8beEhq02ZK58F3S+GDIG0q7zxuwDvQGbSpExv35UA325hU8EyhZbSZ57rpro
IkiGYz28OFhvSgbjh4KyMj1MRskrh/s+UEq2OzamwhrLU8Qi2OHY/7HbLNxhthLo
hnmod+3SAuYIwn7y3nq2YO9nMJ84HkSM9I3LRf4mM8y8r56LwN9IbmHFgttLGvY7
LznGs0HPgIMReV2cDBXxqgGayNb47oPmkTNxYZFUGArk2/EDbHS9dJfepzrry+rA
XnZILSbWi1w=
=2st1
-----END PGP SIGNATURE-----

--=-2UPt4qKi1GJIRJ0lv493--

