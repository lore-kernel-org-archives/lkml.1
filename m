Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZALAHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZALAHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 19:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZALAHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 19:07:01 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56629 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZALAHA (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 19:07:00 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: 2.6.28-mmotm0109 WARNING: at drivers/ata/libata-sff.c:1017
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231717499_4563P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Jan 2009 18:44:59 -0500
Message-ID: <4967.1231717499@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231717499_4563P
Content-Type: text/plain; charset=us-ascii

Seeing lots of these in my dmesg (149  in first 7 minutes of uptime):

[    0.885878] ------------[ cut here ]------------
[    0.885881] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x477/0x677()
[    0.885883] Hardware name: Latitude D820
[    0.885885] Modules linked in:
[    0.885889] Pid: 0, comm: swapper Not tainted 2.6.28-mmotm0109 #1
[    0.885891] Call Trace:
[    0.885894]  <IRQ>  [<ffffffff8023532d>] warn_slowpath+0xb1/0xed
[    0.885906]  [<ffffffff80548eea>] ? _spin_unlock_irqrestore+0x53/0x58
[    0.885910]  [<ffffffff803f8f9e>] ? scsi_eh_scmd_add+0x96/0xa6
[    0.885913]  [<ffffffff803f9002>] ? scsi_times_out+0x54/0x70
[    0.885917]  [<ffffffff8036294d>] ? kobject_put+0x47/0x4b
[    0.885921]  [<ffffffff80356ead>] ? blk_rq_timed_out+0x16/0x55
[    0.885926]  [<ffffffff803d9fd8>] ? put_device+0x12/0x14
[    0.885932]  [<ffffffff8024d185>] ? sched_clock_cpu+0x138/0x144
[    0.885935]  [<ffffffff8041457a>] ? ata_sff_data_xfer32+0x62/0xa6
[    0.885938]  [<ffffffff80414091>] ata_sff_hsm_move+0x477/0x677
[    0.885942]  [<ffffffff80414376>] ata_sff_host_intr+0xe5/0x131
[    0.885945]  [<ffffffff80414448>] ata_sff_interrupt+0x86/0xc2
[    0.885949]  [<ffffffff80269465>] handle_IRQ_event+0x2c/0x61
[    0.885952]  [<ffffffff8026a7f2>] handle_edge_irq+0xce/0x114
[    0.885957]  [<ffffffff8020dd21>] do_IRQ+0xdc/0x153
[    0.885960]  [<ffffffff8020c2d3>] ret_from_intr+0x0/0xf
[    0.885962]  <EOI> <4>---[ end trace 515a9d577eac5d9e ]---


--==_Exmh_1231717499_4563P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJaoR7cC3lWbTT17ARAskhAJ9eSxGmjnqSqDBIi2LrNS06Xkar2wCgkEUC
atqD5/ZLCiHMK1g5Da3M0Yw=
=u18f
-----END PGP SIGNATURE-----

--==_Exmh_1231717499_4563P--
