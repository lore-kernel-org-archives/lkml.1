Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYKJFpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYKJFpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYKJFph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:45:37 -0500
Received: from mail.areca.com.tw ([220.130.178.143]:61691 "EHLO areca.com.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750815AbYKJFpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:45:36 -0500
From: "???nick" <nick.cheng@areca.com.tw>
To: <linux-kernel@vger.kernel.org>
Subject: Endless Messages Dumping on kernel 2.6.27.4 & kernel 2.6.26.6
Date: Mon, 10 Nov 2008 13:45:30 +0800
Message-ID: <DAC24ADD6E714E309EAC60AC1DCC18F3@arecac12242173>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0066_01C9433A.9A5DEA20"
X-Mailer: Microsoft Office Outlook 11
thread-index: AclC3n0+07zR0gc8RuO3FFjTYantKQ==
Content-Class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
X-OriginalArrivalTime: 10 Nov 2008 05:35:12.0484 (UTC) FILETIME=[1A25C240:01C942F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0066_01C9433A.9A5DEA20
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Sir,
I found something weird on kernel-2.6.27.4 & kernel 2.6.26.6 while I tested
the Areca PCI-Express RAID card with the default driver.
It will dump messages as the attachment w/o any Areca driver messages.
I found it on AMD and Intel platforms.
Any hints are appreciated!!
Thank you,

------=_NextPart_000_0066_01C9433A.9A5DEA20
Content-Type: text/plain;
	name="kernel dump.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kernel dump.txt"

INFO: task kjournald:6018 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e00740 00000046 f784dd00 c011e939 f7de6e00 c2d68500 f7e00894 =
00000001=20
       c01da8d5 f69f2800 00000246 c2d68500 00000000 c2d39788 c018a98f =
c032201a=20
       f7cdaec0 c018a9c0 c032213e f7cdaec0 00000002 f7cdaebc c2d39788 =
c03221ce=20
Call Trace:
 [<c011e939>] scheduler_tick+0x62/0x82
 [<c01da8d5>] submit_bio+0xb0/0xb8
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88950f6>] journal_commit_transaction+0x286/0xa2c [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task cp:9425 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       d4dc1d00 00000086 c032dfe0 c011a282 f7de7c00 c2d5e500 d4dc1e54 =
00000000=20
       00000083 f79eeac0 00000202 c2d5e500 00000000 c2d39fb0 c018a98f =
c032201a=20
       f79eeb24 c018a9c0 c0322202 f79eeb24 00000002 f79eeb20 c2d39fb0 =
c0322293=20
Call Trace:
 [<c011a282>] task_tick_fair+0x24/0x26
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c0322202>] __wait_on_bit_lock+0x2c/0x52
 [<c0322293>] out_of_line_wait_on_bit_lock+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018a9e4>] __lock_buffer+0x21/0x24
 [<c018beb6>] __block_write_full_page+0x197/0x2e9
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<c018da93>] block_write_full_page+0xdc/0xe5
 [<f88f2f5b>] walk_page_buffers+0x61/0x86 [ext3]
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<f88f35e6>] ext3_ordered_writepage+0x9f/0x10b [ext3]
 [<f88f352c>] bget_one+0x0/0x7 [ext3]
 [<c0153633>] __writepage+0x8/0x1f
 [<c01534fd>] write_cache_pages+0x17b/0x2a9
 [<c015362b>] __writepage+0x0/0x1f
 [<c0153664>] generic_writepages+0x1a/0x21
 [<c0153694>] do_writepages+0x29/0x30
 [<c0187aa7>] __sync_single_inode+0x53/0x158
 [<c0187c9c>] __writeback_single_inode+0xf0/0xf8
 [<c0152a5f>] task_dirty_limit+0x38/0xb4
 [<c0187dc9>] generic_sync_sb_inodes+0x125/0x1db
 [<c0187ef1>] writeback_inodes+0x6d/0xa1
 [<c0152ea4>] balance_dirty_pages+0x104/0x270
 [<c014f2ac>] generic_perform_write+0xf7/0x169
 [<c014f2fc>] generic_perform_write+0x147/0x169
 [<c014f394>] generic_file_buffered_write+0x76/0x10f
 [<c014f881>] __generic_file_aio_write_nolock+0x454/0x47f
 [<c0118e03>] kmap_atomic+0x11/0x14
 [<c014db0f>] do_generic_file_read+0x23a/0x426
 [<c0181322>] mnt_drop_write+0x5a/0x6c
 [<c017fbdf>] touch_atime+0xe7/0xee
 [<c014f993>] generic_file_aio_write+0x55/0xac
 [<f88f112c>] ext3_file_write+0x19/0x89 [ext3]
 [<c016ee50>] do_sync_write+0xb7/0xf8
 [<c011e939>] scheduler_tick+0x62/0x82
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0103904>] apic_timer_interrupt+0x28/0x30
 [<c01c29b6>] security_file_permission+0xc/0xd
 [<c016eb69>] rw_verify_area+0x91/0xa9
 [<c016ef12>] vfs_write+0x81/0xf3
 [<c016f022>] sys_write+0x3c/0x62
 [<c0102df9>] sysenter_do_call+0x12/0x21
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kjournald:6018 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e00740 00000046 ea42c780 00000000 f7de6e00 c2d68500 f7e00894 =
c01da7f7=20
       fffffffb 00000008 00000246 c2d68500 00000000 c2d3af88 c018a98f =
c032201a=20
       f7cdaec0 c018a9c0 c032213e f7cdaec0 00000002 f7cdaebc c2d3af88 =
c03221ce=20
Call Trace:
 [<c01da7f7>] generic_make_request+0x1ff/0x22d
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88954df>] journal_commit_transaction+0x66f/0xa2c [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kswapd0:226 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f791ce80 00000046 00000001 c01e3674 f69c0e00 c2d5e500 f791cfd4 =
c01d9d3c=20
       f79ed3c0 00000002 c0322d90 c2d5e500 f7f0a7c0 f796ac48 f7f0a780 =
c032201a=20
       00000001 c01d9fd2 00000001 eead7100 00000000 f791ce80 c01333aa =
f796ac54=20
Call Trace:
 [<c01e3674>] cfq_may_queue+0x4e/0x6e
 [<c01d9d3c>] get_request+0x61/0x25e
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c032201a>] io_schedule+0x1a/0x23
 [<c01d9fd2>] get_request_wait+0x99/0xd3
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c01e23ff>] cfq_merge+0x14/0x34
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c01da52a>] __make_request+0x247/0x2c0
 [<c01da7f7>] generic_make_request+0x1ff/0x22d
 [<c014fccd>] mempool_alloc+0x37/0xd8
 [<c01da8d5>] submit_bio+0xb0/0xb8
 [<c018e29d>] bio_alloc_bioset+0x37/0x6e
 [<c018e2c5>] bio_alloc_bioset+0x5f/0x6e
 [<c018dc2f>] submit_bh+0x11c/0x141
 [<c018bf1a>] __block_write_full_page+0x1fb/0x2e9
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<c018da93>] block_write_full_page+0xdc/0xe5
 [<f88f2f5b>] walk_page_buffers+0x61/0x86 [ext3]
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<f88f35e6>] ext3_ordered_writepage+0x9f/0x10b [ext3]
 [<f88f352c>] bget_one+0x0/0x7 [ext3]
 [<c015547e>] pageout+0xc3/0x123
 [<c011e939>] scheduler_tick+0x62/0x82
 [<c015579b>] shrink_page_list+0x203/0x36f
 [<c0111e52>] smp_apic_timer_interrupt+0x2a/0x33
 [<c0103904>] apic_timer_interrupt+0x28/0x30
 [<c0155c44>] shrink_inactive_list+0xee/0x2d2
 [<c0199190>] mb_cache_shrink_fn+0x48/0xbe
 [<c01552f9>] shrink_slab+0x174/0x182
 [<c0156310>] shrink_zone+0xb5/0xd0
 [<c0156841>] balance_pgdat+0x1fc/0x330
 [<c0155ae5>] isolate_pages_global+0x0/0x42
 [<c01332de>] prepare_to_wait+0x12/0x49
 [<c0156a6c>] kswapd+0xf7/0xf9
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<c0156975>] kswapd+0x0/0xf9
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kjournald:6018 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e00740 00000046 ea42c780 00000000 f7de6e00 c2d68500 f7e00894 =
c01da7f7=20
       fffffffb 00000008 00000246 c2d68500 00000000 c2d3af88 c018a98f =
c032201a=20
       f7cdaec0 c018a9c0 c032213e f7cdaec0 00000002 f7cdaebc c2d3af88 =
c03221ce=20
Call Trace:
 [<c01da7f7>] generic_make_request+0x1ff/0x22d
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88954df>] journal_commit_transaction+0x66f/0xa2c [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kjournald:6018 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e00740 00000046 ea42c780 00000000 f7de6e00 c2d68500 f7e00894 =
c01da7f7=20
       fffffffb 00000008 00000246 c2d68500 00000000 c2d3af88 c018a98f =
c032201a=20
       f7cdaec0 c018a9c0 c032213e f7cdaec0 00000002 f7cdaebc c2d3af88 =
c03221ce=20
Call Trace:
 [<c01da7f7>] generic_make_request+0x1ff/0x22d
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88954df>] journal_commit_transaction+0x66f/0xa2c [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kjournald:6016 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e01d00 00000046 c03ffaa0 0000007b f6957880 c2d5e500 f7e01e54 =
00000001=20
       c01da8d5 eea5a480 00000246 c2d5e500 00000000 c2d38f18 c018a98f =
c032201a=20
       eea4fec0 c018a9c0 c032213e eea4fec0 00000002 eea4febc c2d38f18 =
c03221ce=20
Call Trace:
 [<c01da8d5>] submit_bio+0xb0/0xb8
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<f8894c0d>] journal_do_submit_data+0x25/0x2b [jbd]
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88950f6>] journal_commit_transaction+0x286/0xa2c [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kjournald:6018 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e00740 00000046 c0104d99 f7cdae80 eb7b0e00 c2d5e500 f7e00894 =
00000001=20
       c01da8d5 f7993a00 00000246 c2d5e500 00000000 c2d3b4f8 c018a98f =
c032201a=20
       f7cdaec0 c018a9c0 c032213e f7cdaec0 00000002 f7cdaebc c2d3b4f8 =
c03221ce=20
Call Trace:
 [<c0104d99>] profile_pc+0x21/0x45
 [<c01da8d5>] submit_bio+0xb0/0xb8
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<f8894c0d>] journal_do_submit_data+0x25/0x2b [jbd]
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88950f6>] journal_commit_transaction+0x286/0xa2c [jbd]
 [<c01199bc>] update_curr+0x3f/0x51
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kjournald:6018 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e00740 00000046 f791cae0 00000000 eb7b1dc0 c2d5e500 f7e00894 =
00000001=20
       c01da8d5 d5834500 00000246 c2d5e500 00000000 c2d3af40 c018a98f =
c032201a=20
       f7cdaec0 c018a9c0 c032213e f7cdaec0 00000002 f7cdaebc c2d3af40 =
c03221ce=20
Call Trace:
 [<c01da8d5>] submit_bio+0xb0/0xb8
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<f8894c0d>] journal_do_submit_data+0x25/0x2b [jbd]
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88950f6>] journal_commit_transaction+0x286/0xa2c [jbd]
 [<c01199bc>] update_curr+0x3f/0x51
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task cp:2417 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       eb6795c0 00000086 f791cae0 00098968 f7fecfc0 c2d68500 eb679714 =
06da6000=20
       00000131 013106da 00000202 c2d68500 00000000 c2d3d5b0 c018a98f =
c032201a=20
       eb7c1b24 c018a9c0 c0322202 eb7c1b24 00000002 eb7c1b20 c2d3d5b0 =
c0322293=20
Call Trace:
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c0322202>] __wait_on_bit_lock+0x2c/0x52
 [<c0322293>] out_of_line_wait_on_bit_lock+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018a9e4>] __lock_buffer+0x21/0x24
 [<c018beb6>] __block_write_full_page+0x197/0x2e9
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<c018da93>] block_write_full_page+0xdc/0xe5
 [<f88f2f5b>] walk_page_buffers+0x61/0x86 [ext3]
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<f88f35e6>] ext3_ordered_writepage+0x9f/0x10b [ext3]
 [<f88f352c>] bget_one+0x0/0x7 [ext3]
 [<c0153633>] __writepage+0x8/0x1f
 [<c01534fd>] write_cache_pages+0x17b/0x2a9
 [<c015362b>] __writepage+0x0/0x1f
 [<c0153664>] generic_writepages+0x1a/0x21
 [<c0153694>] do_writepages+0x29/0x30
 [<c0187aa7>] __sync_single_inode+0x53/0x158
 [<c0187c9c>] __writeback_single_inode+0xf0/0xf8
 [<c0152a5f>] task_dirty_limit+0x38/0xb4
 [<c0187dc9>] generic_sync_sb_inodes+0x125/0x1db
 [<c0187ef1>] writeback_inodes+0x6d/0xa1
 [<c0152ea4>] balance_dirty_pages+0x104/0x270
 [<c014f2ac>] generic_perform_write+0xf7/0x169
 [<c014f2fc>] generic_perform_write+0x147/0x169
 [<c014f394>] generic_file_buffered_write+0x76/0x10f
 [<c014f881>] __generic_file_aio_write_nolock+0x454/0x47f
 [<c0118e03>] kmap_atomic+0x11/0x14
 [<c014db0f>] do_generic_file_read+0x23a/0x426
 [<c0181322>] mnt_drop_write+0x5a/0x6c
 [<c017fbdf>] touch_atime+0xe7/0xee
 [<c014f993>] generic_file_aio_write+0x55/0xac
 [<f88f112c>] ext3_file_write+0x19/0x89 [ext3]
 [<c016ee50>] do_sync_write+0xb7/0xf8
 [<c011e939>] scheduler_tick+0x62/0x82
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c01e92fd>] delay_tsc+0x18/0x35
 [<c01e932b>] __delay+0x6/0x7
 [<c01ec64d>] __spin_lock_debug+0x53/0xa1
 [<c01c29b6>] security_file_permission+0xc/0xd
 [<c016eb69>] rw_verify_area+0x91/0xa9
 [<c016ef12>] vfs_write+0x81/0xf3
 [<c016f022>] sys_write+0x3c/0x62
 [<c0102df9>] sysenter_do_call+0x12/0x21
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task cp:27300 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7d003a0 00000086 f784dd00 eead8780 d4c816c0 c2d68500 f7d004f4 =
00000000=20
       c01da7f7 fffffffb 00000202 c2d68500 00000000 c2d3d2c8 c018a98f =
c032201a=20
       f79e5b24 c018a9c0 c0322202 f79e5b24 00000002 f79e5b20 c2d3d2c8 =
c0322293=20
Call Trace:
 [<c01da7f7>] generic_make_request+0x1ff/0x22d
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c0322202>] __wait_on_bit_lock+0x2c/0x52
 [<c0322293>] out_of_line_wait_on_bit_lock+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018a9e4>] __lock_buffer+0x21/0x24
 [<c018beb6>] __block_write_full_page+0x197/0x2e9
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<c018da93>] block_write_full_page+0xdc/0xe5
 [<f88f2f5b>] walk_page_buffers+0x61/0x86 [ext3]
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<f88f35e6>] ext3_ordered_writepage+0x9f/0x10b [ext3]
 [<f88f352c>] bget_one+0x0/0x7 [ext3]
 [<c0153633>] __writepage+0x8/0x1f
 [<c01534fd>] write_cache_pages+0x17b/0x2a9
 [<c015362b>] __writepage+0x0/0x1f
 [<c0153664>] generic_writepages+0x1a/0x21
 [<c0153694>] do_writepages+0x29/0x30
 [<c0187aa7>] __sync_single_inode+0x53/0x158
 [<c0187c9c>] __writeback_single_inode+0xf0/0xf8
 [<c0152a5f>] task_dirty_limit+0x38/0xb4
 [<c0187dc9>] generic_sync_sb_inodes+0x125/0x1db
 [<c0187ef1>] writeback_inodes+0x6d/0xa1
 [<c0152ea4>] balance_dirty_pages+0x104/0x270
 [<c014f2ac>] generic_perform_write+0xf7/0x169
 [<c014f2fc>] generic_perform_write+0x147/0x169
 [<c014f394>] generic_file_buffered_write+0x76/0x10f
 [<c014f881>] __generic_file_aio_write_nolock+0x454/0x47f
 [<c0118e03>] kmap_atomic+0x11/0x14
 [<c014db0f>] do_generic_file_read+0x23a/0x426
 [<c0181322>] mnt_drop_write+0x5a/0x6c
 [<c017fbdf>] touch_atime+0xe7/0xee
 [<c014f993>] generic_file_aio_write+0x55/0xac
 [<f88f112c>] ext3_file_write+0x19/0x89 [ext3]
 [<c016ee50>] do_sync_write+0xb7/0xf8
 [<c011e939>] scheduler_tick+0x62/0x82
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c01197d2>] __dequeue_entity+0x1b/0x6e
 [<c01c29b6>] security_file_permission+0xc/0xd
 [<c016eb69>] rw_verify_area+0x91/0xa9
 [<c016ef12>] vfs_write+0x81/0xf3
 [<c016f022>] sys_write+0x3c/0x62
 [<c0102df9>] sysenter_do_call+0x12/0x21
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task cp:27317 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       eb67af20 00000082 eb7b2258 eb676500 f6957180 c2d68500 eb67b074 =
00000000=20
       c01da7f7 fffffffb 00000202 c2d68500 00000000 c2d399f8 c018a98f =
c032201a=20
       eea10b24 c018a9c0 c0322202 eea10b24 00000002 eea10b20 c2d399f8 =
c0322293=20
Call Trace:
 [<c01da7f7>] generic_make_request+0x1ff/0x22d
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c0322202>] __wait_on_bit_lock+0x2c/0x52
 [<c0322293>] out_of_line_wait_on_bit_lock+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018a9e4>] __lock_buffer+0x21/0x24
 [<c018beb6>] __block_write_full_page+0x197/0x2e9
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<c018da93>] block_write_full_page+0xdc/0xe5
 [<f88f2f5b>] walk_page_buffers+0x61/0x86 [ext3]
 [<f88f2c33>] ext3_get_block+0x0/0xd7 [ext3]
 [<f88f35e6>] ext3_ordered_writepage+0x9f/0x10b [ext3]
 [<f88f352c>] bget_one+0x0/0x7 [ext3]
 [<c0153633>] __writepage+0x8/0x1f
 [<c01534fd>] write_cache_pages+0x17b/0x2a9
 [<c015362b>] __writepage+0x0/0x1f
 [<c0153664>] generic_writepages+0x1a/0x21
 [<c0153694>] do_writepages+0x29/0x30
 [<c0187aa7>] __sync_single_inode+0x53/0x158
 [<c0187c9c>] __writeback_single_inode+0xf0/0xf8
 [<c0152a5f>] task_dirty_limit+0x38/0xb4
 [<c0187dc9>] generic_sync_sb_inodes+0x125/0x1db
 [<c0187ef1>] writeback_inodes+0x6d/0xa1
 [<c0152ea4>] balance_dirty_pages+0x104/0x270
 [<c014f2ac>] generic_perform_write+0xf7/0x169
 [<c014f2fc>] generic_perform_write+0x147/0x169
 [<c01371d9>] profile_tick+0x43/0x5d
 [<c014f394>] generic_file_buffered_write+0x76/0x10f
 [<c014f881>] __generic_file_aio_write_nolock+0x454/0x47f
 [<c0118e03>] kmap_atomic+0x11/0x14
 [<c014db0f>] do_generic_file_read+0x23a/0x426
 [<c0181322>] mnt_drop_write+0x5a/0x6c
 [<c017fbdf>] touch_atime+0xe7/0xee
 [<c014f993>] generic_file_aio_write+0x55/0xac
 [<f88f112c>] ext3_file_write+0x19/0x89 [ext3]
 [<c016ee50>] do_sync_write+0xb7/0xf8
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0104d99>] profile_pc+0x21/0x45
 [<c01371d9>] profile_tick+0x43/0x5d
 [<c0139d20>] tick_handle_periodic+0x14/0x5e
 [<c01c29b6>] security_file_permission+0xc/0xd
 [<c016eb69>] rw_verify_area+0x91/0xa9
 [<c016ef12>] vfs_write+0x81/0xf3
 [<c016f022>] sys_write+0x3c/0x62
 [<c0102df9>] sysenter_do_call+0x12/0x21
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
INFO: task kjournald:6018 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
       f7e00740 00000046 c03ffaa0 f692a000 d4c80fc0 c2d5e500 f7e00894 =
00000001=20
       c01da8d5 d4c6e900 00000246 c2d5e500 00000000 c2d3ac58 c018a98f =
c032201a=20
       f7cdaec0 c018a9c0 c032213e f7cdaec0 00000002 f7cdaebc c2d3ac58 =
c03221ce=20
Call Trace:
 [<c01da8d5>] submit_bio+0xb0/0xb8
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c032201a>] io_schedule+0x1a/0x23
 [<c018a9c0>] sync_buffer+0x31/0x34
 [<c032213e>] __wait_on_bit+0x2c/0x51
 [<c03221ce>] out_of_line_wait_on_bit+0x6b/0x73
 [<c018a98f>] sync_buffer+0x0/0x34
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<f8894c0d>] journal_do_submit_data+0x25/0x2b [jbd]
 [<c01333d7>] wake_bit_function+0x0/0x3c
 [<c018aa0c>] __wait_on_buffer+0x16/0x18
 [<f88950f6>] journal_commit_transaction+0x286/0xa2c [jbd]
 [<c01199bc>] update_curr+0x3f/0x51
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0322d90>] _spin_lock_irqsave+0x9/0xd
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c012b087>] try_to_del_timer_sync+0x41/0x47
 [<f8896e93>] kjournald+0xa2/0x1f7 [jbd]
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c0321ccc>] __sched_text_start+0x3cc/0x41c
 [<c01333aa>] autoremove_wake_function+0x0/0x2d
 [<c011eac0>] complete+0x28/0x36
 [<f8896df1>] kjournald+0x0/0x1f7 [jbd]
 [<c0132f3b>] kthread+0x34/0x55
 [<c0132f07>] kthread+0x0/0x55
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
------=_NextPart_000_0066_01C9433A.9A5DEA20--

