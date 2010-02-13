Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0BMLWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 06:22:09 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:59190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0BMLWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 06:22:07 -0500
Subject: Re: [PATCH][trace-cmd] parse-events: Make input buffer const char *
From: Johannes Berg <johannes@sipsolutions.net>
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1266022384.24271.106.camel@gandalf.stny.rr.com>
References: <1266022384.24271.106.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oc9EBnRsR/9KUHXwg4n7"
Date: Sat, 13 Feb 2010 12:22:01 +0100
Message-ID: <1266060121.3753.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oc9EBnRsR/9KUHXwg4n7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-12 at 19:53 -0500, Steven Rostedt wrote:

> I just wanted you to see a recent change I made. It touches your work
> around you added for the older kernels that did not convert your macro
> to a string. I'm sending this to you to make sure that it still works
> for your liking.

Heh, that means I'd have to test it? :)

> Also, I think I see a bug in the original code (and I kept) where you
> added a \ to %s. Perhaps its not a bug, but is it really needed? We
> don't process this code through any printf formatting.

Looks like a typo.

Patch _looks_ good otherwise, I'll give it a try when I find a file or
get one from a user.

johannes

--=-oc9EBnRsR/9KUHXwg4n7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLdotTAAoJEODzc/N7+Qma2i4P/2fqfOk0dz9Vn3oHpYwlalyH
J/mpN6UMg5b+MPli2d9qKKNDgmv9xXqSi5bcovmBxx3Rpsn5uzygzk3grM0rX4O/
PyH0Z8FWRd9n6nMV3R+2uPTDqkSb950p5eHBn3U5EpZX43aOXbDWl3JEna6ut0ON
9GJ/3/nwdL9zmiBggLvFI+Dabyc2d+ef9RQ8yLRRjwzUJLT3yprUMDzzi/+g1r2M
d4QVP02z1QKMEHl09/5W7l0dccWGqoA7GvuE9pV5QpBIoh30feFZzIBvX7D036Xt
ckQJKgLgOV2SzsC/QiixmO2c3/Ky6P71odoTUvWeUEKdqZjrxRS9ipjvO+OcdxzX
bu7bTc8NzuRgXtug2lk8/coyYB5ydCAWuzbMZFjbvhYtdzdcd6tyxg1OuN+xFNLJ
L7zvj9s1PISsxBWKraPIw1L9LzrboxxaLG8P5AJAwq1Inv9bRapV9iZDUym2zuCH
8ncLS0mNkRtCEt7FDWM95CtPoL1h98ZhMs6E0FGqFdRimk9DYhStKXoPv7BxnBms
dDzTimKuvGT8GGRAWROGfgmgDX4hagMaDkbKJD5AZVt6xfkMgcOha4GA1WKlIfs2
qJhGHVolVecud6e+nxWgOgLrBRgcwI7uCBB0wSWfwHNBD/JP9BXOZAobY29/rdGx
bevO92LqB3NX8nWz+0hf
=YxBR
-----END PGP SIGNATURE-----

--=-oc9EBnRsR/9KUHXwg4n7--

