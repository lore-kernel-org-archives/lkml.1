Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbZHSGIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbZHSGIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 02:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZHSGII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 02:08:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53942 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZHSGIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 02:08:07 -0400
Date: Wed, 19 Aug 2009 16:07:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20090819160758.f23f2e8a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_Aug_2009_16_07_58_+1000_/0rZynifDzzLkPXM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Aug_2009_16_07_58_+1000_/0rZynifDzzLkPXM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/irq/manage.c between commit
69ab849439b506cd8dd2879527fdb64d95dd5211 ("genirq: Wake up irq thread
after action has been installed") from Linus' tree and commit
3c26caa7409ad5367b257de3d7943551d4a959ee ("genirq: Do not wakeup irq
thread from __setup_irq() and set action->irq") from the tip tree.

I used the version from Linus' tree (as seems to have been done in
tip:master).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_Aug_2009_16_07_58_+1000_/0rZynifDzzLkPXM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqLlr4ACgkQjjKRsyhoI8wWWgCfV+z70IlO0JkIwx5Ol6rXsPxc
vmgAn0DpQ6+eNtZq/pIOfzC2+vtvF6hW
=PEyf
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Aug_2009_16_07_58_+1000_/0rZynifDzzLkPXM--
