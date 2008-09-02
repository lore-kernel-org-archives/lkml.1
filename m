Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYIBGgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYIBGgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYIBGge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:36:34 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:34424 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750912AbYIBGgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:36:31 -0400
Date: Tue, 2 Sep 2008 08:36:24 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080902063624.GA32284@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <20080830205143.GA9726@anita> <48BBCF98.4070003@kernel.org> <20080901174657.GA2114@anita> <48BCC28E.5030009@kernel.org> <20080902054322.GA7154@anita> <48BCD2DD.3040209@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <48BCD2DD.3040209@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am 2008-09-02 07:45 +0200 schrieb Tejun Heo:

> The excerpt is fine but please turn on CONFIG_KALLSYMS.  The stack dump

Yea, of course... my bad. First I wondered to turn this on or deliver
System.map but then I forgot.

> is pretty much meaningless without it.

;-)

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="allsyms2.txt"

from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffffa00b4f39>] ext4_mark_iloc_dirty+0x279/0x510 [ext4dev]
 [<ffffffffa00b4d20>] ext4_mark_iloc_dirty+0x60/0x510 [ext4dev]
 [<ffffffffa00b5cbd>] ext4_mark_inode_dirty+0x6d/0x1b0 [ext4dev]
 [<ffffffffa00b63ff>] ext4_journalled_write_end+0x10f/0x160 [ext4dev]
 [<ffffffff80376a26>] tty_poll+0x96/0xa0
 [<ffffffff8024e896>] generic_file_buffered_write+0x1b6/0x6e0
 [<ffffffff80280e10>] __pollwait+0x0/0x130
 [<ffffffff8022a9de>] current_fs_time+0x1e/0x30
 [<ffffffff8024ced4>] file_remove_suid+0x24/0x80
 [<ffffffff8024f258>] __generic_file_aio_write_nolock+0x278/0x470
 [<ffffffff80284902>] dput+0xa2/0x140
 [<ffffffff8024fd14>] generic_file_aio_write+0x64/0xe0
 [<ffffffffa00b2f08>] ext4_file_write+0x58/0x170 [ext4dev]
 [<ffffffff80271f5b>] do_sync_write+0xdb/0x120
 [<ffffffff80239bb0>] autoremove_wake_function+0x0/0x30
 [<ffffffff8027297b>] vfs_write+0xcb/0x170
 [<ffffffff80272b23>] sys_write+0x53/0xa0
 [<ffffffff8020b68b>] system_call_fastpath+0x16/0x1b

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8033cee0>] delay_tsc+0x0/0x30
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cd1c>] ktime_get+0xc/0x50
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8032bf30>] generic_unplug_device+0x0/0x20
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804174b0>] udp_poll+0x0/0x130
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f3fa>] run_timer_softirq+0x1a/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8032bf30>] generic_unplug_device+0x0/0x20
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80279af1>] inode_permission+0x61/0xe0
 [<ffffffff8027b8db>] __link_path_walk+0x8b/0xe70
 [<ffffffff8027c8ad>] path_walk+0x5d/0xc0
 [<ffffffff8027c9f7>] do_path_lookup+0x97/0x190
 [<ffffffff8027b7ed>] getname+0x18d/0x1f0
 [<ffffffff8027d847>] user_path_at+0x97/0xd0
 [<ffffffff802117e9>] read_tsc+0x9/0x20
 [<ffffffff80275694>] cp_new_stat+0xe4/0x100
 [<ffffffff80275563>] vfs_stat_fd+0x23/0x60
 [<ffffffff802757a7>] sys_newstat+0x27/0x50
 [<ffffffff8020b68b>] system_call_fastpath+0x16/0x1b

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cd1c>] ktime_get+0xc/0x50
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8032bf30>] generic_unplug_device+0x0/0x20
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80236250>] delayed_work_timer_fn+0x0/0x20
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 167, comm: pdflush Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80329510>] elv_rb_latter_request+0x0/0x30
 [<ffffffff80338104>] prio_tree_next+0x194/0x240
 [<ffffffff8032b411>] submit_bio+0x51/0xd0
 [<ffffffff80258ecf>] vma_prio_tree_next+0x3f/0x70
 [<ffffffff80264443>] page_mkclean+0x83/0x150
 [<ffffffff80253f68>] clear_page_dirty_for_io+0x68/0xd0
 [<ffffffff802544c0>] write_cache_pages+0x210/0x3c0
 [<ffffffff80253b90>] __writepage+0x0/0x40
 [<ffffffff802546d5>] do_writepages+0x35/0x40
 [<ffffffff80291faa>] __writeback_single_inode+0x9a/0x440
 [<ffffffff8031656a>] xfs_buf_rele+0x2a/0xb0
 [<ffffffff80316789>] xfs_buf_iorequest+0x39/0x80
 [<ffffffff8030a1bc>] xfs_trans_first_ail+0x1c/0x40
 [<ffffffff802927f7>] generic_sync_sb_inodes+0x2e7/0x440
 [<ffffffff80292b18>] writeback_inodes+0x38/0xc0
 [<ffffffff802550f0>] pdflush+0x0/0x190
 [<ffffffff8025480e>] wb_kupdate+0x8e/0x110
 [<ffffffff802550f0>] pdflush+0x0/0x190
 [<ffffffff802551c2>] pdflush+0xd2/0x190
 [<ffffffff80254780>] wb_kupdate+0x0/0x110
 [<ffffffff80239717>] kthread+0x47/0x80
 [<ffffffff802241b8>] schedule_tail+0x18/0x60
 [<ffffffff8020c029>] child_rip+0xa/0x11
 [<ffffffff802396d0>] kthread+0x0/0x80
 [<ffffffff8020c01f>] child_rip+0x0/0x11

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cd1c>] ktime_get+0xc/0x50
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 167, comm: pdflush Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80338af3>] __lookup_tag+0x83/0x140
 [<ffffffff80338c7c>] radix_tree_gang_lookup_tag_slot+0xcc/0xf0
 [<ffffffff8024d223>] find_get_pages_tag+0x43/0xc0
 [<ffffffff80255aea>] pagevec_lookup_tag+0x1a/0x30
 [<ffffffff802543da>] write_cache_pages+0x12a/0x3c0
 [<ffffffff80253b90>] __writepage+0x0/0x40
 [<ffffffff80316ae2>] xfs_buf_iostart+0x42/0xb0
 [<ffffffff802f6946>] xfs_iflush+0x2a6/0x310
 [<ffffffff802f2e64>] xfs_iunlock+0x84/0xc0
 [<ffffffff802546c0>] do_writepages+0x20/0x40
 [<ffffffff80291faa>] __writeback_single_inode+0x9a/0x440
 [<ffffffff8031656a>] xfs_buf_rele+0x2a/0xb0
 [<ffffffff80316789>] xfs_buf_iorequest+0x39/0x80
 [<ffffffff8030a1bc>] xfs_trans_first_ail+0x1c/0x40
 [<ffffffff802927f7>] generic_sync_sb_inodes+0x2e7/0x440
 [<ffffffff80292b18>] writeback_inodes+0x38/0xc0
 [<ffffffff802550f0>] pdflush+0x0/0x190
 [<ffffffff8025480e>] wb_kupdate+0x8e/0x110
 [<ffffffff802550f0>] pdflush+0x0/0x190
 [<ffffffff802551c2>] pdflush+0xd2/0x190
 [<ffffffff80254780>] wb_kupdate+0x0/0x110
 [<ffffffff80239717>] kthread+0x47/0x80
 [<ffffffff802241b8>] schedule_tail+0x18/0x60
 [<ffffffff8020c029>] child_rip+0xa/0x11
 [<ffffffff802396d0>] kthread+0x0/0x80
 [<ffffffff8020c01f>] child_rip+0x0/0x11

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80236250>] delayed_work_timer_fn+0x0/0x20
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803ebbae>] __qdisc_run+0x15e/0x1f0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cd1c>] ktime_get+0xc/0x50
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="allsyms.txt"

Act 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

Ending clean XFS mount for filesystem: sda7
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on sda6, internal journal
EXT4-fs: mounted filesystem with journal data mode.
EXT4-fs: Ignoring delalloc option - requested data journaling mode
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
XFS mounting filesystem sda8
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

Ending clean XFS mount for filesystem: sda8
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t1
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1228, comm: udevd Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 1328, comm: runscript.sh Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f3fa>] run_timer_softirq+0x1a/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8021dd31>] do_page_fault+0x81/0x9d0
 [<ffffffff80239bb0>] autoremove_wake_function+0x0/0x30
 [<ffffffff80239aa0>] bit_waitqueue+0x10/0xb0
 [<ffffffff802841d7>] d_kill+0x47/0x70
 [<ffffffff8023094e>] sys_rt_sigaction+0x8e/0xd0
 [<ffffffff80442c79>] error_exit+0x0/0x51

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1328, comm: runscript.sh Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
PPP generic driver version 2.4.2
NET: Registered protocol family 24
eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1570, comm: ebegin Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024c36c>] __rcu_process_callbacks+0x9c/0x220
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8033c5c5>] copy_page_c+0x5/0x10
 [<ffffffff8025b85a>] do_wp_page+0x10a/0x520
 [<ffffffff8025d0cd>] handle_mm_fault+0x2ed/0x690
 [<ffffffff8021dfbc>] do_page_fault+0x30c/0x9d0
 [<ffffffff802619de>] vma_merge+0x11e/0x2a0
 [<ffffffff80262520>] mmap_region+0x370/0x5b0
 [<ffffffff80262a0b>] do_mmap_pgoff+0x2ab/0x3a0
 [<ffffffff80442c79>] error_exit+0x0/0x51

ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t1
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1480, comm: dbus Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802855e2>] __d_lookup+0x42/0x110
 [<ffffffff8027a09b>] do_lookup+0x3b/0x260
 [<ffffffff802841d7>] d_kill+0x47/0x70
 [<ffffffff8027b99d>] __link_path_walk+0x14d/0xe70
 [<ffffffff8027c8ad>] path_walk+0x5d/0xc0
 [<ffffffff8027c9f7>] do_path_lookup+0x97/0x190
 [<ffffffff8027b7ed>] getname+0x18d/0x1f0
 [<ffffffff8027d847>] user_path_at+0x97/0xd0
 [<ffffffff80228f41>] wait_consider_task+0x5f1/0x800
 [<ffffffff80275694>] cp_new_stat+0xe4/0x100
 [<ffffffff80275563>] vfs_stat_fd+0x23/0x60
 [<ffffffff802757a7>] sys_newstat+0x27/0x50
 [<ffffffff8020b68b>] system_call_fastpath+0x16/0x1b

ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804334e0>] unix_poll+0x0/0xa0
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804334e0>] unix_poll+0x0/0xa0
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1779, comm: runscript.sh Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802855ff>] __d_lookup+0x5f/0x110
 [<ffffffff8027a09b>] do_lookup+0x3b/0x260
 [<ffffffff8027bbc8>] __link_path_walk+0x378/0xe70
 [<ffffffff802f2e64>] xfs_iunlock+0x84/0xc0
 [<ffffffff80311252>] xfs_readlink+0x82/0xa0
 [<ffffffff8027c40d>] __link_path_walk+0xbbd/0xe70
 [<ffffffff8027c8ad>] path_walk+0x5d/0xc0
 [<ffffffff8027c9f7>] do_path_lookup+0x97/0x190
 [<ffffffff8027cb7a>] __path_lookup_intent_open+0x6a/0xe0
 [<ffffffff8027dacc>] do_filp_open+0xbc/0x910
 [<ffffffff80262520>] mmap_region+0x370/0x5b0
 [<ffffffff80288d0a>] alloc_fd+0x3a/0x110
 [<ffffffff8027033b>] do_sys_open+0x5b/0x110
 [<ffffffff8020b68b>] system_call_fastpath+0x16/0x1b

RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t1
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1857, comm: couriertcpd Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024c36c>] __rcu_process_callbacks+0x9c/0x220
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 1879, comm: tor Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024c36c>] __rcu_process_callbacks+0x9c/0x220
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1885, comm: fetchmail Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803f69e5>] ip_rcv+0x1f5/0x280
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1911, comm: ebegin Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1734, comm: ddclient Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8033c577>] clear_page_c+0x7/0x10
 [<ffffffff8025327e>] get_page_from_freelist+0x3ae/0x550
 [<ffffffff8022a9de>] current_fs_time+0x1e/0x30
 [<ffffffff80253507>] __alloc_pages_internal+0xe7/0x4a0
 [<ffffffff8025d0ff>] handle_mm_fault+0x31f/0x690
 [<ffffffff8031bf83>] xfs_read+0x113/0x220
 [<ffffffff8021dfbc>] do_page_fault+0x30c/0x9d0
 [<ffffffff80239bb0>] autoremove_wake_function+0x0/0x30
 [<ffffffff80261a7c>] vma_merge+0x1bc/0x2a0
 [<ffffffff80272c9d>] vfs_read+0x12d/0x170
 [<ffffffff80442c79>] error_exit+0x0/0x51

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t1
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80400490>] tcp_poll+0x0/0x140
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80236250>] delayed_work_timer_fn+0x0/0x20
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cce0>] ktime_get_ts+0x30/0x60
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f3fa>] run_timer_softirq+0x1a/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1879, comm: tor Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024c36c>] __rcu_process_callbacks+0x9c/0x220
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8022b513>] __do_softirq+0x53/0xa0
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t1
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cd1c>] ktime_get+0xc/0x50
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: EH pending after 5 tries, giving up
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff80221e42>] activate_task+0x32/0x50
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff8022f4f0>] run_timer_softirq+0x110/0x1d0
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80218b80>] lapic_next_event+0x0/0x10
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1525, comm: syslog-ng Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8032a9ed>] blk_done_softirq+0x6d/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffffa00b4f39>] ext4_mark_iloc_dirty+0x279/0x510 [ext4dev]
 [<ffffffffa00b4d20>] ext4_mark_iloc_dirty+0x60/0x510 [ext4dev]
 [<ffffffffa00b5cbd>] ext4_mark_inode_dirty+0x6d/0x1b0 [ext4dev]
 [<ffffffffa00b63ff>] ext4_journalled_write_end+0x10f/0x160 [ext4dev]
 [<ffffffff80376a26>] tty_poll+0x96/0xa0
 [<ffffffff8024e896>] generic_file_buffered_write+0x1b6/0x6e0
 [<ffffffff80280e10>] __pollwait+0x0/0x130
 [<ffffffff8022a9de>] current_fs_time+0x1e/0x30
 [<ffffffff8024ced4>] file_remove_suid+0x24/0x80
 [<ffffffff8024f258>] __generic_file_aio_write_nolock+0x278/0x470
 [<ffffffff80284902>] dput+0xa2/0x140
 [<ffffffff8024fd14>] generic_file_aio_write+0x64/0xe0
 [<ffffffffa00b2f08>] ext4_file_write+0x58/0x170 [ext4dev]
 [<ffffffff80271f5b>] do_sync_write+0xdb/0x120
 [<ffffffff80239bb0>] autoremove_wake_function+0x0/0x30
 [<ffffffff8027297b>] vfs_write+0xcb/0x170
 [<ffffffff80272b23>] sys_write+0x53/0xa0
 [<ffffffff8020b68b>] system_call_fastpath+0x16/0x1b

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8033cee0>] delay_tsc+0x0/0x30
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #6

Call Trace:
 <IRQ>  [<ffffffff8023cd1c>] ktime_get+0xc/0x50
 [<ffffffff803bb433>] ata_eh_set_pending+0x43/0xe0
 [<ffffffff803bb5cd>] ata_do_link_abort+0x2d/0xf0
 [<ffffffff803bb6c7>] ata_port_freeze+0x27/0x60
 [<ffffffff803c200a>] nv_host_intr+0x8a/0xb0
 [<ffffffff803c21d3>] nv_nf2_interrupt+0x63/0x80
 [<ffffffff8024a234>] handle_IRQ_event+0x34/0x70
 [<ffffffff8024b5a1>] handle_fasteoi_irq+0x41/0xa0
 [<ffffffff8020e2dc>] do_IRQ+0x5c/0xc0
 [<ffffffff8020bb91>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8032bf30>] generic_unplug_device+0x0/0x20
 [<ffffffff80211e6a>] default_idle+0x3a/0x40
 [<ffffffff8020a729>] cpu_idle+0x49/0x90

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete

--dDRMvlgZJXvWKvBx--
