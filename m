Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbYBNNgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbYBNNgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbYBNNfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:35:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48931 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYBNNfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:35:50 -0500
Date: Fri, 15 Feb 2008 00:35:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: first tree
Message-Id: <20080215003537.8911ce35.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_00_35_37_+1100_is6UIlaZmveSoy+h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_00_35_37_+1100_is6UIlaZmveSoy+h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created the first cut of the linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.

Things to know about this tree:

It has two branches - master and stable.  Stable is currently just Linus'
tree and will never rebase.  Master will rebase on an almost daily basis
(maybe slower at the start).

The tree consists of subsystem git and quilt trees.  Currently, the quilt
trees are integrated by importing them into appropriately based git
branches and then merging those branches.  This has the advantage that
any conflict resolution will onlt have to happen once at the merge point
rather than, possibly, sevveral times during the series.  However, I am
considering just applying the quilt trees on top of the current tree
to get a result more like Linus' tree - we will see. The git trees are
obviously just merged.

Between each merge, the tree was built with both an allmodconfig for both
powerpc and x86_64.

The tree currently contains:
	Greg's driver-core, pci and usb quilt series (in that order)
	Alasdair Kergon's device-mapper quilt tree
	Jiri Kosina's hid git tree
	Jean Delvare's i2c quilt tree
	Randy Dunlap's kernel-doc quilt tree
	Haavard Skinnemoen's avr32 git tree

There was only one unresolved conflict which could have been caused
because I was not sure where to base the kernel-doc tree.

So, comments, please.

Also, more trees please ... :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_00_35_37_+1100_is6UIlaZmveSoy+h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtEOxTgG2atn1QN8RAnz0AKCRvnzfyTKmzwJPw+vWjQnuBra00gCfS866
xSMCnr2ltRt2A9N8RytT6Ls=
=nCpB
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_00_35_37_+1100_is6UIlaZmveSoy+h--
