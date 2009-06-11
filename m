Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbZFKE4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbZFKE4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 00:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZFKEzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 00:55:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39088 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbZFKEzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:55:48 -0400
Date: Thu, 11 Jun 2009 14:55:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sergey Lapin <slapin@ossfans.org>
Subject: linux-next: net tree build warnings
Message-Id: <20090611145541.2570a43d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Jun_2009_14_55_41_+1000_LJC_j=diE6zxirMu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jun_2009_14_55_41_+1000_LJC_j=diE6zxirMu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

net/ieee802154/raw.c: In function 'raw_sendmsg':
net/ieee802154/raw.c:135: warning: format '%u' expects type 'unsigned int',=
 but argument 2 has type 'size_t'
net/ieee802154/dgram.c: In function 'dgram_sendmsg':
net/ieee802154/dgram.c:251: warning: format '%u' expects type 'unsigned int=
', but argument 2 has type 'size_t'

Introduced by commit 9ec7671603573ede31207eb5b0b3e1aa211b2854 ("net: add
IEEE 802.15.4 socket family implementation").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Jun_2009_14_55_41_+1000_LJC_j=diE6zxirMu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkowjk0ACgkQjjKRsyhoI8zGpACfUpW/mT9nbl/1sbC2ockEMvnw
CjQAn2VRcsLTbeOEU4rvV4i6NymnHXT7
=9hny
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jun_2009_14_55_41_+1000_LJC_j=diE6zxirMu--
