Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbZEWIww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbZEWIww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 04:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZEWIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 04:52:44 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:47146 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZEWIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 04:52:43 -0400
Message-ID: <4A17B948.5000808@t-online.de>
Date: Sat, 23 May 2009 10:52:24 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc6: reiserfs blocked for more than 120secs
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA301B5584093EFF688F96710"
X-ID: XHo4o2ZO8hpZ8Br+S1l-MFsb9bJHyLRHTlkMQVnhXL3a1SfpSulm86WbL3cuaGmgYh
X-TOI-MSGID: 104c9e24-82d4-4311-a970-eb381c89a6d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA301B5584093EFF688F96710
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,

I got this for 2.6.30-rc6 (amd64):

[16201.331032] INFO: task reiserfs/0:1216 blocked for more than 120 secon=
ds.
[16201.331035] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[16201.331037] reiserfs/0    D ffff8801201486f0     0  1216      2
[16201.331042]  ffff8801201486f0 0000000000000046 0000000000004000 000000=
0000010940
[16201.331046]  000000000000cfa8 0000000000004000 0000000000010940 000000=
000000cfa8
[16201.331050]  ffff880120148998 00000000787f2080 ffff88012fb92cd0 ffff88=
0120148998
[16201.331054] Call Trace:
[16201.331061]  [<ffffffff8020c4fe>] ? apic_timer_interrupt+0xe/0x20
[16201.331067]  [<ffffffff80452f7e>] ? __mutex_lock_slowpath+0xfb/0x171
[16201.331070]  [<ffffffff80452df4>] ? mutex_lock+0x12/0x28
[16201.331093]  [<ffffffffa01505b1>] ? flush_commit_list+0x146/0x624 [rei=
serfs]
[16201.331097]  [<ffffffff80452829>] ? thread_return+0x3e/0xab
[16201.331111]  [<ffffffffa0150561>] ? flush_commit_list+0xf6/0x624 [reis=
erfs]
[16201.331124]  [<ffffffffa0150b26>] ? flush_async_commits+0x0/0x4b [reis=
erfs]
[16201.331145]  [<ffffffffa0150b68>] ? flush_async_commits+0x42/0x4b [rei=
serfs]
[16201.331150]  [<ffffffff8024b084>] ? worker_thread+0x1a6/0x24e
[16201.331154]  [<ffffffff8024eb4e>] ? autoremove_wake_function+0x0/0x2e
[16201.331157]  [<ffffffff8024aede>] ? worker_thread+0x0/0x24e
[16201.331160]  [<ffffffff8024aede>] ? worker_thread+0x0/0x24e
[16201.331163]  [<ffffffff8024e72c>] ? kthread+0x54/0x80
[16201.331166]  [<ffffffff8020c9ea>] ? child_rip+0xa/0x20
[16201.331169]  [<ffffffff8024e6d8>] ? kthread+0x0/0x80
[16201.331172]  [<ffffffff8020c9e0>] ? child_rip+0x0/0x20

It seems to be still working, though. I got this only once by now.


Please mail if I can help to debug this problem.


Regards

Harri



--------------enigA301B5584093EFF688F96710
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoXuUwACgkQUTlbRTxpHjfFkwCcCtqs/SbXjVVshFDlZ9P5y7D6
m54AnA0Uruiqp1QE1Y37QToAYZMMaPUI
=oX/g
-----END PGP SIGNATURE-----

--------------enigA301B5584093EFF688F96710--
