Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZFJEix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZFJEix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 00:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZFJEiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 00:38:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35817 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZFJEip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 00:38:45 -0400
Date: Wed, 10 Jun 2009 14:38:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andre Noll <maan@systemlinux.org>
Subject: linux-next: manual merge of the md tree with the  tree
Message-Id: <20090610143801.cce5f7cf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_14_38_01_+1000_ab7S=J9ohlqQM/jW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_14_38_01_+1000_ab7S=J9ohlqQM/jW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next merge of the md tree got a conflict in
drivers/md/raid5.c between commit
0e6e0271a210817e202c8a4bfffbde3e3c0616d1 ("md/raid5: fix bug in reshape
code when chunk_size decreases") from the md-current tree and commit
dbf4da18b39fd412a76c3e1b9d7b29c8cc0197fb ("md: convert conf->chunk_size
and conf->prev_chunk to sectors") from the md tree.

Overlapping changes.  I used the version from the md-current tree
(stripe_addr+reshape_sectors) as it appears to be newer.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_14_38_01_+1000_ab7S=J9ohlqQM/jW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovOKoACgkQjjKRsyhoI8xFxQCdFjPeR0O3B+ucEV1IOlAczdfM
ftgAn2NPkfil8vVfCUfcEWd7oshGCYfO
=0qdP
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_14_38_01_+1000_ab7S=J9ohlqQM/jW--
