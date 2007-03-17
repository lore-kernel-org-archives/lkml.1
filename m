Return-Path: <linux-kernel-owner+w=401wt.eu-S965662AbXCQOmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbXCQOmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965647AbXCQOmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:42:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49083 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965662AbXCQOmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:42:11 -0400
Date: Sun, 18 Mar 2007 01:42:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Paul Mackerras <paulus@samba.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-Id: <20070318014214.bd7ce48a.sfr@canb.auug.org.au>
In-Reply-To: <20070318013838.d00d420e.sfr@canb.auug.org.au>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<17915.48105.70494.958220@cargo.ozlabs.ibm.com>
	<20070317110706.GB29931@parisc-linux.org>
	<20070317143043.GA8577@osiris.ibm.com>
	<20070318013838.d00d420e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__18_Mar_2007_01_42_14_+1100_F1IKO8d_lae5GUnw"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__18_Mar_2007_01_42_14_+1100_F1IKO8d_lae5GUnw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Sun, 18 Mar 2007 01:38:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Sat, 17 Mar 2007 15:30:43 +0100 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> >
> > sys_sync_file_range(int fd, loff_t offset, loff_t nbytes, unsigned int flags)
> >
> > But from what I read, it's currently not possible for 32-bit powerpc to
> > wire up the already present sync_file_range system call.
>
> 32bit native is fine (as the ABI in user mode is the same as that in the

Sorry, I take that back ...

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__18_Mar_2007_01_42_14_+1100_F1IKO8d_lae5GUnw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+/5MFdBgD/zoJvwRAqmAAJ4l3dpzjhJtieFkiWyo6Ert8Ua8EQCfR2cF
cGgls4pRiPxNQNH1AgKchbU=
=mGuz
-----END PGP SIGNATURE-----

--Signature=_Sun__18_Mar_2007_01_42_14_+1100_F1IKO8d_lae5GUnw--
