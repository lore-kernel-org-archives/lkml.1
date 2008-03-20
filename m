Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYCTDk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYCTDk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 23:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYCTDkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 23:40:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52453 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYCTDkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 23:40:03 -0400
Date: Thu, 20 Mar 2008 14:39:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Dan Williams <dan.j.williams@intel.com>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       Theodore Tso <tytso@MIT.EDU>
Subject: linux-next: Tree for March 20
Message-Id: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_Mar_2008_14_39_53_+1100_ecMRR1VnOfDA4o_e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2008_14_39_53_+1100_ecMRR1VnOfDA4o_e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64.

I have started this tree by reverting the following:
driver-core/driver-core-remove-no-longer-used-struct-class_device.patch
	should be merged late
driver-core/ib-convert-struct-class_device-to-struct-device.patch
	conflicts with the infiniband tree
driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
	breaks non CONFIG_PM builds of drivers/serial/serial_core.c

There were a few merge conflicts (fairly trivial).

I have added POWERPC-really-export-empty_zero_page.patch and reverted
async-tx commit 9974693221954ef1019f87d32ae26a0757d2ee85 ("dmaengine: ack
to flags: make use of the unused bits in the 'ack' field") as these are
still needed to make powerpc allmodconfig build (in particular ext4 and
drivers/dma/fsldma.c).  These have been reported previously.

We are up to 48 trees, more are welcome (even if they are currently
empty).  The influx of new trees has slowed completely.  Thanks to those
who have contributed, and to those who haven't, please do.

In particular, I have very few of the architecture trees ....

Status of my local build tests is at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Mar_2008_14_39_53_+1100_ecMRR1VnOfDA4o_e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH4dyOTgG2atn1QN8RAiSwAKCYgkV/2MKAASbFmiG0ZJaRNhY70gCcCVHP
oG/07++gRxyKK1A1WvYcMNE=
=qBcF
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2008_14_39_53_+1100_ecMRR1VnOfDA4o_e--
