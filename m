Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbYH0OLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbYH0OLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbYH0OLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:11:39 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:60982 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbYH0OLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:11:38 -0400
X-Greylist: delayed 1522 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 10:11:37 EDT
Message-ID: <15219.195.41.66.226.1219844762.squirrel@mail.jabbernet.dk>
Date: Wed, 27 Aug 2008 15:46:02 +0200 (CEST)
Subject: task blocked for more than 120 seconds - 2.6.26.1
From: "Jesper Krogh" <jesper@krogh.cc>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1 [CVS]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I seem to be getting these more frequently on 2.6.26.1

16 core Sun X4600 amd64 with 60GB memory.

[75586.058734] INFO: task gvim:13618 blocked for more than 120 seconds.
[75586.058787] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[75586.058831] efam_xapianin D ffff81010721e280     0 13618  27917
[75586.058835]  ffff8109384afd78 0000000000000086 ffff8109384afd40
ffffffff8044c886
[75586.058838]  ffffffff8061e280 ffffffff8061e280 ffffffff8061a4e0
ffffffff8061e280
[75586.058840]  ffff8103554469c8 ffff8109384afd44 ffff8109384afd38
ffff8109384afd28
[75586.058844] Call Trace:
[75586.058882]  [<ffffffff8044c886>] thread_return+0x3a/0x544
[75586.058904]  [<ffffffffa01a51d5>] :jbd:log_wait_commit+0xa5/0x120
[75586.058911]  [<ffffffff80249420>] autoremove_wake_function+0x0/0x30
[75586.058916]  [<ffffffff8022a4d3>] __wake_up+0x43/0x70
[75586.058918]  [<ffffffff8044d13a>] schedule_timeout+0x5a/0xd0
[75586.058925]  [<ffffffffa01a0594>] :jbd:journal_stop+0x124/0x1b0
[75586.062713]  [<ffffffff802babd3>] __writeback_single_inode+0x263/0x350
[75586.062721]  [<ffffffff802bb68b>] sync_inode+0x2b/0x40
[75586.062742]  [<ffffffffa01b0844>] :ext3:ext3_sync_file+0xa4/0xc0
[75586.062748]  [<ffffffff802be389>] do_fsync+0x69/0xe0
[75586.062752]  [<ffffffff802be42e>] __do_fsync+0x2e/0x50
[75586.062756]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[75586.062762]
[75714.905221] INFO: task gvim:13618 blocked for more than 120 seconds.
[75714.905274] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[75714.905323] efam_xapianin D ffff81010721e280     0 13618  27917
[75714.905327]  ffff8109384afd78 0000000000000086 ffff8109384afd40
ffffffff8044c886
[75714.905330]  ffffffff8061e280 ffffffff8061e280 ffffffff8061a4e0
ffffffff8061e280
[75714.905332]  ffff8103554469c8 ffff8109384afd44 ffff8109384afd38
ffff8109384afd28
[75714.905335] Call Trace:
[75714.905373]  [<ffffffff8044c886>] thread_return+0x3a/0x544
[75714.909151]  [<ffffffffa01a51d5>] :jbd:log_wait_commit+0xa5/0x120
[75714.909158]  [<ffffffff80249420>] autoremove_wake_function+0x0/0x30
[75714.909165]  [<ffffffff8022a4d3>] __wake_up+0x43/0x70
[75714.909170]  [<ffffffff8044d13a>] schedule_timeout+0x5a/0xd0
[75714.909177]  [<ffffffffa01a0594>] :jbd:journal_stop+0x124/0x1b0
[75714.909183]  [<ffffffff802babd3>] __writeback_single_inode+0x263/0x350
[75714.909193]  [<ffffffff802bb68b>] sync_inode+0x2b/0x40
[75714.909212]  [<ffffffffa01b0844>] :ext3:ext3_sync_file+0xa4/0xc0
[75714.909219]  [<ffffffff802be389>] do_fsync+0x69/0xe0
[75714.909225]  [<ffffffff802be42e>] __do_fsync+0x2e/0x50
[75714.909229]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[75714.909235]
[80316.964815] INFO: task gvim:21511 blocked for more than 120 seconds.
[80316.964853] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[80316.964901] gvim          D ffff810507227280     0 21511      1
[80316.964904]  ffff810eef483ec8 0000000000000082 0000000000000000
0000000000000000
[80316.964907]  ffffffff8061e280 ffffffff8061e280 ffffffff8061a4e0
ffffffff8061e280
[80316.964910]  ffff81057a881948 ffff810eef483e94 ffff810eef483e88
ffff810eef483e78
[80316.964912] Call Trace:
[80316.968730]  [<ffffffff8044d6a1>] __mutex_lock_slowpath+0x81/0xd0
[80316.968736]  [<ffffffff8044d4c6>] mutex_lock+0x16/0x20
[80316.968742]  [<ffffffff802be378>] do_fsync+0x58/0xe0
[80316.968745]  [<ffffffff802be42e>] __do_fsync+0x2e/0x50
[80316.968750]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[80316.968756]


-- 
Jesper Krogh

