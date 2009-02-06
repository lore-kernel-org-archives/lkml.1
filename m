Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZBFGEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZBFGEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZBFGEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:04:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58758 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZBFGEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:04:32 -0500
Date: Fri, 6 Feb 2009 17:04:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/15] ide: add "flagged" taskfile flags to struct
 ide_taskfile
Message-Id: <20090206170425.201346e6.sfr@canb.auug.org.au>
In-Reply-To: <20090201175012.19144.87417.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
	<20090201175012.19144.87417.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Feb_2009_17_04_25_+1100_dnkpqyns83Q/12r/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Feb_2009_17_04_25_+1100_dnkpqyns83Q/12r/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Sun, 01 Feb 2009 18:50:12 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmai=
l.com> wrote:
>
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: add "flagged" taskfile flags to struct ide_taskfile
>=20
> * Add ->ftf_flags field to struct ide_taskfile
>   and convert flags for TASKFILE ioctl to use it.
>=20
> * Rename "flagged" taskfile flags:
>   - IDE_TFLAG_FLAGGED -> IDE_FTFLAG_FLAGGED

There were several places where this transformation did not take place as
shown by today's linux-next build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Feb_2009_17_04_25_+1100_dnkpqyns83Q/12r/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmL0ukACgkQjjKRsyhoI8x6PgCfZFitULk1WqOrpj3cfZ22JXcC
wBkAn0rAVkGuIg9VEtrN+9pDQ7v+4f7k
=Fs/n
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Feb_2009_17_04_25_+1100_dnkpqyns83Q/12r/--
