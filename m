Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYAEWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYAEWU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 17:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYAEWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 17:20:18 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:47560 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbYAEWUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 17:20:16 -0500
Date: Sat, 5 Jan 2008 23:20:02 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx
Subject: Re: [PATCH] mmc: Handle suspend/resume in Ricoh MMC disabler
Message-ID: <20080105232002.74b8309a@poseidon.drzeus.cx>
In-Reply-To: <4776013E.3070806@overt.org>
References: <4776013E.3070806@overt.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-7700-1199571614-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-7700-1199571614-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Dec 2007 00:11:42 -0800
Philip Langdale <philipl@overt.org> wrote:

> As pci config space is reinitialised on a suspend/resume cycle, the
> disabler needs to work its magic at resume time. For symmetry this
> change also explicitly enables the controller at suspend time but
> it's not strictly necessary.
>=20
> Signed-off-by: Philipl Langdale <philipl@overt.org>
>=20

Thanks applied.

Your patch was a bit borked though (a bunch of extra spaces). You should ha=
ve a look at that for future patches.

Rgds
Pierre

--=_hera.drzeus.cx-7700-1199571614-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkeAApQACgkQ7b8eESbyJLihoACfUTWIt5R+kss45VdirlpIJ0pj
TjsAniuxJYgMu+dYqgcSPfamMeGFnwcX
=pIok
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-7700-1199571614-0001-2--
