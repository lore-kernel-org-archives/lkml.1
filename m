Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350Ab0AHFQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab0AHFQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144Ab0AHFQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:16:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49319 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0AHFQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:16:45 -0500
Date: Fri, 8 Jan 2010 16:16:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: linux-next: nfs/ceph tree build failure
Message-Id: <20100108161636.f68b72b6.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.1001072048420.7474@cobra.newdream.net>
References: <20100108111136.3feae8c6.sfr@canb.auug.org.au>
	<1262909913.2659.47.camel@localhost>
	<20100108121903.6a096bc1.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.1001072048420.7474@cobra.newdream.net>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Jan_2010_16_16_36_+1100_Iw+OGCPxUHf6PhST"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Jan_2010_16_16_36_+1100_Iw+OGCPxUHf6PhST
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

On Thu, 7 Jan 2010 20:51:45 -0800 (PST) Sage Weil <sage@newdream.net> wrote:
>
> Okay.  I can move it to my tree as well, where I assume it'll need to be=
=20
> when it comes time to merge.

Well, that depends on the order that the two trees get merged into Linus'
tree.  If you get in first, then Trond will have to fix up his tree
before merging (or get Linus to apply my patch as a merge fixup).

One possible thing you could do is to apply both the nfs tree patch and
my patch to your tree (or merge the nfs tree into your tree and apply the
merge fixup), but that will cause a problem if the patch is updated in
the nfs tree (or the nfs tree rebases) ...

So the easiest thing (at leas at this early stage of the development
cycle) is for me to keep applying the merge fixup to my tree when I merge
the later of your two trees into linux-next (this is an automated
process).  Maybe in a few weeks we might do something different.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Jan_2010_16_16_36_+1100_Iw+OGCPxUHf6PhST
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktGv7QACgkQjjKRsyhoI8yKSwCgk/g/eF0VGWujsVYMXTCbMwZZ
QE8AoJ6rljv+LFZDqh/Iy28f2xf6zc+a
=mAUa
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Jan_2010_16_16_36_+1100_Iw+OGCPxUHf6PhST--
