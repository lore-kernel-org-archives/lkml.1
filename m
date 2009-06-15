Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZFODch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZFODch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZFODc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:32:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39957 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbZFODc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:32:27 -0400
Date: Mon, 15 Jun 2009 13:32:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs-client@lists.samba.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Layton <jlayton@redhat.com>
Subject: linux-next: cifs tree build failure
Message-Id: <20090615133222.7405743c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Jun_2009_13_32_22_+1000_vzzZ2=1Gn4zceJ3."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jun_2009_13_32_22_+1000_vzzZ2=1Gn4zceJ3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

fs/cifs/cifsfs.c: In function 'cifs_show_options':
fs/cifs/cifsfs.c:357: error: implicit declaration of function 'cifs_show_ad=
dress'

Caused by commit 8616e0fc1e27295316f9821a883f0e9fa6f8200f ("cifs: remove
unneeded NULL checks from cifs_show_options").

I have used the cifs tree from next-20090612 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Jun_2009_13_32_22_+1000_vzzZ2=1Gn4zceJ3.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1wMYACgkQjjKRsyhoI8y7SQCeLQZchWqkPZwHOiDJpR9hcb0d
ry8An00O3QJAIej8Dj7vTFMYwcz17nS7
=LzEA
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jun_2009_13_32_22_+1000_vzzZ2=1Gn4zceJ3.--
