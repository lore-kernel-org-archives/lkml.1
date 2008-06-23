Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYFWNjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYFWNjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYFWNjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:39:15 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:41430 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYFWNjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:39:15 -0400
Date: Mon, 23 Jun 2008 15:39:12 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/70] tty: Ldisc revamp
Message-ID: <20080623133912.GU30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080620195406.1479.12620.stgit@localhost.localdomain> <20080620195801.1479.24228.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-7564-1214228260-0001-2"
Content-Disposition: inline
In-Reply-To: <20080620195801.1479.24228.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-7564-1214228260-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2008 at 08:58:05PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@redhat.com>
>=20
> Move the line disciplines towards a conventional ->ops arrangement. For t=
he
> moment the actual 'tty_ldisc' struct in the tty is kept as part of the tty
> struct but this can then be changed if it turns out that when it all sett=
les
> down we want to refcount ldiscs separately to the tty.
>=20
> Pull the ldisc code out of /proc and put it with our ldisc code.
>=20

[...]

> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index e94bee0..ab1dd0a 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c

[...]

> @@ -1386,7 +1467,7 @@ static void tty_reset_termios(struct tty_struct *tt=
y)
>   *	do_tty_hangup		-	actual handler for hangup events
>   *	@work: tty device
>   *
> - *	This can be called by the "eventd" kernel thread.  That is process
> +k *	This can be called by the "eventd" kernel thread.  That is process
>   *	synchronous but doesn't hold any locks, so we need to make sure we
>   *	have the appropriate locks for what we're doing.
>   *

Sorry for such a trivial comment, but the leading 'k' above looks like a ty=
po.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-7564-1214228260-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIX6eAVKcRuvQ9Q1QRAgoPAKDQa8dRITnIjayiM+HMoBb0SGV2/ACgqRMu
Zu45CJaWIh1IWiwEhrgBRug=
=ktcz
-----END PGP SIGNATURE-----

--=_bohort-7564-1214228260-0001-2--
