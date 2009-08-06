Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZHHV6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZHHV6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 17:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZHHV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 17:58:04 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41527 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZHHV6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 17:58:03 -0400
Date: Thu, 6 Aug 2009 10:54:01 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl, ppisa@pikron.com,
       jarkko.lavinen@nokia.com, ben@fluff.org, saschasommer@freenet.de,
       avorontsov@ru.mvista.com, oakad@yahoo.com, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090806105401.1f852995@mjolnir.ossman.eu>
In-Reply-To: <200908031851.24375.david-b@pacbell.net>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090728222334.0c543c47@mjolnir.ossman.eu>
	<20090731122623.254fd0f1@mjolnir.ossman.eu>
	<200908031851.24375.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-20598-1249548849-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-20598-1249548849-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Aug 2009 18:51:23 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Friday 31 July 2009, Pierre Ossman wrote:
> > Restoring back the system state from MMC after a successful hibernation
> > http://marc.info/?t=3D124818534700003&r=3D1&w=3D2
> >=20
> > I don't agree with this approach. The point of the workqueue is so that
> > the kernel can do things in parallel, so this patch is a step back. The
> > problem is really with how the kernel doesn't properly cope with
> > asynchronous disk scanning during bootup. The root_delay parameter was
> > added for this for the "normal" case, but it seems more work is needed.
>=20

(confusion on my end, I wasn't thinking about root_delay but rootwait)

> Doesn't handing of resumes needs more attention overall?
>=20

Very much so. I haven't given that area much love since a) I haven't
had the time, b) I don't have any systems with fancy enough suspend
handling to do anything interesting.

> Example, root on eMMC (e.g. a 32-MByte non-removable chip) wouldn't
> resume at all well the last time I checked ... mounted file systems
> (not just root) made trouble.  Hardware that reliably reports card
> insert/remove was rude in the same ways.

The general lack of removal detection during suspend tends to make
everything more complicated than one would like. But I'm sure it's
manageable just as long as someone puts enough time into it. I'm still
very much opposed to just assuming that the user never removes the card
during suspend though.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-20598-1249548849-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkp6mi4ACgkQ7b8eESbyJLjGwQCfaDZO/QTMSmyt85o5XDJBOxii
i/wAn3enY3iPeJjHxgkJBsFbDdMR69r7
=qbfd
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-20598-1249548849-0001-2--
