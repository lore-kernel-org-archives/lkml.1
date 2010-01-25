Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168Ab0AYEQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab0AYEQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 23:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953Ab0AYEQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 23:16:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38478 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab0AYEQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 23:16:24 -0500
Date: Mon, 25 Jan 2010 15:16:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: vfs/fsnotify trees build warning
Message-Id: <20100125151617.4a91ad17.sfr@canb.auug.org.au>
In-Reply-To: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
References: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Jan_2010_15_16_17_+1100_abtMc/8xde6DcRBF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jan_2010_15_16_17_+1100_abtMc/8xde6DcRBF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric, Al,

On Mon, 25 Jan 2010 15:04:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:

These warnings only appear after I merge the fsnotify tree into
linux-next.  The vfs tree has been merged much earlier.  So at least the
first of these is introduced by a vfs tree commit
(82a1dff3ed894a3b453474f168d55381a1e7318c "Lose the new_name argument of
fsnotify_move()") but only exposed by the merge of the fsnotify tree.

> In file included from include/linux/security.h:26,
>                  from fs/xfs/linux-2.6/xfs_iops.c:56:
> include/linux/fsnotify.h: In function 'fsnotify_move':
> include/linux/fsnotify.h:87: warning: pointer targets in initialization d=
iffer in signedness

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Jan_2010_15_16_17_+1100_abtMc/8xde6DcRBF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktdGxEACgkQjjKRsyhoI8wnoACeNO64tUszk8YPzBu0bilaIy4f
vnoAoImMEbPY07UsIP5wV/7bWc5R6hxH
=6Q7H
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jan_2010_15_16_17_+1100_abtMc/8xde6DcRBF--
