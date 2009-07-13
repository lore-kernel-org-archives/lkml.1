Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbZGMVlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbZGMVlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbZGMVlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:41:10 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZGMVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:41:09 -0400
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-13ACftGP5XaoLA7RK+nY"
Date: Mon, 13 Jul 2009 23:40:34 +0200
Message-Id: <1247521235.7178.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-13ACftGP5XaoLA7RK+nY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 23:24 +0200, Jiri Slaby wrote:
> Add omitted mutex_unlock to one of wl12xx_op_start fail paths (when
> wl12xx_chip_wakeup fails).

By the way, are you using some tool to find these? I've had local hacks
many times to make sparse aware of mutexes, is there a reason they are
not annotated with __acquire(s)/__release(s) like spinlocks etc.?

johannes

--=-13ACftGP5XaoLA7RK+nY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW6nPAAoJEODzc/N7+QmasZMP/jbrXC0ly2wGR/AqAU6sl8Ac
ZXz7l48xA7u1bUYpP3rKJt+l5aizy7y2N7LH1kuAFZH1EFDo8+C6rKquOjuP5czO
DrDshe7TNHhI6ijzdcn9i9N5ZXDI1dV7+GVniOWFCPhvQXoyNyVHMrXhDxYxPdpi
6YgAMT3q0WWCe8xXHJMrZMxQPJy4ytUyaPyrZh8aY1v+TIFlNA6M8irder27dPlW
SqkjhyAcPZoe+tpkfbM+l6DIQL0SzrGu7J5hRuZ8A5OJVQQ6szrHs9e4yqZPhabG
CXOBZ5Qq8IpHQ4klsaMTSFpsla6qTgffGQLhghKiy7VhMTcwSPz3nRD+C7NvMEhS
glIOsOo6xYvoNGGOgaafz2cqoCFd3Qywrwk+ODhAMnlsf5LLgkPFajHZGFBNUT6n
We5YPqrWsk96BsXQkc7DuL+jPbrdV8Hec7uQ4cgvjoRWVX5H1Kw4f6xajNZ4jjpD
rAmeVSxdRaSB/TPI5drmOX27BQuIDvMfFg43ak4ZZgRK2d6DRLVmgbFN8aoOl+Fr
P3rTXpLyKHUEj0Qzlf+EaaMocEFce1GF/cMlBkdo/qjiPlN7+nsmDwaypa+ZHAPi
oJgd1TKq1RzUggTkfve+a1wrixMq50SCG1OHOSakQPqYsJ/mu4VTvxma+2S26vFy
4DwXaeLnuQ7yq14czgQd
=IWuC
-----END PGP SIGNATURE-----

--=-13ACftGP5XaoLA7RK+nY--

