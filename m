Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYHFDIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYHFDIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763717AbYHFDIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:08:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58204 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196AbYHFDIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:08:38 -0400
Date: Wed, 6 Aug 2008 13:08:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, mike.miller@hp.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Message-Id: <20080806130825.1567d882.sfr@canb.auug.org.au>
In-Reply-To: <20080805153012.0076396e.akpm@linux-foundation.org>
References: <20080730211842.GF1758@roadking.ldev.net>
	<20080804095633.GA20055@kernel.dk>
	<20080805153012.0076396e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Aug 2008 15:30:12 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> I'm not seeing these changes in linux-next nor in
> master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-=
next
> nor in #for-akpm.

Well linux-next gets its block tree from
git://git.kernel.dk/linux-2.6-block.git#for-next (which appears to be
very similar - if not identical to - the above).

> Also, #for-next is empty, but #for-akpm has the single commit

The for-linus branch seems to have a few commits, though ...
Jens, would you like that in linux-next as block-current (merged early -
meant for bug fixes destined for the current release)?

>         vmsplice: implement real vmsplice to userspace

Yeah, that looks way to scary for linux-next :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiZFakACgkQjjKRsyhoI8ySKgCfcnVYVDm9vas+wVlY5CBBqg1i
bYkAnjg0gCMJI1r8WdrJ1Un1iAmaVfD8
=s7Kl
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ--
