Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYBRFFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYBRFFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYBRFFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:05:13 -0500
Received: from mal35-2-82-225-70-234.fbx.proxad.net ([82.225.70.234]:59433
	"EHLO mal35-2-82-225-70-234.fbx.proxad.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbYBRFFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:05:12 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2008 00:05:11 EST
Date: Mon, 18 Feb 2008 05:54:25 +0100
From: Wael Nasreddine <mla@nasreddine.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: iwl3945 not working properly.
Message-ID: <20080218045425.GA7381@phoenix.nasreddine.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
X-OS: Linux 2.6.24-tuxonice-r2 i686
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled Feb  4 2008 15:13:47)
X-PGP-Key: http://wael.nasreddine.com/files/Wael_Nasreddine.asc
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I have a Toshiba Satellite A135-S4427 with and Intel 3945ABG card, the
driver is not working properly.

When I turn on my PC it works fine, but If I ever bring the interface
down, I no longer can associate it with any AP without rebooting, even
the one I was using, I tried rmmod/modprobe iwl3945, didn't do
anything,

iwconfig shows that the wlan0 has the radio turned off, and

$ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
1

Even If I echo 0 > /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
whenever I try to associate the interface with an AP it turns back to
1, I tried both iwconfig and NetworkManager, same problem.

There's a button on my laptop for Radio SoftKill (fn+F8) but it's not
working, the soft kill is being enabled/disabled without my
interference.

I tried it on kernel-2.6.24 and kernel-2.6.25-rc2 same result...

Any help is appreciated...

P.S: Please Cc to me, I am not subscribed to the mailing list.

--=20
Wael Nasreddine
http://wael.nasreddine.com
PGP: 1024D/C8DD18A2 06F6 1622 4BC8 4CEB D724  DE12 5565 3945 C8DD 18A2

=2E: An infinite number of monkeys typing into GNU emacs,
   would never make a good program. (L. Torvalds 1995) :.

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHuQ+AVWU5RcjdGKIRAko9AJ9hBuk19lz4P3ofveKG6qGFscx5ugCg2ELJ
5FBT55oHUUSnKT5Rg0Oyvvo=
=ynmA
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
