Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbXLYNfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbXLYNfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 08:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbXLYNfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 08:35:44 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:47549 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbXLYNfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 08:35:44 -0500
Date: Tue, 25 Dec 2007 14:35:40 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "raki john" <raki4652@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: relation between mmc_request, mmc_data and mmc_command
Message-ID: <20071225143540.1dd5aca4@poseidon.drzeus.cx>
In-Reply-To: <d2a348dd0712232325s7da2bfdfk92b0fd049adcb3df@mail.gmail.com>
References: <d2a348dd0712232325s7da2bfdfk92b0fd049adcb3df@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-24431-1198589742-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-24431-1198589742-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Dec 2007 23:25:26 -0800
"raki john" <raki4652@gmail.com> wrote:

>=20
> Does  mmc_requeest->stop is equal  to mmc_request->data->stop ?
>=20
> Does  mmc_request   is equal  to mmc_request->data->mrq ?
>=20
> Does mmc_request->data   is equal  to   mmc_request->cmd->data ?
>=20
> Does mmc_request   is equal  to mmc_request->cmd->mrq  ?
>=20

Yes on all accounts. I don't know the reason for this extreme redundancy. I=
t was there long before I got involved.

>=20
> I think Stop command which is part of mmc_request is used for sending stop
> command after Multi Block write. is this correct. If stop command fails(C=
RC
> fail, timeout), does this mean card  write failed.
>=20

It is correct that it is used for multi block writes. But also other open e=
nded transfers.

If the stop command fails, then the card will be in an unknown state. The w=
rite should have been completed though.

Rgds
Pierre

--=_hera.drzeus.cx-24431-1198589742-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkdxBywACgkQ7b8eESbyJLhXMwCfWmSNENQHSANPh737UpdIafO2
pJ8An3sUgJa4v4bYwpscehbhRc4K4ehg
=wnIn
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-24431-1198589742-0001-2--
