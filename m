Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbXJBLkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbXJBLkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbXJBLki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:40:38 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:51514 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbXJBLkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:40:37 -0400
Date: Tue, 2 Oct 2007 13:40:25 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: benh@kernel.crashing.org
Cc: Philip Langdale <philipl@overt.org>, sdhci-devel@list.drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Disabler for Ricoh MMC controller
Message-ID: <20071002134025.39765311@poseidon.drzeus.cx>
In-Reply-To: <1191309274.6310.108.camel@pasglop>
References: <4701B9AB.5070308@overt.org>
	<1191300236.6310.60.camel@pasglop>
	<1191300334.6310.62.camel@pasglop>
	<4701D0BA.7080404@overt.org>
	<1191309274.6310.108.camel@pasglop>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-26851-1191325209-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-26851-1191325209-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Oct 2007 17:14:34 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

>=20
> Hrm... allright, tho having this "disabler" driver is butt ugly
> too ... especially since it needs to whack registers in another
> function, that's really quirkland :-)
>=20

Well, that issue would remain even if we put it into sdhci.c. Perhaps
something can be done when sdhci is split into multiple parts, but not
right now.

Rgds
Pierre

--=_hera.drzeus.cx-26851-1191325209-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHAi4p7b8eESbyJLgRAiHgAKCVbjPHoTNstDCFNWNq7R4hyLnxVgCfQzSi
4KKZO91nxiuQEvzIEb0Lgeo=
=tkz7
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-26851-1191325209-0001-2--
