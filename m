Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0BIFhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 00:37:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34990 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0BIFhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 00:37:14 -0500
Date: Tue, 9 Feb 2010 16:37:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with the vfs tree
Message-Id: <20100209163708.b7ae6d05.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Feb_2010_16_37_08_+1100_HCiHHartNOiDc_dj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Feb_2010_16_37_08_+1100_HCiHHartNOiDc_dj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
fs/namei.c between commit 123df2944c436c80640c4281c5bc9c7950b18687 ("Lose
the new_name argument of fsnotify_move()") from the vfs tree and commit
2df5764e29a813f6ba63be094ab8aadc704a78fd ("fsnotify: use unsigned char *
for dentry->d_name.name") from the fsnotify tree.

The former removed the code changed by the latter, so I used the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Feb_2010_16_37_08_+1100_HCiHHartNOiDc_dj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktw9IQACgkQjjKRsyhoI8yHWACcDMPQAzJyY5Tex3nN4Lb58veW
vJQAoK361LhJIR2ZqYrubrp0sOMN1fOA
=CLbM
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Feb_2010_16_37_08_+1100_HCiHHartNOiDc_dj--
