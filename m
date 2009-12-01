Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZLAHcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZLAHcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZLAHcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:32:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48786 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZLAHcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:32:01 -0500
Date: Tue, 1 Dec 2009 18:32:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, steved@redhat.com, jens.axboe@oracle.com,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-next@vger.kernerl.org
Subject: Re: [PATCH] slow-work: Fix build bug in the !CONFIG_MODULES case
Message-Id: <20091201183201.0c56f119.sfr@canb.auug.org.au>
In-Reply-To: <20091201065605.GA5361@elte.hu>
References: <13590.1258714119@redhat.com>
	<17633.1258758083@redhat.com>
	<20091201065605.GA5361@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Dec_2009_18_32_01_+1100_A/8NxXBpJ+bu.bg1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Dec_2009_18_32_01_+1100_A/8NxXBpJ+bu.bg1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 1 Dec 2009 07:56:05 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> these slow-work changes have introduced a new !CONFIG_MODULES build bug=20
> on x86 (and all other architectures i suspect):

Thanks for the heads up!

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 1 Dec 2009 07:47:52 +0100
> Subject: [PATCH] slow-work: Fix build bug in the !CONFIG_MODULES case
>=20
> Commit 3bde31a ("SLOW_WORK: Allow a requeueable work item to sleep till
> the thread is needed") broke the !CONFIG_MODULES build by relying on
> variables that are only available (and only make sense) with module
> support enabled. Fix it.
>=20
> Cc: David Howells <dhowells@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

I have applied this to linux-next for today, just so people don't waste
their time finding this breakage again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Dec_2009_18_32_01_+1100_A/8NxXBpJ+bu.bg1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksUxnEACgkQjjKRsyhoI8zrOQCdGUX9869LfYupYRS9+hDWghuG
BjEAnAmSpcdV5+q689CfLrcZb2uZfimf
=1L1s
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Dec_2009_18_32_01_+1100_A/8NxXBpJ+bu.bg1--
