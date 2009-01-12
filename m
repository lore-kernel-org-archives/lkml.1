Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZALPUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZALPUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZALPUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:20:00 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:44844 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZALPT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:19:59 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 10:19:59 EST
Date: Mon, 12 Jan 2009 16:14:17 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       sfr@canb.auug.org.au
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq (v2) (resend)
Message-ID: <20090112161417.7a4fbda6@mjolnir.drzeus.cx>
In-Reply-To: <94b68f283abf372eab895fd76b0feb34@localhost>
References: <40499.98.210.152.237.1231345314.squirrel@overt.org>
	<200901082314.52840.rjw@sisk.pl>
	<94b68f283abf372eab895fd76b0feb34@localhost>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-6560-1231773262-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-6560-1231773262-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 09 Jan 2009 21:31:25 -0500
Philip Langdale <philipl@overt.org> wrote:

>=20
> Now, the ricoh chip implements the standard SD host controller spec but
> as no such thing exists for MMC, it implements its own custom one. Linux
> only has an SDHCI driver, but due to how the hardware works, we can suppo=
rt
> MMC cards through it - but only if the controller can see them!
>=20

Just to clarify, the problem is really that Microsoft are being
difficult. Their driver only implements support for SD (which I suppose
is only because they have a serious problem with lack of manpower, and
not because they're a member of the SD Association but not the MMC
one ;)), but since there is only a single device there is no
possibility for another driver to provide the MMC functionality.

The way most vendors have solved this Windows misfeature is by having
some voodoo where their own driver binds to a non-SDHCI interface, and
in the event of an SD card, hands it over to the other device (and
Microsoft's sdhci driver) or handles the SD in the vendor driver as
well.

Once again the limited design of that other OS forces the hardware
vendors to do sub-optimal devices and the rest of the world is poorer
for it.

Bitterly
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-6560-1231773262-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklrXk4ACgkQ7b8eESbyJLgqHQCbBsjmLQzLLINdeEwZh9rAnm2i
y6wAn2vCP6vfw64kJc4a3VY+YPVyssaz
=8NCE
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-6560-1231773262-0001-2--
