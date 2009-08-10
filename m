Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZHJMX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZHJMX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZHJMX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:23:28 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbZHJMX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:23:28 -0400
Subject: Re: rfkill rework in 2.6.31-rc, hal/dbus access changes?
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090810104302.GD844@gamma.logic.tuwien.ac.at>
References: <20090711091427.GB14367@gamma.logic.tuwien.ac.at>
	 <1247338473.9709.107.camel@localhost.localdomain>
	 <20090711195911.GA31549@gamma.logic.tuwien.ac.at>
	 <1247346745.9709.129.camel@localhost.localdomain>
	 <20090810104302.GD844@gamma.logic.tuwien.ac.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vaZMjzIljJrOo61Fc4gc"
Date: Mon, 10 Aug 2009 14:22:50 +0200
Message-Id: <1249906970.12361.11.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vaZMjzIljJrOo61Fc4gc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-10 at 12:43 +0200, Norbert Preining wrote:

> Ok, I have rewritten my rfkill gnome applet with threads and polling
> /dev/rfkill. Did work out fine.

Umm. That's wrong in multiple ways. You don't need threads, and you
don't need to poll. Just open /dev/rfkill, add the fd to the event loop
and read events.

> I hope the format will not change too often ;-)

It won't.

johannes

--=-vaZMjzIljJrOo61Fc4gc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgBEWAAoJEODzc/N7+QmazSsP/2KCloruk7RXShCLmhmBhady
3kofL1dp3ekQ6JHJ2XeBZP8m0OG0XUUoUNfSCYvoCbqxrKGlVNocZhZQXGerrGGj
Hpq4TONbNFDo6kqVrYblXVeR7hmSWg3z4upW8PGBAbc6q6sb8G8Se+E8BhGks8o9
6ffxEF8FoQHOwp2Bx5lsKpoGgU2Y8sD8u1p0Jqzg2do5R2Z9/JCJnkKMyk+EH+Po
HLNlhLrN+fGUspcFZ5JqQEAFd9auX5KDjUxH8h+KMpOYGNM0JpX/JhmqilJ8gF/J
JRGMGEKWluU9GXajDcExKSlRdpNHGz8Vml359C4lsFF5DO9LzUxcSQcPk1X2lSk+
SyoM3fvLThybsVHT1+DLxzy4zhSiWZS4/2sk7TdI92XwdMC8/ylnA51ulUcuThtl
LetVXR73N2W/KckX2zcWMLNSXhDFuITZnurxYTnf240uIKm5k+VsFgss/OpwFm/5
yQOJ6Zm/ELjXOBn1c2Y/CpUp1rHFwdRllA5nA1QF9IlJx1Z0rqVQDUzzu7oUbSUl
pjo3krPRzBmic0K+d24W0E/6DJ527ZzwJdqS6ZrKS5NFm4NAl2V9NNzcvubenYFx
wUPmoIUdvx4dcoO+qf9nj9HlksULbkHAg+UOJDTeusI+qw0JT6WEz0NIGFqvsmJH
d0TKA79mf9kjNk0NcZ+e
=nQYP
-----END PGP SIGNATURE-----

--=-vaZMjzIljJrOo61Fc4gc--

