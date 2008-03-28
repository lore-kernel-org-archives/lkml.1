Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYC1QhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYC1QhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYC1QhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:37:04 -0400
Received: from komodo.mcnabbs.org ([67.207.145.27]:38724 "EHLO
	mail.mcnabbs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYC1QhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:37:03 -0400
X-Greylist: delayed 1675 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2008 12:37:03 EDT
Date: Fri, 28 Mar 2008 10:09:06 -0600
From: Andrew McNabb <amcnabb@mcnabbs.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Rodney Lorrimar <rodney@rodney.id.au>, jikos@suse.cz,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Input: adbhid - fix capslock key state after suspend
Message-ID: <20080328160906.GA16187@mcnabbs.org>
References: <20080328001556.GA30148@solaria.local> <20080328105855.GA1686@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20080328105855.GA1686@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2008 at 11:58:55AM +0100, Pavel Machek wrote:
> On Fri 2008-03-28 01:15:56, Rodney Lorrimar wrote:
> > If the adbhid module parameter restore_capslock_events is used,
> > sometimes capslock will get stuck down after resuming.
>=20
> Hmmm, why does that need to be a parameter? I mean... can we just do
> the right thing?

I agree.  There really don't seem to be any drawbacks to keeping track
of capslock state.  The worst thing that can happen is that it somehow
occasionally fails to do the right thing.

--=20
Andrew McNabb
http://www.mcnabbs.org/andrew/
PGP Fingerprint: 8A17 B57C 6879 1863 DE55  8012 AB4D 6098 8826 6868

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH7Rgiq01gmIgmaGgRAglDAKCFrF9fKhGLGW6azKSvxfVr/wIGKQCgjOYq
BCAMB86mqwoC4j7ZXim7jVE=
=CrGZ
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
