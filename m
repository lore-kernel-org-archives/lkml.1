Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbZJIAWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbZJIAWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 20:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbZJIAWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 20:22:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59521 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbZJIAWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 20:22:48 -0400
Date: Fri, 9 Oct 2009 11:21:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kyle McMartin <kyle@mcmartin.ca>, <linux-parisc@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the parisc tree with Linus' tree
Message-Id: <20091009112158.7d37ed23.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Oct_2009_11_21_58_+1100_J6RvzgaLr98JJIIY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Oct_2009_11_21_58_+1100_J6RvzgaLr98JJIIY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the parisc tree got conflicts in
arch/parisc/include/asm/thread_info.h and arch/parisc/kernel/entry.S
between commit d0420c83f39f79afb82010c2d2cafd150eef651b ("KEYS: Extend
TIF_NOTIFY_RESUME to (almost) all architectures [try #6]") from Linus'
tree and commit 9f4259771faf1ffd99888796d925adae4c93630b ("parisc: add
TIF_NOTIFY_RESUME and use tracehook_notify_resume") from the parisc tree.

It looks like the parisc tree version is a superset of the version in
Linus' tree (for parisc).  I fixed it up (hopefully - using the parisc
tree versions) and can carry the fix for a while.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Oct_2009_11_21_58_+1100_J6RvzgaLr98JJIIY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrOgiYACgkQjjKRsyhoI8xQhACeOuI78SNvXU7t3VV9JEEhqKBz
GUIAn0IWXIkFGxiD7SDRT2zY4bUtzAzu
=Am0X
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Oct_2009_11_21_58_+1100_J6RvzgaLr98JJIIY--
