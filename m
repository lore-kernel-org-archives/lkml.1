Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZFXH2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZFXH2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZFXH1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:27:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55574 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFXH1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:27:54 -0400
Date: Wed, 24 Jun 2009 17:27:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Joel Becker <Joel.Becker@oracle.com>,
       =?UTF-8?B?IkZyw6lkw6lyaWMgV2Vpc2Jl?= =?UTF-8?B?Y2tlciI=?= 
	<fweisbec@gmail.com>,
       Len Brown <lenb@kernel.org>, Avi Kivity <avi@qumranet.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>, Boaz Harrosh <bharrosh@panasas.com>,
       Jon Masters <jonathan@jonmasters.org>, Greg KH <greg@kroah.com>
Subject: Main things left in linux-next
Message-Id: <20090624172735.9b500674.sfr@canb.auug.org.au>
In-Reply-To: <20090624164617.b7c49974.sfr@canb.auug.org.au>
References: <20090624164617.b7c49974.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Jun_2009_17_27_35_+1000_xyVrSPE3ISmiD_1y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jun_2009_17_27_35_+1000_xyVrSPE3ISmiD_1y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

$ git diff --shortstat -M stable..HEAD^
 587 files changed, 27313 insertions(+), 12317 deletions(-)

We seem to be going backwards :-( Yesterday's was:
 556 files changed, 27596 insertions(+), 7123 deletions(-)

$ git diff --dirstat -M stable..HEAD^
   4.9% Documentation/powerpc/dts-bindings/
   5.1% Documentation/powerpc/
   3.0% Documentation/vm/
   3.9% arch/sparc/
   3.9% arch/x86/kvm/
   4.4% arch/x86/
   6.9% drivers/md/
   4.7% drivers/misc/
   9.8% drivers/staging/et131x/
   4.3% drivers/staging/
   6.6% drivers/usb/otg/
  14.5% drivers/
   5.5% include/linux/
  12.6% mm/

The main obvious things left are:

SLQB from the slab tree
an m68k update
an ocfs2 update
the reiserfs kill-the-bkl effort
an acpi update
a kvm update
some more cpumask work from the rr tree
the writeback changes form the block tree
a device-mapper update
a battery tree update
a leds tree update
osdblk from the osd tree
the new hwlat tree
devtmpfs from the driver-core tree (hmmm?)

Please do not shoot the messenger. :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Jun_2009_17_27_35_+1000_xyVrSPE3ISmiD_1y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpB1WcACgkQjjKRsyhoI8x4dgCfZw7Uzp5f6BlAH/jepn+aiQ6Y
VMcAn1NNwsV+J6J7vRqEd25OI1xZ0SMk
=cOOS
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jun_2009_17_27_35_+1000_xyVrSPE3ISmiD_1y--
