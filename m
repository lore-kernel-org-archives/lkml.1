Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYIVPhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYIVPhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYIVPhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:37:10 -0400
Received: from postman.teamix.net ([194.150.191.120]:36079 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609AbYIVPhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:37:08 -0400
X-Greylist: delayed 1285 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 11:37:08 EDT
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: Documentation on CFQ iosched parameters
Date: Mon, 22 Sep 2008 17:15:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1348330.mROz5oBH0l";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809221715.33143.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1348330.mROz5oBH0l
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Please CC to me unless you answer to linux-fsdevel as well. I am not=20
subscribed to linux-kernel.


Hi!

I am searching documentation about CFQ io scheduler. I can't find it in lin=
ux=20
2.6.26 Documentation directory.

I found about these in german[1]:

back_seek_max:16384
back_seek_penalty:2
fifo_expire_async:250
fifo_expire_sync:123
quantum:4

But I am completely missing about these:

slice_async:40
slice_async_rq:2
slice_idle:6
slice_sync:100

AFAIR there has been a documentation file somewhere, but I can't find it:

ms@mango> grep -ir "cfq" *   ~/lokal/Kernel/linux-2.6.26/Documentation/block
00-INDEX:       - Block io priorities (in CFQ scheduler)
ioprio.txt:With the introduction of cfq v3 (aka cfq-ts or time sliced cfq),=
=20
basic io
ioprio.txt:with cfq; other io schedulers do not support io priorities thus=
=20
far.
ioprio.txt:CFQ implements three generic scheduling classes that determine h=
ow=20
io is
switching-sched.txt:'noop', 'as' and 'cfq' (the default) are also available=
=2E=20
IO schedulers are
switching-sched.txt:for instance, to set the CFQ scheduler for the system=20
default, but
switching-sched.txt:noop anticipatory deadline [cfq]
switching-sched.txt:noop [anticipatory] deadline cfq

(unlike as-iosched.txt)

I am willing to write that documentation if someone explain these to me so=
=20
that I understand them ;-).

[1]=20
http://www.linux-magazin.de/heft_abo/ausgaben/2005/04/kern_technik/(offset)=
/4

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1348330.mROz5oBH0l
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjXto4ACgkQHhDFkwOZrpCT3wCfcs2auycj+L9iQSLqE7oLk5Sy
sHkAn32mtLXCoY/oUin9ZkjlKVzQj/Oh
=lykm
-----END PGP SIGNATURE-----

--nextPart1348330.mROz5oBH0l--
