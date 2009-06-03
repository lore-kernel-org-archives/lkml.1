Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZFCIIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZFCIIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbZFCIHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:07:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34506 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264AbZFCIHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:07:40 -0400
Date: Wed, 3 Jun 2009 18:07:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Craig Shelley <craig@microtron.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: linux-next: manual merge of the usb tree with the ttydev tree
Message-Id: <20090603180734.f175e04f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Jun_2009_18_07_34_+1000_XaoKCrXWgL3zv0Aw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jun_2009_18_07_34_+1000_XaoKCrXWgL3zv0Aw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/cp210x.c between commit
d6ba273795c1260745197dc93f64c321c80a5ecc ("tty-usb-use-port") from the
ttydev tree and commit fa9eb42aff8444a67db3136bc405a53882efb14f ("USB:
CP210X Replace CP2101 with CP210x") from the usb tree.

This is really just the same three commits being applied to both trees,
but the ttydev tree has the above commit preceding them.  Maybe Greg you
should rdop these patches ("USB: CP210X Add device IDs", "USB: CP210X Use
official request code definitions", and "USB: CP210X Replace CP2101 with
CP210x") is Craig can verify that they are indeed identical in both trees
(I know the first two are, but the last is different due to the other
changes in the ttydev tree).

As a side issue, the last patch has no SOB from Craig in the ttydev tree.

So, I just used the ttydev tree version on the assumption that my
reasoning above is correct.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Jun_2009_18_07_34_+1000_XaoKCrXWgL3zv0Aw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkomL0YACgkQjjKRsyhoI8x/wACfayx/70VqxfJT1CQ1iB57DQh/
C4UAnAzCiGlDW7yzXRkzdadY3bxe+oIl
=rQL2
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jun_2009_18_07_34_+1000_XaoKCrXWgL3zv0Aw--
