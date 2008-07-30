Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYG3BGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYG3BGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYG3BGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:06:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35986 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbYG3BGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:06:11 -0400
Date: Wed, 30 Jul 2008 11:05:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dave Hansen <haveblue@us.ibm.com>, Greg KH <gregkh@suse.de>
Subject: linux-next: usb tree fix (Was: Re: linux-next: Tree for July 29)
Message-Id: <20080730110554.9bea652b.sfr@canb.auug.org.au>
In-Reply-To: <200807291825.14281.bzolnier@gmail.com>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
	<200807291825.14281.bzolnier@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Jul_2008_11_05_54_+1000_prON2WuAu/Wt0a3u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jul_2008_11_05_54_+1000_prON2WuAu/Wt0a3u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Tue, 29 Jul 2008 18:25:14 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmai=
l.com> wrote:
>
> I keep reverting commit 0e3638d1e04040121af00195f7e4628078246489 ("warn
> when statically-allocated kobjects are used") with each linux-next release
> to make it work on my x86_32 laptop (http://lkml.org/lkml/2008/7/19/114).
>=20
> Depending on the day I either forget to revert it on a first try or (lead=
 by
> incurable optimism) I don't try to revert it in hope that it was fixed.
>=20
> Unfortunately the result is always the same cursing-during-qemu-test-run
> -> git-revert -> recompile cycle and a needless time loss.
>=20
> Could we have some action taken please?

I have reverted that commit from linux-next today (its id has changed)
and will do so until Greg or Dave tells me it has been fixed.  To make
life easier for me, Greg, it would be nice if you removed it from your
series until that time.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Jul_2008_11_05_54_+1000_prON2WuAu/Wt0a3u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiPvnIACgkQjjKRsyhoI8yYlACfcon67OzGYl8U58qJ3dhElYZY
MQkAoKN/hgaapfv7rlhfGBP80E2FOYeK
=oWPq
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jul_2008_11_05_54_+1000_prON2WuAu/Wt0a3u--
