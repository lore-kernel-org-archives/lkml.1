Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYEYOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYEYOWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYEYOWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:22:38 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYEYOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:22:38 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Michael Buesch <mb@bu3sch.de>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1211725128.31212.108.camel@shinybook.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211707837.17151.14.camel@johannes.berg>
	 <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
	 <200805251405.05684.mb@bu3sch.de>
	 <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org>
	 <1211724803.17151.36.camel@johannes.berg>
	 <1211725128.31212.108.camel@shinybook.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j4U6r/CI7owSM/0S/3S6"
Date: Sun, 25 May 2008 16:22:16 +0200
Message-Id: <1211725336.17151.39.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-j4U6r/CI7owSM/0S/3S6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-05-25 at 15:18 +0100, David Woodhouse wrote:
> On Sun, 2008-05-25 at 16:13 +0200, Johannes Berg wrote:
> > If Michael wants to serve his firmware blobs from an SQL database,
> > he'd use a simple table like this:
> >=20
> > CREATE TABLE firmware (
> >         ID INTEGER,
> >         name VARCHAR(100),
> >         data BLOB
> > );
>=20
> That's fairly much what the in-kernel firmware support does (just
> serving firmware from a flat table using the string as a key, that is.
> If I tried using SQL in-kernel you should take me out back and shoot me,
> of course).

Yeah, and only that makes sense, if you ask me. And as you said in the
other mail, adding a module name disambiguation policy in userspace
would mean that two different modules would be allowed to both request
the firmware key "foobar" and not have a problem, while it would be
pretty hard to support it with the built-in firmware option.

johannes

--=-j4U6r/CI7owSM/0S/3S6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDl2F6Vg1VMiehFYAQKPqRAAlo03ATGV3XCq9J5ysxwqOoy2Qfd06uWB
iSWXXOw2ce0BG2o814M8d2MakFlYHjubZMvkmLDdKai6heVd8FJ9BJptttRKzZ5t
1h5U/IUvc3koVfbzr+ItG5/uaJTPF7OSzy0mZbjpEPxMuJX+Bsyw0zZzLm3gzemu
ezzufyW4Gprmu12mz/YY/goMNApv3TTJB5nvccCW4N4S0N5fU7oWyukueuaOVB8W
WxDRkuYU5SyvmDH/1fKALUJkNU6cbo3Ag+HipIJqDgmb9LW13cGJMWhO35r5WEc9
nLUQmfHldwU0Vu/yCJE7+Cq844f9nOBtTbYx64aK45kbwj4817npNaH/KScy0qOe
PoewjPYL3TJKLjBp3lmSUqZVAvj4oLUJ2BXO3/Dwg4lQZwZsyrPq5QHuu+Liv3jO
qEj5eIIQgzZtvdlc1FE2yI9yAtcmxvR/YXOywfbl6FtlUi2Ii4nekraIkwfH4aul
NdEwUS8cimmggklBIiKmCCAr3avd+LLGU8E5/we32NPJ9c/hLv8fDHgbt2BzJX0R
53QOeUx8TFfSXb5Wdkne+mlkSdQBM8h+6lRD8x8iDk/XfKrUKgo01MY1tgoVtyQB
SIjFPwwxWWnMm0oWlMFHEaaYmprn7xzJChNDxdLmhq+hipZyE28Qs5psIS3DWIr4
0GyEvxdAesA=
=2s6Q
-----END PGP SIGNATURE-----

--=-j4U6r/CI7owSM/0S/3S6--

