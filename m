Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbXFDIOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbXFDIOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXFDIOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:14:35 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:56517 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbXFDIOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:14:35 -0400
Subject: Re: A kexec approach to hibernation
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vgoyal@in.ibm.com, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200706041005.42092.rjw@sisk.pl>
References: <878xb3l888.fsf@jbms.ath.cx> <20070604044041.GB10206@in.ibm.com>
	 <1180934540.1169.31.camel@nigel.suspend2.net>
	 <200706041005.42092.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W99FbfwHIh7h3Sf4yFA/"
Date: Mon, 04 Jun 2007 18:14:34 +1000
Message-Id: <1180944874.27018.2.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W99FbfwHIh7h3Sf4yFA/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi again.

On Mon, 2007-06-04 at 10:05 +0200, Rafael J. Wysocki wrote:
> On Monday, 4 June 2007 07:22, Nigel Cunningham wrote:
> > Hi.
> >=20
> > I can see that the idea of writing a kernel image from using another
> > kernel sounds nice and clean initially, but the more we get into the
> > details (yes, I am listening, even though I said nothing before now),
> > the more it's sounding like the cure is worse than the disease.
> >=20
> > To get rid of process freezing, we're talking about:
> > * making hibernation depend on depriving the user of 32 or 64M of
> > otherwise perfectly usable memory (thereby making hibernation on
> > machines with less memory impossible)
> > * requiring them to set up kexec or kdump (I don't understand the
> > difference, sorry) or some new variation
> > * adding interfaces to tell kexec/dump/whatever what pages need to be
> > saved and reloaded
> > * adding convolutions in which at resume time we boot one kernel, switc=
h
> > to another kernel to do the loading and then switch back again to the
> > resumed kernel (assuming I understand what you're suggesting).
> >=20
> > It all sounds terribly complicated and confusing to me, and that's
> > before I even begin to think about how this second kernel could possibl=
y
> > write the image to an encrypted device or LVM or such like that the
> > first kernel knows about and might use now.
> >=20
> > Can't we just get the freezer right and be done with it?
>=20
> My feelings about this are pretty much the same. :-)
>=20
> At least, there still is room for improvements within the current approac=
h,
> so first I'd like to improve it as much as reasonably possible and then t=
o
> think of alternatives, if need be.

Agreed. I'm not for a moment denying that the current freezer could be
better, but biffing it out the window just doesn't seem to be the
appropriate solution at the moment.

Regards,

Nigel

--=-W99FbfwHIh7h3Sf4yFA/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGY8nqN0y+n1M3mo0RAnPyAJ0a3eFhAsx2aMYfXMHhU6ABFIcz2ACfcuRn
hgFttmxTT74u7LOShvUnlW0=
=cVu1
-----END PGP SIGNATURE-----

--=-W99FbfwHIh7h3Sf4yFA/--

