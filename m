Return-Path: <linux-kernel-owner+w=401wt.eu-S1161858AbXDYM3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161858AbXDYM3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161540AbXDYM3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:29:37 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:37763 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161855AbXDYM3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:29:32 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-mm@kvack.org
Subject: Removing VM_LOCKED from user memory
Date: Wed, 25 Apr 2007 14:29:17 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4270414.IHIPDGtuYs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704251429.26014.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4270414.IHIPDGtuYs
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I need some assistance handling a large memory segment of a user process.

The user calls the kernel with a address and a length of it's own memory. M=
y=20
driver will lock this memory using get_user_pages(). This memory is used as=
=20
DMA buffer directly from or to user processes.

Everything works fine that far: allocating, DMA mapping, DMA transfers. But=
 I=20
currently can't get rid of the buffer again. Which function would help me t=
o=20
get all pages unlocked once the buffer isn't needed anymore?

Is it enough to simply call sys_munlock() from the release and cleanup=20
functions?

There are no plans to share these mappings between different processes.

Greetings,

Eike

--nextPart4270414.IHIPDGtuYs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGL0mlXKSJPmm5/E4RAjdMAJ40t9quwChTbbi8dciplKENDCqUPgCfZ6t+
toI0Psg11rZY4naPV7Bui8w=
=QRMy
-----END PGP SIGNATURE-----

--nextPart4270414.IHIPDGtuYs--
