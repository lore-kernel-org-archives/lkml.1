Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYGXLry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYGXLry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYGXLrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:47:45 -0400
Received: from server.drzeus.cx ([85.8.24.28]:60754 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752816AbYGXLro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:47:44 -0400
Date: Thu, 24 Jul 2008 13:47:37 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080724134737.4b91f30d@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-6493-1216900062-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-6493-1216900062-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Somewhere post 2.6.26, pciehp started whining about not being able to
claim the slot and error code -17. It suggested adding
"pciehp_slot_with_bus", which actually helped. Still, having a kernel
parameter should just be a temporary fix.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-6493-1216900062-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiIa90ACgkQ7b8eESbyJLgfOACeO4cEKsHL+UQUw2YAiDIVcphl
IBoAoKLfWMwOby1ZIhRtXd9h7p9YP8kS
=aKZt
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-6493-1216900062-0001-2--
