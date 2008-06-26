Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYFZKEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYFZKEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYFZKEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:04:25 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50578 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbYFZKEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:04:23 -0400
Date: Thu, 26 Jun 2008 12:03:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Tree for June 25
In-Reply-To: <200806260859.26270.rjw@sisk.pl>
Message-ID: <alpine.LRH.1.10.0806261201420.10290@twin.jikos.cz>
References: <20080626003554.b2623aba.sfr@canb.auug.org.au> <20080626120212.c8caa005.sfr@canb.auug.org.au> <200806260801.13131.rjw@sisk.pl> <200806260859.26270.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Rafael J. Wysocki wrote:

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff80264230>] find_symbol+0x230/0x260
> PGD 5c817067 PUD 5cccf067 PMD 0
> Oops: 0002 [1] SMP DEBUG_PAGEALLOC
> last sysfs file:
> CPU 0
> Modules linked in:
> Pid: 912, comm: modprobe Not tainted 2.6.26-rc7-next #4
> RIP: 0010:[<ffffffff80264230>]  [<ffffffff80264230>] find_symbol+0x230/0x260
> RSP: 0018:ffff81005cbddc68  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: 000000000000003d RCX: ffffffff805b8568
> RDX: 0000000000000000 RSI: ffffffff80573e0f RDI: ffffffff805c0bcc
> RBP: ffff81005cbddda8 R08: ffff81005cbddd48 R09: 0000000000000001
> R10: 0000000000000000 R11: 000000000000003c R12: fffffffffffffff2
> R13: 00000000000b2507 R14: 00000000006181e0 R15: ffffc20000689240
> FS:  00007f5820fed6f0(0000) GS:ffffffff80613f40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000005c87f000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 912, threadinfo ffff81005cbdc000, task ffff81005c9f6840)
> Stack:  ffff81005c9f6840 0000000000000000 0000000000000000 00000000006180f8
> ffff81005cbddf40 0000000000000000 ffff81005c9f6840 ffffffff8049728f
> 00000000000b2507 00000000006181e0 ffff81005cbddcd8 ffffffff8025c70a
> Call Trace:
> [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [<ffffffff8025c70a>] ? trace_hardirqs_on_caller+0xca/0x160
> [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [<ffffffff8020f167>] ? do_softirq+0x47/0xa0
> [<ffffffff8020bc9f>] ? restore_args+0x0/0x30
> [<ffffffff80263c80>] ? struct_module+0x0/0x10
> [<ffffffff802648f3>] ? find_sec+0x53/0x70
> [<ffffffff80265c04>] sys_init_module+0x6b4/0x1e00
> [<ffffffff802afc11>] ? do_sync_read+0xf1/0x130
> [<ffffffff802505e0>] ? autoremove_wake_function+0x0/0x40
> [<ffffffff80323791>] ? security_file_permission+0x11/0x20
> [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [<ffffffff8025c70a>] ? trace_hardirqs_on_caller+0xca/0x160
> [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [<ffffffff8020b65b>] system_call_after_swapgs+0x7b/0x80
>
>
> Code: 49 8b 43 08 0f 18 08 49 8d 43 08 48 3d c0 a5 5d 80 0f 85 47 fe ff ff 48 c7 c0 fe ff ff ff eb 20 48 8b 45 b0 48 8b 95 e8 fe ff ff <48> 89 02 48
> RIP  [<ffffffff80264230>] find_symbol+0x230/0x260
> RSP <ffff81005cbddc68>
> CR2: 0000000000000000
> ---[ end trace 81cec6311b0e1cee ]---

I guess this got in through Rusty's tree, right?

Does the patch below fix it please?



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] module: fix NULL pointer dereference in find_symbol()

The patch that introduces each_symbol() iterator forgets to
test the NULL value of the output parameters (which the original
code did).

This patch restores the correct checks.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
  kernel/module.c |    6 ++++--
  1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 880409f..a3354ca 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -304,8 +304,10 @@ static unsigned long find_symbol(const char *name,
  	fsa.warn = warn;

  	if (each_symbol(find_symbol_in_section, &fsa)) {
-		*owner = fsa.owner;
-		*crc = fsa.crc;
+		if (owner)
+			*owner = fsa.owner;
+		if (crc)
+			*crc = fsa.crc;
  		return fsa.value;
  	}

-- 
Jiri Kosina
SUSE Labs

