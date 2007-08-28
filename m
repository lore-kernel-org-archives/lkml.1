Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbXH1SIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbXH1SIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXH1SIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:08:40 -0400
Received: from pat.uio.no ([129.240.10.15]:51389 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXH1SIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:08:39 -0400
Subject: Re: NFSv4 client OOPS on 2.6.22-rc3
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Harry Edmon <harry@atmos.washington.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46D46241.8060504@atmos.washington.edu>
References: <46D46241.8060504@atmos.washington.edu>
Content-Type: multipart/mixed; boundary="=-ps8WIsfL6Qu8ut5CFvZb"
Date: Tue, 28 Aug 2007 14:08:34 -0400
Message-Id: <1188324514.6701.186.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.081)
X-UiO-Scanned: E14DE6468DBA596156C35F4929CBF10BFFA5BE82
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 112 total 3520149 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ps8WIsfL6Qu8ut5CFvZb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-08-28 at 10:58 -0700, Harry Edmon wrote:
> I had a kernel oops on my x86_64 dual quad-core Xeon system running 
> 2.6.22-rc3.  The system is an NFSv4 client to another 2.6.22-rc3 
> system.  The OOPS text is attached and the config file.
> 
> plain text document attachment (oops)
> Aug 27 15:22:12 freshair1 kernel: Unable to handle kernel NULL pointer dereference at 0000000000000108 RIP: 
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff80288069>] __dentry_open+0x49/0x220
> Aug 27 15:22:12 freshair1 kernel: PGD b2fad067 PUD 94b76067 PMD 0 
> Aug 27 15:22:12 freshair1 kernel: Oops: 0000 [1] SMP 
> Aug 27 15:22:12 freshair1 kernel: CPU 0 
> Aug 27 15:22:12 freshair1 kernel: Modules linked in: nfs nfsd exportfs lockd nfs_acl auth_rpcgss sunrpc autofs4 dm_snapshot dm_mirror dm_mod ioatdma ide_generic ide_disk ide_cd cdrom parport_pc i2c_i801 usb_storage psmouse parport floppy i2c_core serio_raw joydev evdev pcspkr ehci_hcd uhci_hcd fan e1000 sd_mod ata_piix xfs piix ide_core libata scsi_mod
> Aug 27 15:22:12 freshair1 kernel: Pid: 9503, comm: pqact Not tainted 2.6.23-rc3 #1
> Aug 27 15:22:12 freshair1 kernel: RIP: 0010:[<ffffffff80288069>]  [<ffffffff80288069>] __dentry_open+0x49/0x220
> Aug 27 15:22:12 freshair1 kernel: RSP: 0018:ffff81013c003aa8  EFLAGS: 00010246
> Aug 27 15:22:12 freshair1 kernel: RAX: ffff81012191f0c0 RBX: ffff81012191f0c0 RCX: ffff81012191f0c0
> Aug 27 15:22:12 freshair1 kernel: RDX: 0000000000000000 RSI: ffff81032dabf7c0 RDI: ffff810129ee6b70
> Aug 27 15:22:12 freshair1 kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: ffff810129ee6b70
> Aug 27 15:22:12 freshair1 kernel: R10: ffff81013bbe85a8 R11: 000000003fcaa9fe R12: ffff81008fc17300
> Aug 27 15:22:12 freshair1 kernel: R13: 0000000000000000 R14: ffff810129ee6b70 R15: ffff81032dabf7c0
> Aug 27 15:22:12 freshair1 kernel: FS:  00002b10a22b7c00(0000) GS:ffffffff804e7000(0000) knlGS:0000000000000000
> Aug 27 15:22:12 freshair1 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Aug 27 15:22:12 freshair1 kernel: CR2: 0000000000000108 CR3: 000000012cfa9000 CR4: 00000000000006e0
> Aug 27 15:22:12 freshair1 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Aug 27 15:22:12 freshair1 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Aug 27 15:22:12 freshair1 kernel: Process pqact (pid: 9503, threadinfo ffff81013c002000, task ffff810115449180)
> Aug 27 15:22:12 freshair1 kernel: Stack:  ffff8100c178b000 ffff810129ee6b70 ffff81013c003e38 ffff81008fc17300
> Aug 27 15:22:12 freshair1 kernel:  ffff81013c003b88 ffff810129ee6b70 ffff81013c003b88 ffffffff802897c8
> Aug 27 15:22:12 freshair1 kernel:  ffff81013c003e38 0000000000000000 ffff81013c003e38 ffffffff882b6520
> Aug 27 15:22:12 freshair1 kernel: Call Trace:
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff802897c8>] lookup_instantiate_filp+0x58/0x80
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff882b6520>] :nfs:nfs4_intent_set_file+0x50/0xa0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff882b75ac>] :nfs:nfs4_atomic_open+0xfc/0x190
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff88203be3>] :sunrpc:put_rpccred+0x53/0x110
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff882b7706>] :nfs:nfs4_open_revalidate+0xc6/0x1a0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff8829fa06>] :nfs:nfs_atomic_lookup+0x176/0x1f0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff802921b7>] do_lookup+0x1b7/0x210
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff802944c8>] __link_path_walk+0x8a8/0xe00
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff880c4950>] :xfs:xfs_trans_committed+0x0/0x110
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff80294a7a>] link_path_walk+0x5a/0xf0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff80222c65>] do_page_fault+0x215/0x8e0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff80273301>] do_wp_page+0x291/0x560
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff80294d79>] do_path_lookup+0x89/0x1f0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff80295bea>] __path_lookup_intent_open+0x6a/0xd0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff8028e4c4>] open_exec+0x24/0xc0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff80222c65>] do_page_fault+0x215/0x8e0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff8028fe96>] do_execve+0x56/0x1e0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff8020a7d4>] sys_execve+0x44/0xb0
> Aug 27 15:22:12 freshair1 kernel:  [<ffffffff8020bfd7>] stub_execve+0x67/0xb0
> Aug 27 15:22:12 freshair1 kernel: 
> Aug 27 15:22:12 freshair1 kernel: 
> Aug 27 15:22:12 freshair1 kernel: Code: 48 8b 85 08 01 00 00 4c 89 73 18 4c 89 7b 10 48 c7 43 38 00 
> Aug 27 15:22:12 freshair1 kernel: RIP  [<ffffffff80288069>] __dentry_open+0x49/0x220
> Aug 27 15:22:12 freshair1 kernel:  RSP <ffff81013c003aa8>
> Aug 27 15:22:12 freshair1 kernel: CR2: 0000000000000108

That is the same Oops that Gabriel Barazer reported last week. The
attached patch ought to fix it.

Cheers
  Trond

--=-ps8WIsfL6Qu8ut5CFvZb
Content-Disposition: inline; filename=linux-2.6.23-003-fix_nfs4_atomic_open.dif
Content-Type: message/rfc822; name=linux-2.6.23-003-fix_nfs4_atomic_open.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Mon, 27 Aug 2007 11:33:00 -0400
NFSv4: Ensure that we pass the correct dentry to nfs4_intent_set_file
Subject: No Subject
Message-Id: <1188324467.6701.185.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

This patch fixes an Oops that was reported by Gabriel Barazer.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/nfs4proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 036d862..4b90e17 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1434,7 +1434,7 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	}
 	res = d_add_unique(dentry, igrab(state->inode));
 	if (res != NULL)
-		dentry = res;
+		path.dentry = res;
 	nfs4_intent_set_file(nd, &path, state);
 	return res;
 }

--=-ps8WIsfL6Qu8ut5CFvZb--

