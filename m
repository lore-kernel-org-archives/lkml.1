Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYJKP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYJKP3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYJKP3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:29:07 -0400
Received: from mx39.mail.ru ([194.67.23.35]:54378 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYJKP3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:29:06 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: when spin_lock_irq (as opposed to spin_lock_irqsave) is appropriate?
Date: Sat, 11 Oct 2008 19:29:01 +0400
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8109259.0jDmupbRF4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810111929.01927.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8109259.0jDmupbRF4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Logically, one piece of kernel code has no way to know whether another
piece of kernel code (or may be hard-/firmware) has disabled some
interrupt line. So it looks like spin_lock_irq should not even exist,
except may be for very specific cases (where we are sure no other piece
of kernel code may run concurrently)?

Sorry for stupid question, I an not actually a HW type of person ...

--nextPart8109259.0jDmupbRF4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjwxj0ACgkQR6LMutpd94xJNwCeJtUkO/fBjBdoOSbnGEYDMS94
KcEAn2Vs76+TUiGWn6xjdPyh0YDDQcHR
=GjjW
-----END PGP SIGNATURE-----

--nextPart8109259.0jDmupbRF4--
