Return-Path: <linux-kernel-owner+w=401wt.eu-S1765163AbYDVPFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765163AbYDVPFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763594AbYDVPFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:05:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45733 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762821AbYDVPFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:05:06 -0400
Date: Wed, 23 Apr 2008 01:04:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Linus' tree build breakage
Message-Id: <20080423010458.4114ec83.sfr@canb.auug.org.au>
In-Reply-To: <20080422073622.GB22955@flint.arm.linux.org.uk>
References: <20080422103111.e1d38371.sfr@canb.auug.org.au>
	<20080422073622.GB22955@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Apr_2008_01_04_58_+1000_dfP4Sj6wJCFsQ4zh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Apr_2008_01_04_58_+1000_dfP4Sj6wJCFsQ4zh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Tue, 22 Apr 2008 08:36:22 +0100 Russell King <rmk+lkml@arm.linux.org.uk>=
 wrote:
>
> linux-next will not give me anything which -mm isn't giving me.  As I
> said in the discussion, linux-next value is _very_ small for me.

Let me try again (others may want to read as well).

What you get:
	- 5 times a week your tree gets merged with lots of other code
	  destined for Linus' next release.  From this you get to find
	  out about things in other trees that clash with yours.
	- This tree gets built on several architectures for several configs
	  (including arm).  So you find out if other trees will break yours.
	- I am happy to build more (basically all) the arm configs as I
	  have offered before.

What others get:
	- You get told if your changes clash or break other's changes.
	- They get told if your tree may require changes to theirs.

What it costs:
	- you need to create a tree (o quilt series) that contains the
	  changes you expect to submit to Linus in the next merge window.
	  This is not so different from the tree you currently send to
	  Andrew (and is probably a subset of that). You update this tree
	  as you want to and I fetch it at least daily.
	- Reading a few extra emails if/when I find problems that may
	  concern you.

Thanks for listening.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Apr_2008_01_04_58_+1000_dfP4Sj6wJCFsQ4zh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDf6gTgG2atn1QN8RAtvxAJ9Iy+cu9cDagdiiyBr1snqyHws7GgCdFvG0
OIHqbNJUNkZ3jbkJfJfjjUk=
=URUo
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Apr_2008_01_04_58_+1000_dfP4Sj6wJCFsQ4zh--
