Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYBOQYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYBOQYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYBOQYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:24:46 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3698 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYBOQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:24:45 -0500
Date: Fri, 15 Feb 2008 17:04:22 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com
Subject: Re: [PATCH] Use directly kmalloc() and kfree() in init/initramfs.c
Message-ID: <20080215170422.192de4df@crazy>
In-Reply-To: <Pine.LNX.4.64.0802151658320.30301@fbirervta.pbzchgretzou.qr>
References: <20080215121330.3f790783@crazy>
	<Pine.LNX.4.64.0802151546230.30301@fbirervta.pbzchgretzou.qr>
	<20080215164503.245752e6@crazy>
	<Pine.LNX.4.64.0802151658320.30301@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MIMjM7hKs0NkhgllvR5VGQ6";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MIMjM7hKs0NkhgllvR5VGQ6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 15 Feb 2008 17:00:35 +0100 (CET),
Jan Engelhardt <jengelh@computergmbh.de> a =C3=A9crit :

> Anyone you can get to push the actual changeset; many won't feel
> responsible :) so the path is through ->akpm->linus here.

Ok, so as Andrew is in Cc:, I suppose he will pick the patch :-)

> BTW, if you changed free to kfree, did the free macro/whatever get=20
> removed or is it still used?

After this patch, they are still used by the lib/inflate.c code. But if
you look at the patch called "inflate: refactor inflate malloc code"
that I sent to the LKML this morning, you'll see that it removes the
malloc() and free() wrappers (and does some more clean-up).

Sincerly,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/MIMjM7hKs0NkhgllvR5VGQ6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtbgG9lPLMJjT96cRAtmNAJ4pkJgyXMA1f3HW9HEMgEBskD6cZgCeNAjG
Wxm+pErJxnSpRZpa5QLXDUU=
=t+ZI
-----END PGP SIGNATURE-----

--Sig_/MIMjM7hKs0NkhgllvR5VGQ6--
