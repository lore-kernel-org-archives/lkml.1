Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZJBFBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZJBFBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZJBFBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:01:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41752 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZJBFBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:01:39 -0400
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20091002012911.GA18542@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 01 Oct 2009 22:01:34 -0700
In-Reply-To: <20091002012911.GA18542@kroah.com> (Greg KH's message of "Thu\, 1 Oct 2009 18\:29\:11 -0700")
Message-ID: <m1tyyixuc1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [000/136] 2.6.31.2-stable review
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> Note from the -stable maintainer on this release:
>
>   This release is big.  Yeah, really big.  There are a number of
>   areas that needed some rework in order to get things back to
>   working order.  Like the tty layer.  Hopefully everyone can now
>   use their usb to serial devices again without oopsing the
>   kernel

The ftdi_sio driver still crashes and burns.

CPU 0:
Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp bnep l2cap bluetooth sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_mirror dm_region_hash dm_log dm_multipath dm_mod uinput kvm_amd kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q snd_hda_codec_realtek k8temp amd64_edac_mod snd_hda_intel snd_hda_codec snd_hwdep ftdi_sio firewire_ohci edac_core hwmon e1000e sata_sil24 snd_pcm snd_timer firewire_core usbserial forcedeth pata_amd crc_itu_t snd soundcore pcspkr snd_page_alloc i2c_nforce2 i2c_core sg ata_generic pata_acpi sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.31.2-rc1 #7  
RIP: 0010:[<ffffffff8102c840>]  [<ffffffff8102c840>] native_safe_halt+0x6/0x8
RSP: 0018:ffffffff81545e48  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81545e48 RCX: 0000000003000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81545e58
RBP: ffffffff8100c7ce R08: 0000000000000000 R09: 0000000000080e80
R10: 0000000000000000 R11: 000000000000000e R12: ffffffff810737df
R13: ffffffff81545dd8 R14: ffffffff8105c697 R15: ffffffff81545e38
FS:  00007fe3e0df5910(0000) GS:ffff8800017bd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000001d9c000 CR3: 000000003b8e6000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff81014126>] ? default_idle+0x51/0x8b
 [<ffffffff81014265>] ? c1e_idle+0x105/0x120
 [<ffffffff8100ae15>] ? cpu_idle+0xb0/0xf3
 [<ffffffff81392185>] ? rest_init+0x79/0x8f
 [<ffffffff815ccfae>] ? start_kernel+0x3dc/0x3fd
 [<ffffffff815cc2d4>] ? x86_64_start_reservations+0xbb/0xd6
 [<ffffffff815cc3f4>] ? x86_64_start_kernel+0x105/0x128
bad: scheduling from the idle thread!
Pid: 0, comm: swapper Not tainted 2.6.31.2-rc1 #7
Call Trace:
 <IRQ>  [<ffffffff81041021>] dequeue_task_idle+0x37/0x5a
 [<ffffffff810407e3>] dequeue_task+0xce/0xf0
 [<ffffffff8104083c>] deactivate_task+0x37/0x56
 [<ffffffff813a4fc7>] schedule+0x13d/0x6f3
 [<ffffffff81042942>] ? enqueue_task_fair+0xdf/0x13c
 [<ffffffff810700a2>] ? sched_clock_cpu+0x162/0x17f
 [<ffffffff813a5e97>] __mutex_lock_common+0x12f/0x1aa
 [<ffffffff813a5f39>] __mutex_lock_slowpath+0x27/0x3d
 [<ffffffff813a5c4d>] mutex_lock+0x25/0x53
 [<ffffffff81253f55>] tty_unthrottle+0x29/0x6d
 [<ffffffff812528e6>] reset_buffer_flags+0xe8/0x105
 [<ffffffff81252927>] n_tty_flush_buffer+0x24/0x97
 [<ffffffff812535d7>] n_tty_receive_buf+0xc3d/0xe72
 [<ffffffff8129b8b1>] ? usb_submit_urb+0x30d/0x33f
 [<ffffffff8129b151>] ? usb_hcd_submit_urb+0x888/0x943
 [<ffffffff81254ddf>] ? tty_ldisc_try+0x53/0x71
 [<ffffffff81255ee1>] flush_to_ldisc+0x116/0x1bd
 [<ffffffff81255fe6>] tty_flip_buffer_push+0x5e/0x85
 [<ffffffffa01ff0ab>] ftdi_process_read+0x481/0x627 [ftdi_sio]
 [<ffffffffa0000fa3>] ? ehci_qtd_free+0x27/0x3d [ehci_hcd]
 [<ffffffffa01ff480>] ftdi_read_bulk_callback+0x22f/0x25a [ftdi_sio]
 [<ffffffff81040c49>] ? complete+0x54/0x73
 [<ffffffffa00db214>] ? nv_host_intr+0x2f/0x87 [sata_nv]
 [<ffffffff81299a86>] usb_hcd_giveback_urb+0x9b/0xe5
 [<ffffffffa00010f9>] ehci_urb_done+0x91/0xbc [ehci_hcd]
 [<ffffffffa00027f3>] qh_completions+0x42a/0x4ca [ehci_hcd]
 [<ffffffffa0002938>] ehci_work+0xa5/0x7ab [ehci_hcd]
 [<ffffffffa00db90f>] ? nv_swncq_interrupt+0x6a3/0x6d1 [sata_nv]
 [<ffffffff81073401>] ? clocksource_read+0x1d/0x33
 [<ffffffffa000597f>] ehci_irq+0x351/0x391 [ehci_hcd]
 [<ffffffff81056273>] ? irq_exit+0x5f/0xa3
 [<ffffffff81073401>] ? clocksource_read+0x1d/0x33
 [<ffffffff810737df>] ? getnstimeofday+0x69/0xd3
 [<ffffffff81299390>] usb_hcd_irq+0x4d/0xa1
 [<ffffffff810a2313>] handle_IRQ_event+0x6a/0x13f
 [<ffffffff810a43d3>] handle_fasteoi_irq+0x90/0xe1
 [<ffffffff8100eb5a>] handle_irq+0x95/0xb7
 [<ffffffff8100df49>] do_IRQ+0x6a/0xe0
 [<ffffffff8100c7d3>] ret_from_intr+0x0/0x11
 <EOI>  [<ffffffff8102c840>] ? native_safe_halt+0x6/0x8
 [<ffffffff81014126>] ? default_idle+0x51/0x8b
 [<ffffffff81014265>] ? c1e_idle+0x105/0x120
 [<ffffffff8100ae15>] ? cpu_idle+0xb0/0xf3
 [<ffffffff81392185>] ? rest_init+0x79/0x8f
 [<ffffffff815ccfae>] ? start_kernel+0x3dc/0x3fd
 [<ffffffff815cc2d4>] ? x86_64_start_reservations+0xbb/0xd6
 [<ffffffff815cc3f4>] ? x86_64_start_kernel+0x105/0x128
BUG: scheduling while atomic: swapper/0/0x00010000

Eric
