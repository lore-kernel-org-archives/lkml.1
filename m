Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZFDOPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZFDOPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZFDOPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:15:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZFDOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:15:44 -0400
Subject: Re: [PATCH 03/10] net: add IEEE 802.15.4 socket family
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       slapin@ossfans.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
In-Reply-To: <bc64b4640906040710p5c7c941fi3341599bc3157b79@mail.gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-2-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
	 <20090603173214.6d3997f7.akpm@linux-foundation.org>
	 <20090604111634.GA28064@doriath.ww600.siemens.net>
	 <20090604134455.GB2839@tuxdriver.com>
	 <bc64b4640906040710p5c7c941fi3341599bc3157b79@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LKnVfcSf/rHg6h/hVnUR"
Date: Thu, 04 Jun 2009 16:15:36 +0200
Message-Id: <1244124936.22576.73.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LKnVfcSf/rHg6h/hVnUR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 18:10 +0400, Dmitry Eremin-Solenikov wrote:

> We do try to fit the lines into 80 chars, but when that seems logical.
> I strongly dislike breaking comparations between lines.

There are a whole bunch of improvements possible at this particular
spot:

switch (X) {
case Y:
	if (A) {
		...
	}
	break;
...
}

can be written as

switch (X) {
case Y:
	if (!A)
		break;
	...
	break;
}


and=20

for (...) {
	if (A) {
		...
		break;
	}
}

can be written as

for (...) {
	if (!A)
		continue;
	...
	break;
}

etc.

Show some creativity!

johannes

--=-LKnVfcSf/rHg6h/hVnUR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ9cFAAoJEODzc/N7+Qmai7oP/jQyakMgyacJhwCi/6ITCkJi
Dou+6CfcmXfXiCAJUKfLz/VWwjjgfSPrHnfHGCOXdS1ZLDoN6TD+VOz8mJUkvMFh
f2UUIXcRFmuSinLuXbql1tUDnAQ/lWAt/Y8zjp/XdeFAd1f1CxUdqQjd5jgDlcqR
23td+LIoEGedejRvxJKl+j7z8qqgAy49Bo0xNnbJ7GpFJY9OoYLvdVVIDJ2dkkKo
zkYK3wg2CLZcke/VB9H4+2awSC61H52ad0iVkgRatXIQXl7DmBqx6PZRn0c2R705
PFaM8bC8m4TKKcOSzZSbv0+v8Uy5euTXgUSidJJHVdJPeLacOLX4DV6isgOGATZ+
0uNELJQ485xbRORO+uTxW07NcMrL2quGAVk+RucQKkuucyNbqNPDQLhEuucc9O0u
DVFGyRyXlnmaR6FZXpiuf//NywIzmYnCBHvuKQx9qGO3A5SFSJOL6CZOsASRR0nh
RKHXhP4lBcVOm5ESJGxvHppLS1S4G87nj/EeGJOfvuwYd0DeIEQ8Os5apImSvUka
QNmY9vyMbpB/it2FZva/8vLPyIIHgRXYgxti4HkdxpiYStwMWzQDG4yyRzee8bmD
YnY25NrBkCt49gS+eBt4qRqHcrU/5d5EOwScWHx+vD4myPCG5KnWjtqCOKtGxss5
0z8tf4nIiU4lv3v+aqoQ
=lsIx
-----END PGP SIGNATURE-----

--=-LKnVfcSf/rHg6h/hVnUR--

