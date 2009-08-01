Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbZHAJt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbZHAJt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 05:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZHAJt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 05:49:27 -0400
Received: from www17.your-server.de ([213.133.104.17]:57280 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZHAJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 05:49:26 -0400
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
From: Thomas Meyer <thomas@m3y3r.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
In-Reply-To: <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00  <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 11:48:55 +0200
Message-Id: <1249120135.14496.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> Enough said. Get the code and have fun!

BUG: scheduling while atomic: kjournald2/0x00000001/1128, CPU#1 
Modules linked in: olympic forcedeth rndis_wlan floppy [last unloaded: scsi_wait_scan]
Pid: 1128, comm: kjournald2 Tainted: G        W  2.6.31-rc4-rt1 #3
Call Trace:
 [<ffffffff81809a2d>] ? __schedule+0x88/0x76c
 [<ffffffff8109baca>] ? task_blocks_on_rt_mutex+0x15b/0x1c4
 [<ffffffff8180a45b>] ? schedule+0x1a/0x3e
 [<ffffffff8180b22e>] ? rt_spin_lock_slowlock+0x149/0x21c
 [<ffffffff810e630d>] ? lock_cpu_pcp+0x4b/0x85
 [<ffffffff810e762b>] ? free_hot_cold_page+0x5a/0x216
 [<ffffffff8110fe0a>] ? slab_irq_enable+0x9d/0xc1
 [<ffffffff81110516>] ? kmem_cache_free+0x42/0xc3
 [<ffffffff811df024>] ? jbd2_journal_remove_journal_head+0x2d/0x54
 [<ffffffff811dbe56>] ? journal_clean_one_cp_list+0x82/0xed
 [<ffffffff811dbf0a>] ? __jbd2_journal_clean_checkpoint_list+0x49/0xa0
 [<ffffffff811d9e1d>] ? jbd2_journal_commit_transaction+0x2f3/0x125a
 [<ffffffff8180a162>] ? thread_return+0x51/0xe4
 [<ffffffff810884bd>] ? autoremove_wake_function+0x0/0x55
 [<ffffffff810797d1>] ? try_to_del_timer_sync+0x59/0x77
 [<ffffffff811e00f2>] ? kjournald2+0x106/0x27c
 [<ffffffff810884bd>] ? autoremove_wake_function+0x0/0x55
 [<ffffffff811dffec>] ? kjournald2+0x0/0x27c
 [<ffffffff8108800e>] ? kthread+0x90/0x98
 [<ffffffff8102cf8a>] ? child_rip+0xa/0x20
 [<ffffffff81087f7e>] ? kthread+0x0/0x98
 [<ffffffff8102cf80>] ? child_rip+0x0/0x20




