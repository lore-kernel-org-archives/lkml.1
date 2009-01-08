Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZAHIeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZAHIeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZAHIe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:34:28 -0500
Received: from server.drzeus.cx ([85.8.24.28]:45155 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbZAHIe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:34:28 -0500
Date: Thu, 8 Jan 2009 09:34:07 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "=?UTF-8?B?w4lyaWM=?= Piel" <eric.piel@tremplin-utc.net>
Subject: Re: [Regression] hald segfaults at startup on Toshiba Portege R500
 x86_64 (bisected)
Message-ID: <20090108093407.3efd0938@mjolnir.drzeus.cx>
In-Reply-To: <200901080827.02882.rjw@sisk.pl>
References: <200901080827.02882.rjw@sisk.pl>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-32105-1231403664-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-32105-1231403664-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Jan 2009 08:27:02 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
>=20
> Unfortunately the following commit:
>=20
> commit 35ff8554d12ecc80a46ea0d9bce34fe28733ff38
> Author: =C3=89ric Piel <eric.piel@tremplin-utc.net>
> Date:   Sat Nov 22 19:29:29 2008 +0100
>=20
>     sdhci: activate led support also when module
>=20
>     CONFIG_LEDS_CLASS is defined only if led-class is built-in, otherwise
>     when it is a module the option is called CONFIG_LEDS_CLASS_MODULE. Led
>     support should also be activated in this case.
>=20
>     Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
>     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
>=20
> causes hald to segfault at startup (not always, but sufficiently often for
> bisection) on my Toshiba Portege R500 w/ x86_64 kernel/userland.
>=20

I have trouble seeing a user space application crashing as a kernel
bug. Do you have a backtrace or strace of hald to see exactly where it
crashes?

> While it doesn't revert cleanly, I have applied the appended patch (which=
 is
> a revert of the commit above) and hald doesn't segfault any more here.
>=20

Is CONFIG_LEDS_CLASS defined in your config, or are you essentially
turning of the LED functionality?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-32105-1231403664-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklluoUACgkQ7b8eESbyJLjr/wCdHZACr9neAA9AX4S3o5ioQnAj
9iMAmgITkTG3N7AT8Gc0pT6jDftFvcm8
=BCqw
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-32105-1231403664-0001-2--
