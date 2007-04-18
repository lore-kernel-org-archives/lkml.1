Return-Path: <linux-kernel-owner+w=401wt.eu-S1422966AbXDRMio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422966AbXDRMio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422967AbXDRMio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:38:44 -0400
Received: from iucha.net ([209.98.146.184]:35964 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422966AbXDRMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:38:43 -0400
Date: Wed, 18 Apr 2007 07:38:42 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418123842.GF24044@iucha.net>
References: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org> <20070417195823.943f9472.akpm@linux-foundation.org> <1176865565.6796.16.camel@heimdal.trondhjem.org> <20070418033055.GA24044@iucha.net> <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <20070417223738.8f49a39f.akpm@linux-foundation.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2007 at 10:37:38PM -0700, Andrew Morton wrote:
> Florin, can we please see /proc/meminfo as well?

   http://iucha.net/nfs/21-rc7-nfs2/meminfo

> Also the result of `echo m > /proc/sysrq-trigger'

   http://iucha.net/nfs/21-rc7-nfs2/big-copy

This has 'echo m > /proc/sysrq-trigger', 'echo t >
/proc/sysrq-trigger' and 'echo 0 > /proc/sys/sunrpc/rpc_debug'.

The output from the server's 'iostat 5' is at

   http://iucha.net/nfs/21-rc7-nfs2/iostat

This run it copied 5.6G (vs yesterday's 2.5G).

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJhFSND0rFCN2b1sRAvIxAKCgLo11F43vX47b6AJlX+xwc2o8/QCePJ54
N9/0DIxm7etG+aCP2JOaYFU=
=7bYR
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
