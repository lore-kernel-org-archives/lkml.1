Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbYJROGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbYJROGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 10:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYJROGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 10:06:38 -0400
Received: from metropolitan.anduras.de ([80.237.200.159]:42843 "EHLO
	metropolitan.anduras.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYJROGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 10:06:37 -0400
X-Greylist: delayed 1914 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 10:06:37 EDT
Message-ID: <48F9E5EF.4080806@anduras.de>
Date: Sat, 18 Oct 2008 15:34:39 +0200
From: Sven Anders <anders@anduras.de>
Organization: ANDURAS AG
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: appletouch regression
References: <f488382f0810180552w2078244eiaed1fa100ad4c4c6@mail.gmail.com>
In-Reply-To: <f488382f0810180552w2078244eiaed1fa100ad4c4c6@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig46496E32A9C30DC02ABBB9B6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig46496E32A9C30DC02ABBB9B6
Content-Type: multipart/mixed;
 boundary="------------080102060201060309000101"

This is a multi-part message in MIME format.
--------------080102060201060309000101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Noonan schrieb:
> It seems that the appletouch driver is (sporadically) not detecting my
> Apple Trackpad anymore on Linus' current tree (2.6.27-05577-g0cfd810).
> When it is misbehaving, it doesn't have any /dev/input/event* entry
> that corresponds to the input from appletouch, and dmesg -should- show
> the following, as 2.6.27.1 does, but does not:
>=20
> appletouch: Geyser mode initialized.
> input: appletouch as /class/input/input4
> usbcore: registered new interface driver appletouch
> appletouch: 17" model detected
>=20
> On the current tree, occasionally all I get is:
>=20
> usbcore: registered new interface driver appletouch
>=20
> It's unfortunately a touchy issue, as it only -occasionally- happens.
> A bisection will be a pain in the butt, but I'm starting it right now
> anyway.

Hmm, strange...

I didn't change anything in the initialization routines. But I will take =
a look
into the changes, if something is missing or wrong...

Regards
 Sven
--=20
 Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign=

                                                 /\ Support plain text e-=
mail
 ANDURAS service solutions AG
 Innstra=DFe 71 - 94036 Passau - Germany
 Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 5=
0-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 60=
32
Mitglieder des Vorstands: Sven Anders, Marcus Junker
Vorsitzender des Aufsichtsrats: Mark Peters

--------------080102060201060309000101
Content-Type: text/x-vcard; charset=utf-8;
 name="anders.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="anders.vcf"

begin:vcard
fn:Sven Anders
n:Anders;Sven
org:ANDURAS AG;Research and Development
adr;quoted-printable:;;Innstra=3DC3=3D9Fe 71;Passau;Bavaria;94036;Germany=

email;internet:anders@anduras.de
title:Dipl. Inf.
tel;work:++49 (0)851 / 490 50 -0
tel;fax:++49 (0)851 / 590 50 - 55
x-mozilla-html:FALSE
url:http://www.anduras.de
version:2.1
end:vcard


--------------080102060201060309000101--

--------------enig46496E32A9C30DC02ABBB9B6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI+eXy5lKZ7Feg4EcRAlIdAJ47NmuiFVPoRd9RgZa19o8PzT//VgCgjTE2
cSAjf1m3Vm2zwsSxUOqPnnU=
=SIwr
-----END PGP SIGNATURE-----

--------------enig46496E32A9C30DC02ABBB9B6--
