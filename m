Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZJADT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZJADT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 23:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZJADT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 23:19:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38654 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbZJADT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 23:19:28 -0400
Date: Thu, 1 Oct 2009 13:19:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: linux-next:  tree build failure
Message-Id: <20091001131923.83e6836c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Oct_2009_13_19_23_+1000_bH_GXaghe.FEiPF1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Oct_2009_13_19_23_+1000_bH_GXaghe.FEiPF1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (powerpc allnoconfig) failed like this:

include/linux/blktrace_api.h:215:40: error: macro parameters must be comma-=
separated

Caused by commit 1e03edf3b5b16f7f30fa1e397cc9a130305fa8d3 ("Add missing
blk_trace_remove_sysfs to be in pair with blk_trace_init_sysfs") from the
block tree.  Half way between a static inline and a macro ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Oct_2009_13_19_23_+1000_bH_GXaghe.FEiPF1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrEH7sACgkQjjKRsyhoI8wGfgCgjip4V2YHK3hq5hrDzlXNyUtb
Tp0An1+b6mCtZTieco1qo+XBRuqB3j4O
=wbCm
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Oct_2009_13_19_23_+1000_bH_GXaghe.FEiPF1--
