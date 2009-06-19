Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbZFSA2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbZFSA2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZFSA2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:28:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48728 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZFSA2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:28:41 -0400
Date: Fri, 19 Jun 2009 10:28:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: origin tree build warning
Message-Id: <20090619102842.c0d79557.sfr@canb.auug.org.au>
In-Reply-To: <20090619102731.691bd67d.sfr@canb.auug.org.au>
References: <20090619102731.691bd67d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Jun_2009_10_28_42_+1000_EsjcFWVdK28CXsZN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Jun_2009_10_28_42_+1000_EsjcFWVdK28CXsZN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jun 2009 10:27:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

I get the same warning from an x86_64 allmodconfig build as well.

> In file included from include/trace/ftrace.h:262,
>                  from include/trace/define_trace.h:57,
>                  from include/trace/events/ext4.h:720,
>                  from fs/ext4/super.c:51:
> include/trace/events/ext4.h: In function 'ftrace_raw_output_ext4_free_ino=
de':
> include/trace/events/ext4.h:12: warning: format '%llu' expects type 'long=
 long unsigned int', but argument 8 has type 'blkcnt_t'
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Jun_2009_10_28_42_+1000_EsjcFWVdK28CXsZN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko627oACgkQjjKRsyhoI8xGvACgvJmubaQyIv37evGQiGKWuD8A
ftEAn0LvcNwiscp+/8tj8+QLgTg5C8JX
=OuGQ
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Jun_2009_10_28_42_+1000_EsjcFWVdK28CXsZN--
