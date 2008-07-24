Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbYGXVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbYGXVvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYGXVvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:51:35 -0400
Received: from server.drzeus.cx ([85.8.24.28]:41950 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751716AbYGXVvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:51:35 -0400
Date: Thu, 24 Jul 2008 23:51:27 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080724235127.40bd0ac9@mjolnir.drzeus.cx>
In-Reply-To: <200807241407.18543.jbarnes@virtuousgeek.org>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx>
	<488877C8.9020706@jp.fujitsu.com>
	<20080724223920.1f4dd753@mjolnir.drzeus.cx>
	<200807241407.18543.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-11446-1216936293-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-11446-1216936293-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 14:07:18 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thursday, July 24, 2008 1:39 pm Pierre Ossman wrote:
> >
> > This is a laptop with a single expressport that worked fine up until
> > this merge window. What changed and why is it no longer possible to
> > support this hardware without a kernel parameter?
>=20
> Yeah we're being a bit more careful about registering hotplug slots these=
=20
> days.  The fact that you got a conflict message indicates that more than =
one=20
> driver is trying to bind to that PCIe port and handle hotplug for it.  I=
=20
> guess acpiphp must already be loaded?
>=20

Nope. Only pciehp is builtin, and acpiphp is not loaded. Anything
non-hotplug related that can block stuff?

Anyway, the port seems to work even with that warning present though
(sorry for not testing that properly earlier). Stray warnings is still
not pleasant though, so I can do some more testing if you have some
ideas.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-11446-1216936293-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiI+WIACgkQ7b8eESbyJLjaeACcD4VTVh86FsHmom5GFRhnQhy1
W9AAn0xPAQBQ/HRtWbN6Mf1VrJk7h0BT
=lwj3
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-11446-1216936293-0001-2--
