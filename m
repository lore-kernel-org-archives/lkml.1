Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZFIBg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZFIBg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZFIBgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:36:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35538 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZFIBgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:36:49 -0400
Date: Tue, 9 Jun 2009 11:36:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Frysinger <vapier@gentoo.org>
Subject: linux-next: manual merge of the kbuild tree with the x86 tree
Message-Id: <20090609113646.975023d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_11_36_46_+1000_dbSFb4zWV9.6Z8U0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_11_36_46_+1000_dbSFb4zWV9.6Z8U0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

Today's linux-next merge of the kbuild tree got a conflict in
scripts/Makefile.lib between commit
d3dd3b5a29bb9582957451531fed461628dfc834 ("kbuild: allow compressors
(gzip, bzip2, lzma) to take multiple inputs") from the x86 tree and
commit c3434a63db85504449450625f229441c256b6f47 ("kbuild: fix spacing for
bzip2 commands") from the kbuild tree.

I used the version from the x86 tree which, as a side affect, fixed the
same spacing issue as the kbuild patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_11_36_46_+1000_dbSFb4zWV9.6Z8U0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkotvK4ACgkQjjKRsyhoI8w0jQCfZl+AReI7rZ5+bxn/8rLhKwNv
7T8An3SrNvdb5ekeQHScF99kaS2qBvZN
=s9z2
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_11_36_46_+1000_dbSFb4zWV9.6Z8U0--
