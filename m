Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbXKFGqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbXKFGqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXKFGqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:46:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60730 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbXKFGqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:46:30 -0500
Date: Tue, 6 Nov 2007 17:46:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David <david@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
 startup
Message-Id: <20071106174626.3c7d3a14.sfr@canb.auug.org.au>
In-Reply-To: <472F5F8B.7090200@unsolicited.net>
References: <472F5F8B.7090200@unsolicited.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Nov_2007_17_46_26_+1100_8xmxNkw/AX+AIC9W"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Nov_2007_17_46_26_+1100_8xmxNkw/AX+AIC9W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Nov 2007 18:23:07 +0000 David <david@unsolicited.net> wrote:
>
> I've been testing rc1 for a week or so, and about 25% of the time I'm
> seeing Firefox and Thunderbird getting stuck in 'D' state as they startup.
>=20
> I've attached the output of Sysrq-T to this mail... system is a
> dual-core AMD64, and files are on a RAID-1 root partition connected two
> SATA disks on the on-board NVidia controller. I've had no problems
> before .24 rc1

I am seeing something very similar on a PowerPC machine where copying a
file from an LVM volume with ext3 on it to a simple scsi partition (again
ext3) on the same disk will hang in congestion_wait.  If I am patient
enough, the copy makes very slow progress.  A kill -9 will kill it
eventually, but a simple control-C will not.

This hang occurs more often than not (and usually when I am trying to
install a new kernel into /boot for testing :-)).

I don't have access to the machine today, but if more information would
be useful, I could boot into 2.6.24-rc1-<mumble> again tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Nov_2007_17_46_26_+1100_8xmxNkw/AX+AIC9W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHMA3ITgG2atn1QN8RAuukAJ4wpCSvsropRp2Y7AnacEnfVnQxuwCfRaaq
Z3zJZVqq5SNmhKH3+PyXVO8=
=os0F
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Nov_2007_17_46_26_+1100_8xmxNkw/AX+AIC9W--
