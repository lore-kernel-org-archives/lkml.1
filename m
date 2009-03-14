Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZCNN3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZCNN3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZCNN3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:29:38 -0400
Received: from mail.klingt.org ([86.59.21.178]:46126 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZCNN3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:29:38 -0400
Date: Sat, 14 Mar 2009 14:29:25 +0100
From: Tim Blechmann <tim@klingt.org>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: include missing header
Message-ID: <20090314142925.49c29c17@thinkpad>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yrDKkYPq9OzD.lsJEp+tX0+";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2b1 (klingt.org [127.0.0.1]); Sat, 14 Mar 2009 14:29:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yrDKkYPq9OzD.lsJEp+tX0+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Impact: compile fix

In order to compile a kernel with performance counter patches,
<asm/irq_regs.h> has to be included to provide the declaration of
struct pt_regs *get_irq_regs(void);

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 kernel/perf_counter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d6cc222..0018c5e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -24,6 +24,8 @@
 #include <linux/vmstat.h>
 #include <linux/rculist.h>
=20
+#include <asm/irq_regs.h>
+
 /*
  * Each CPU has a list of per CPU counters:
  */
--=20
1.6.2

--Sig_/yrDKkYPq9OzD.lsJEp+tX0+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm7sTUACgkQdL+4qsZfVssJRwCeNEYFtLe2mgZEeWNAHh6dhgsi
KIMAoJEQXCRUAJpzxbrNtCtbZIpsWdh/
=1QqL
-----END PGP SIGNATURE-----

--Sig_/yrDKkYPq9OzD.lsJEp+tX0+--
