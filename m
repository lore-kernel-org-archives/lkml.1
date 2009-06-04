Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZFDLvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZFDLvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZFDLuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:50:44 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34910 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZFDLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:50:43 -0400
Subject: Re: [PATCH/RFC] exit: PR_SET_ANCHOR for marking processes as
 reapers for child processes
From: Scott James Remnant <scott@canonical.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20090528204729.GA28564@omega>
References: <20090528204729.GA28564@omega>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xDZtp3kPoxioVuU++kf4"
Date: Thu, 04 Jun 2009 12:50:55 +0100
Message-Id: <1244116255.4120.33.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xDZtp3kPoxioVuU++kf4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-28 at 22:47 +0200, Lennart Poettering wrote:

> Right now, if a process dies all its children are reparented to init.
> This logic has good uses, i.e. for double forking when
> daemonizing. However it also allows child processes to "escape" their
> parents, which is a problem for software like session managers (such
> as gnome-session) or other process supervisors [1].
>=20
As we discussed on IRC, another option is for the session
manager/process supervisor to use the proc connector to receive messages
about fork() and exit() - then it doesn't need to receive SIGCHLD, so it
doesn't matter where the process reparents to.

OTOH, this patch would make the process trees much prettier <g>

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-xDZtp3kPoxioVuU++kf4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkontR8ACgkQSnQiFMl4yK7P7wCaA7DtdpoP4nkQv2UH5lLbgTEM
o00AoJaNsN72AEHItKTLM2twgi1Jx5eV
=X29l
-----END PGP SIGNATURE-----

--=-xDZtp3kPoxioVuU++kf4--

