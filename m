Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYJLLsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYJLLsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYJLLsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:48:13 -0400
Received: from mx33.mail.ru ([194.67.23.194]:25876 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYJLLsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:48:13 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Arjan van de Ven <arjan@infradead.org>, Oliver Neukum <oliver@neukum.org>
Subject: Re: when spin_lock_irq (as opposed to spin_lock_irqsave) is appropriate?
Date: Sun, 12 Oct 2008 15:48:00 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810111929.01927.arvidjaar@mail.ru> <20081011091806.2c8eb2d4@infradead.org>
In-Reply-To: <20081011091806.2c8eb2d4@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15694926.RNK374XDzY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810121548.05644.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15694926.RNK374XDzY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 11 October 2008, Arjan van de Ven wrote:
[... very useful explanation omitted ...]
> Does this answer your question?
>=20

As Oliver pointed out, part of confusion wa my asumption that _irqsave
verion saves actual interrupt mask. It actually does not.

This leaves me with a question - how can I know whether interrupts may
(not) be disabled at particular point? In particular, is it safe to=20
assume that any place marked at "code may sleep" has interrupts enabled?

Thank you both!

=2Dandrey

--nextPart15694926.RNK374XDzY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjx4/EACgkQR6LMutpd94wGLwCeLJ+aND46Rnh4BRb/p3RYKkzw
qCIAoKSMc4pnVZpJ4pgoDb1a445CZawm
=q7g+
-----END PGP SIGNATURE-----

--nextPart15694926.RNK374XDzY--
