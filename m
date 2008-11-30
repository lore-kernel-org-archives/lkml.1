Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYK3WxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYK3WxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 17:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYK3WxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 17:53:08 -0500
Received: from server.drzeus.cx ([85.8.24.28]:44281 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753457AbYK3WxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 17:53:07 -0500
Date: Sun, 30 Nov 2008 23:53:00 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: wux@landicorp.com, Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: at91_mci: reorder timer setup and mmc_add_host()
 call
Message-ID: <20081130235300.60800ad0@mjolnir.drzeus.cx>
In-Reply-To: <492EC995.8050701@atmel.com>
References: <492EC995.8050701@atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-24856-1228085584-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-24856-1228085584-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2008 17:23:49 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> As said in function comment mmc_add_host() requires that:
> "The host must be prepared to start servicing requests
> before this function completes."
>=20
> During this function, at91_mci_request() can be invoqued
> without timer beeing setup leading to a kernel Oops.
> This has been reported inserting this driver as a module.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Reported-by: Wu Xuan <wux@landicorp.com>
> ---

Queued up.


--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-24856-1228085584-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkzGVAACgkQ7b8eESbyJLgPUgCfTKtSu/7BDav5jZE9ghUO5nHS
rLQAnRI0zZ4kGRFoCYclrqF/q0FzNg+d
=yYLV
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-24856-1228085584-0001-2--
