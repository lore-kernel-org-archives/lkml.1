Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZLNDjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZLNDjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZLNDjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:39:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49836 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZLNDjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:39:16 -0500
Date: Mon, 14 Dec 2009 14:39:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the limits tree with Linus' tree
Message-Id: <20091214143909.a7b6dcf1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Dec_2009_14_39_09_+1100_hdH.BnlHivSbah_O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Dec_2009_14_39_09_+1100_hdH.BnlHivSbah_O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the limits tree got a conflict in
arch/ia64/kernel/sys_ia64.c between commit
bb52d6694002b9d632bb355f64daa045c6293a4e ("Get rid of open-coding in
ia64_brk()") from Linus' tree and commit
d9ef7d0ce61f214180f505b78cdf8f9b3d862dfa ("IA64: use helpers for
rlimits") from the limits tree.

The former removed the code that the latter was updating.  A merge with
Linus' tree will fix this up, but it is pretty trivial anyway.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Dec_2009_14_39_09_+1100_hdH.BnlHivSbah_O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksls10ACgkQjjKRsyhoI8z8+wCgmi0vr+SqTqMurpocUzgHTKX2
EWMAnRJl3XExAFGnJ4Mp3ozJTjmtPhTJ
=yD6L
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Dec_2009_14_39_09_+1100_hdH.BnlHivSbah_O--
