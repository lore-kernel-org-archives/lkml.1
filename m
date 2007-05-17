Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbXEQVuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbXEQVuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbXEQVuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:50:39 -0400
Received: from iucha.net ([209.98.146.184]:60376 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXEQVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:50:38 -0400
Date: Thu, 17 May 2007 16:50:36 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG with today's git
Message-ID: <20070517215036.GE28039@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R6sEYoIZpp9JErk7"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--R6sEYoIZpp9JErk7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Kernel: v2.6.22-rc1-g0479ea0

Got this in the logs:

[ 8314.672340] BUG: at fs/inotify.c:172 set_dentry_child_flags()
[ 8314.672345]
[ 8314.672346] Call Trace:
[ 8314.672353]  [<ffffffff8054a44c>] _spin_lock+0x9/0xb
[ 8314.672361]  [<ffffffff8029fc0f>] set_dentry_child_flags+0x6d/0x14f
[ 8314.672366]  [<ffffffff8029fd59>] remove_watch_no_event+0x68/0x78
[ 8314.672370]  [<ffffffff8029fe5d>] inotify_remove_watch_locked+0x18/0x3a
[ 8314.672374]  [<ffffffff802a0164>] inotify_rm_wd+0x87/0xad
[ 8314.672378]  [<ffffffff802a07b3>] sys_inotify_rm_watch+0x4e/0x6d
[ 8314.672383]  [<ffffffff8020975e>] system_call+0x7e/0x83
[ 8314.672387]

Machine was mostly idle.  A movie dvd was in the DVD-ROM, but not being pla=
yed.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--R6sEYoIZpp9JErk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGTM4sND0rFCN2b1sRAj7IAJ9skarEfrPXip6hbxRpXcsQ6BdaoQCfSYL7
elhYUQMqTx1BDWpjkvYWgHc=
=9IbW
-----END PGP SIGNATURE-----

--R6sEYoIZpp9JErk7--
