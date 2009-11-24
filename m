Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbZKXLK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbZKXLK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbZKXLKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:10:53 -0500
Received: from mail.klingt.org ([86.59.21.178]:33175 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbZKXLKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:10:51 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 06:10:50 EST
Message-ID: <4B0BBBB1.2050100@klingt.org>
Date: Tue, 24 Nov 2009 11:55:45 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] sched_fair.c: remove branch hint
References: <cover.1259059549.git.tim@klingt.org>
In-Reply-To: <cover.1259059549.git.tim@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2F8751BBCE096133A26FE931"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 12:02:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2F8751BBCE096133A26FE931
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

branch hint profiling of my nehalem machine, showed 90% incorrect
branch hints:

15728471 158903754  90 pick_next_task_fair            sched_fair.c
   1555

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e5945df..5a0965c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1552,7 +1552,7 @@ static struct task_struct
*pick_next_task_fair(struct rq *rq)
 	struct cfs_rq *cfs_rq =3D &rq->cfs;
 	struct sched_entity *se;
 -	if (unlikely(!cfs_rq->nr_running))
+	if (!cfs_rq->nr_running)
 		return NULL;
  	do {
--=20
1.6.4.2



--------------enig2F8751BBCE096133A26FE931
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksLu7EACgkQdL+4qsZfVsv45ACfdqjloeb+KIq/Q/edUlX+eX/5
YdMAnRf6g5eoByLgoow75yyzrPDwJ4d1
=jvpK
-----END PGP SIGNATURE-----

--------------enig2F8751BBCE096133A26FE931--
