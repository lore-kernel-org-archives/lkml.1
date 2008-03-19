Return-Path: <linux-kernel-owner+w=401wt.eu-S1764474AbYCSWLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764474AbYCSWLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759278AbYCSUfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:35:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41054 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934088AbYCSUfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:35:01 -0400
Date: Wed, 19 Mar 2008 19:44:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 19
Message-Id: <20080319194423.ac73400e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_Mar_2008_19_44_23_+1100_Rd3y+OY/Xn0JtfZK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Mar_2008_19_44_23_+1100_Rd3y+OY/Xn0JtfZK
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
allmodconfig for both powerpc and x86_64.

I have started this tree by reverting the following:
driver-core/driver-core-remove-no-longer-used-struct-class_device.patch
	should be merged late
driver-core/ib-convert-struct-class_device-to-struct-device.patch
	conflicts with the infiniband tree
driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
	breaks non CONFIG_PM builds of drivers/serial/serial_core.c

There were a couple of merge conflicts (fairly trivial).  And four
build breaks (two of which which actually happened yesterday/Monday but
not in the configs I build).  Notifications have been sent.

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

--Signature=_Wed__19_Mar_2008_19_44_23_+1100_Rd3y+OY/Xn0JtfZK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH4NJvTgG2atn1QN8RAnwJAJ9ggf4CbTuLhL/1UsD2lr5EFLH6cACeP4RQ
Atmc8+OJ/yLh0/8gcPTeHMw=
=WBOW
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Mar_2008_19_44_23_+1100_Rd3y+OY/Xn0JtfZK--
