Return-Path: <linux-kernel-owner+w=401wt.eu-S934633AbYCTAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633AbYCTAKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764509AbYCSXVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:21:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60256 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965703AbYCSXVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:21:01 -0400
Date: Thu, 20 Mar 2008 10:20:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
       lenb@kernel.org, greg@kroah.com, akpm@linux-foundation.org, rjw@sisk.pl
Subject: Re: [Build Failure] linux-next: Tree for March 18
Message-Id: <20080320102051.dceba604.sfr@canb.auug.org.au>
In-Reply-To: <20080318132550.GB30500@shadowen.org>
References: <20080318205259.13726d23.sfr@canb.auug.org.au>
	<47DFA49D.4000007@linux.vnet.ibm.com>
	<20080318132550.GB30500@shadowen.org>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_Mar_2008_10_20_51_+1100_OQZGzkAw=glLQVLd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2008_10_20_51_+1100_OQZGzkAw=glLQVLd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Tue, 18 Mar 2008 13:31:10 +0000 Andy Whitcroft <apw@shadowen.org> wrote:
>
> This breakage is shown up when compiled with a config which doesn't have
> CONFIG_PM set.  It is a common error to only test with that turned on
> and I am sure that this is just one of a number of bugs that have been
> picked up by real machine configs.
>=20
> Perhaps it would be worth having one of your integration test runs be
> with a configuration with CONFIG_PM disabled so that they get detected
> earlier in the process.

I have today changed from using powerpc allmodconfig to ppc64_defconfig
which is faster (it was taking over 7-8 hours to create the linux-tree)
and has CONFIG_PM disabled.  I am still also doing the x86_64
allmodconfig build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_Mar_2008_10_20_51_+1100_OQZGzkAw=glLQVLd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH4Z/XTgG2atn1QN8RAsKQAJ4xgufopeSF6tgVd3iLidljV/mI8QCbB4bK
dMpmHqXJTfZQAd2ToYV7h4c=
=onBh
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2008_10_20_51_+1100_OQZGzkAw=glLQVLd--
