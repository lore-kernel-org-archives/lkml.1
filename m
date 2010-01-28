Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503Ab0A1BAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0A1BAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359Ab0A1BAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:00:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37813 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab0A1BAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:00:10 -0500
Date: Thu, 28 Jan 2010 12:00:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@redhat.com>
Subject: linux-next: vfs tree build failure
Message-Id: <20100128120000.cd804756.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Jan_2010_12_00_00_+1100_vNptf1sNl3cGhxO/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jan_2010_12_00_00_+1100_vNptf1sNl3cGhxO/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

fs/namei.c: In function 'do_filp_open':
fs/namei.c:1740: error: too many arguments to function 'ima_file_check'
fs/namei.c:1800: error: too many arguments to function 'ima_file_check'

Caused by commit dbcbe631a87d21e429f156edee4ffdeb7dbd84ce ("ima: rename
ima_path_check to ima_file_check").

I have used the vfs tree from next-20100125 again today.

P.S. that commit has author Mimi Zohar <zohar@linux.vnet.ibm.com>, but is
signed off by only Eric Paris <eparis@redhat.com> and Al Viro
<viro@zeniv.linux.org.uk> (and merely acked by Zohar
<zohar@linux.vnet.ibm.com>).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Jan_2010_12_00_00_+1100_vNptf1sNl3cGhxO/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktg4ZAACgkQjjKRsyhoI8xW2wCgt0QxJnepnZIaZdZ9I2jv6EWP
XNsAn3c81ChQNqo7y//HtHX40x+clUMT
=SApo
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jan_2010_12_00_00_+1100_vNptf1sNl3cGhxO/--
