Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYJIVVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYJIVVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYJIVVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:21:17 -0400
Received: from b01.ext.isohunt.com ([208.71.112.51]:47258 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756005AbYJIVVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:21:16 -0400
Date: Thu, 9 Oct 2008 14:03:45 -0700
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel/acct.c and testing for accounting still running?
Message-ID: <20081009210345.GC9967@curie-int.orbis-terrarum.net>
References: <20081007235331.GT9967@curie-int.orbis-terrarum.net> <20081008154028.GA2520@x200.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hCenlVgnDQUGHXTR"
Content-Disposition: inline
In-Reply-To: <20081008154028.GA2520@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hCenlVgnDQUGHXTR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2008 at 07:40:28PM +0400, Alexey Dobriyan wrote:
> On Tue, Oct 07, 2008 at 04:53:31PM -0700, Robin H. Johnson wrote:
> > Could we expose acct_list in sysfs or procfs, as uid:0, gid:0, perms
> > 0600?
> What other OS do in this respect?
Searching indicates that FreeBSD exports two sysctls, acct_configured
and acct_suspended.=20

I'm not sure from reading their source if they support multiple
concurrent accounting targets , as I'm not familar with their VFS code.
(Linux does, and you can see it used if you start use bootchart in an
init that also brings up a normal accounting instance)

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--hCenlVgnDQUGHXTR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAkjucbEACgkQPpIsIjIzwix3IwCgpxNnZnu8aYxh2b+XEOxC3+FQ
NRQAoPQI9uMZlk6PDL5ESW9fjFpX22vX
=Gp9u
-----END PGP SIGNATURE-----

--hCenlVgnDQUGHXTR--
