Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbZFWQwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbZFWQwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbZFWQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:52:23 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbZFWQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:52:22 -0400
Subject: Re: debugfs related oops in mac80211/ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ath9k-devel@venema.h4ckr.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <4A410300.6040804@gmail.com>
References: <4A410300.6040804@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F+UMhwfYyEs1wK0d2y5L"
Date: Tue, 23 Jun 2009 18:52:12 +0200
Message-Id: <1245775932.21314.40.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F+UMhwfYyEs1wK0d2y5L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-23 at 18:29 +0200, Jiri Slaby wrote:

> We need some kind of barrier in debugfs_remove, so that all processes
> with that file opened finishes first. Any ideas?

That has been discussed countless times, and is the reason all debugfs
files are not readable by regular users (or shouldn't be); it isn't
possible to solve before revoke() exists.

johannes

--=-F+UMhwfYyEs1wK0d2y5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQQg4AAoJEODzc/N7+QmadbQQAKHSaPZhdpy10aaFzd4WvQcr
DfLd8J68+Umv3Z3Z1Oad7FHSD5zQxgQjpGlYL2g8JZJ7wm/clhIkhY2E3Rw5587N
aGQXV00KWzLcIgp7V+Trjrf24iG7CIupeuN5bxS6kq0bAu5VkLaMVCWfMg+OAflI
RUIvzhnhV6HZmY5m8TMNNoDzJjIzzEpH7oWT5zMYhkR8YGFZtLRKwVe//4X3QXxd
jjkq56toZppCwgXoc7pXz5ARsmZRL4qUiP2bV1Dar/xY1Yi0a4SekcjuqvDGaESz
IMoLd9VNU+GTLwjh+LKOJQWRSgyBCAondDK3DqvyK8AMKcCge8uyu0xnIFeIJS6t
XyY/+Z368LAIIajWbaiilQnRe8XbeeQ98GXIlFhGbKRqdtb1BxaWlcghzvxAMbLT
GcKavhYuwC1aT6odTOIEZQLxaM1MjcYnEgeSB0ORs7f4FBAVrd4EimGGW1bIEr3v
Srw6dDv8cm6mXHfG8DKI2WDjODTejH/F5VbQ9BicmWYxmz29ydZFvPw81kqDF9F8
45v/d1vN+/PlAsDhWZVnZi6raabkXXnnvXdM9blA2E4qenKhPn4ihNzAzVY2e91Z
FjX3WcWjdMsAXxgclN5ivPKETilKHAOv8+uWhPCMqXM81WqnGUpr1UAuSam7CpV8
u27XQ5DyNfem4nfjUVz8
=5Zb4
-----END PGP SIGNATURE-----

--=-F+UMhwfYyEs1wK0d2y5L--

