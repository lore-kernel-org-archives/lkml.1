Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZLGJDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZLGJDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbZLGJDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:03:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55539 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237AbZLGJDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:03:42 -0500
Date: Mon, 7 Dec 2009 20:03:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: input tree build failure
Message-Id: <20091207200344.01323cb5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Dec_2009_20_03_44_+1100_TT0ptRm63hu/WCLA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Dec_2009_20_03_44_+1100_TT0ptRm63hu/WCLA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/input/sparse-keymap.c:101: error: __ksymtab_sparse_keymap_setkeycod=
e causes a section type conflict

Caused by commit a2dd9f7ceeb28f495587834aa5778c721611d61b ("Input: add
generic support for sparse keymaps").

static functions should not given to EXPORT_SYMBOL().

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Dec_2009_20_03_44_+1100_TT0ptRm63hu/WCLA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkscxPAACgkQjjKRsyhoI8x38gCdHnlLDc9/m2N2NYopnNBBDT6Y
M0kAn2j8UehX5/K8aW9kCtW8cZwviL88
=1AB5
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Dec_2009_20_03_44_+1100_TT0ptRm63hu/WCLA--
