Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbXFAXbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbXFAXbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXFAXbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:31:48 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:56743 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXFAXbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:31:47 -0400
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200706020037.16615.rjw@sisk.pl>
References: <878xb35sje.fsf@goat.bogus.local>
	 <200706012340.54394.rjw@sisk.pl> <87hcpr2ubl.fsf@goat.bogus.local>
	 <200706020037.16615.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c001p/U8QlPacqsGSkNI"
Date: Sat, 02 Jun 2007 09:31:54 +1000
Message-Id: <1180740714.9412.73.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c001p/U8QlPacqsGSkNI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, 2007-06-02 at 00:37 +0200, Rafael J. Wysocki wrote:
> On Saturday, 2 June 2007 00:17, Olaf Dietsche wrote:
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >=20
> > > On Friday, 1 June 2007 23:12, Olaf Dietsche wrote:
> > >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > >>=20
> > >> > On Friday, 1 June 2007 22:27, Olaf Dietsche wrote:
> > >> >> When I resume, everything seems to come up (fan becomes busy, dis=
k and
> > >> >> dvd spin up for a short time),
> > >> >
> > >> > Hmm, what about the screen?
> > >>=20
> > >> When the laptop is dead, screen remains black.
> > >>=20
> > >> When I skip acpi_enter_sleep_state(), the screen works like everythi=
ng
> > >> else.
> > >
> > > I think you should try s2ram (http://en.opensuse.org/s2ram) as the fi=
rst step.
> >=20
> > It doesn't work. I tried all options "s2ram -f (-s, -p, -m, -r, -a 1, -=
a 2,
> > -a 3)" one after the other.
> >=20
> > Since the screen (or any other device) works without problems, when I
> > skip acpi_enter_sleep_state(), I don't think it's screen related.
>=20
> No, it might be, actually.  If you skip acpi_enter_sleep_state(), your ma=
chine
> doesn't really suspend, so in fact you only confirm that your drivers imp=
lement
> .suspend() and .resume() hooks correctly.

Actually, you don't even confirm that. Chips that would be powered down
by entering the sleep state will not be powered down in this scenario,
so failures to properly reinitialise them in resume routines won't be
noticed.

Regards,

Nige

--=-c001p/U8QlPacqsGSkNI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGYKxqN0y+n1M3mo0RAqs9AJwOSTo3HuHPWMkbzZZnnWn5S4TA/wCgj7Hg
Ria/gUkg4vC4M2e5YffmLBM=
=8k55
-----END PGP SIGNATURE-----

--=-c001p/U8QlPacqsGSkNI--

