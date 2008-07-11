Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYGKRTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYGKRTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYGKRTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:19:44 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:38950 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYGKRTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:19:43 -0400
Date: Fri, 11 Jul 2008 19:19:35 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: send correct MTU value in PMTU
Message-ID: <20080711171935.GA25603@hrz.tu-chemnitz.de>
References: <20080711124735.GA16996@hrz.tu-chemnitz.de> <20080711083423.64b67c0c@extreme>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20080711083423.64b67c0c@extreme>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: 0.2 (/)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (0.2 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	1.6 TVD_RCVD_IP            TVD_RCVD_IP
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 439a779e86734b9f9e658ea38d6cb1c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2008 at 08:34:23AM -0700, Stephen Hemminger wrote:
> On Fri, 11 Jul 2008 14:47:35 +0200
> Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
>=20
> > [...]
>=20
>=20
> port should always be non-null so the existing fake_rtable can
> just go away no?

I wondered about that too. But since bridge_parent() is also checking port
for NULL, and the code calling this is carefully checking these cases, i
assumed that this is quite possible. If you can assert that port is
non-NULL, we can remove this, but i have to admit that i don't get the
whole picture to be sure about this.

>=20
> Also some of this could be #ifdef CONFIG_BRNETFILTER

Thanks, you're right. I will prepare the patch again with some #ifdefs.

regards,
	Simon

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFId5Ymrzg/fFk7axYRAr5EAJ9zm9U/mnvWlEexz2Wtx6pNu3H9QACg0t4S
kovqWcfGFCxpkJA8wGVd60g=
=Nqm4
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
