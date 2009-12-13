Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZLMNOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZLMNOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZLMNOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:14:12 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:59394 "HELO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752643AbZLMNOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:14:06 -0500
Subject: Re: 2.6.32-git5+, CONFIG_WEXT_PRIV and Broadcom's driver for
 BCM4322  Wireless chips
From: Johannes Berg <johannes@sipsolutions.net>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <5a4c581d0912120740j38a20f8eu3f616f3a477d922f@mail.gmail.com>
References: <5a4c581d0912120740j38a20f8eu3f616f3a477d922f@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wkhPQRTd0KRkgvOFmC/2"
Date: Sun, 13 Dec 2009 14:14:02 +0100
Message-ID: <1260710042.2442.340.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wkhPQRTd0KRkgvOFmC/2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-12-12 at 16:40 +0100, Alessandro Suardi wrote:

> But: what is the best option here to make CONFIG_WEXT_PRIV visible at
>  kernel build time if only an external module should select it - but sele=
ction
>  is not actually happening at kernel build time ?
> Could CONFIG_WEXT_PRIV be made a separate user-selectable option ?

Your only option is selecting some other (ancient) driver that selects
WEXT_PRIV. We will not make that Kconfig symbol visible just because
Broadcom decided that they want to continue screwing their users :)

IOW -- there's no such option available to you at all. Select
PCMCIA_RAYCS or whatever.

johannes

--=-wkhPQRTd0KRkgvOFmC/2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJOiVAAoJEODzc/N7+QmaxOIP/1O6lcOyXLU5T/jq8NDqD7At
3Txb995jr84fEviZ28rE6WpclvatmXB9TGXOYiQrbVRCPEZtwGA87+KRRZezKc8M
RZn+xNaUE0UOyBUzb+9Ubd83msnqFhzZ3X9HFPSOV5NfbAyH2gbqjXke+rOUqvjO
80fbwjMhy5yf3klTN3UyI9/oTyXEfHkzZq1X45cJL283aFyYL1NLzawSD4yCTfHw
ZBqP1ZTDb/ewAf+dV+KHRf2iSU0G77+5KmOfKII1WFcv3Mb0SYWmQ0xuU0zZWNkK
LdSnpkXi0r7GgJvGAkJwReV9yaWbY8OOWdVwp3Hk0U7c6COggfGbX8PHvKD76V+M
YuzLdMO5XHpkiZ/gKt7J88iWHeogGrxsBvpxWt103/fTVNvoKQOo021PiiOB7pKL
40mX6HyLNbuV8f/TNulwUZ/l37NkxvMEE9rpcrKLU6DcHiZho2crvfI2XIWPaMOx
VI/HBK7mh29nP58m0jgQeDE2fF3MTqadTVapgX+YY1jsPbxgjpgNG4MtLtXdmrW8
3CB55GeIZ9d0GaxOoTH61Ry+xm2u/tLz/Zh95pyvQxey3gnhpDT6v7MCxDyJhy1J
8Ctm73cmtIbokSW251A5xX+Z3HAUBW+yIts2hTpneVLm3F3rvC0qCFWa60UxmX90
qVD2WXkpISCNaR4+FU8l
=7LY+
-----END PGP SIGNATURE-----

--=-wkhPQRTd0KRkgvOFmC/2--

