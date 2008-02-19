Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYBSTWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYBSTWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYBSTWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:22:34 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:7760 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYBSTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EC6OQGs7uRNgXPYf3Q8GY5jgf9x3zmVfANNyS2jsExDOfRNfiyFKGnVhK2SdIBkG/9pAB9hH/MzEiebYZ67EyDFBzMG+EqfLzzuwODssiR1bL0UGMLXv9wgbAK16Sv3+Lo39/OfyFISLuJ5a4Z/iqX5ZzWPIUWMlAfFzjbdYjTM=
Message-ID: <4d569c330802191122x75ccb8cakcd7a3368ada9f4ef@mail.gmail.com>
Date: Tue, 19 Feb 2008 14:22:29 -0500
From: "Kevin Coffman" <kwcoffman@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.24-sha1: RIP [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Kevin Coffman" <kwc@citi.umich.edu>
In-Reply-To: <200802191220.52976.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080210140031.GA1754@martell.zuzino.mipt.ru>
	 <20080212140430.c85e6018.akpm@linux-foundation.org>
	 <20080212222704.GC2144@martell.zuzino.mipt.ru>
	 <200802191220.52976.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 8:20 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Wednesday 13 February 2008 09:27, Alexey Dobriyan wrote:
> > On Tue, Feb 12, 2008 at 02:04:30PM -0800, Andrew Morton wrote:
>
> Can you try this patch please?

Sorry, I still see (only with DEBUG_PAGEALLOC enabled):

kernel: BUG: unable to handle kernel paging request at ffff81006a509008
kernel: IP: [<ffffffff80268313>] iov_iter_advance+0x4f/0x67
kernel: PGD 8063 PUD a063 PMD 6a400163 PTE 800000006a509160
kernel: Oops: 0000 [1] SMP DEBUG_PAGEALLOC
kernel: CPU 1
kernel: Modules linked in: i915 drm nfsd exportfs autofs4 hidp l2cap
bluetooth cbc crypto_blkcipher nfs lockd nfs_acl rpcsec_gss_krb5
auth_rpcgss des_generic sunrpc ipv6 nf_conntrack_netbios_ns ipt_REJECT
nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter
ip_tables x_tables cpufreq_ondemand acpi_cpufreq dm_mirror
dm_multipath dm_mod video output sbs sbshc dock battery ac
snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss sr_mod snd_pcm snd_timer
cdrom snd serio_raw button ohci1394 ieee1394 pcspkr i2c_i801 i2c_core
soundcore snd_page_alloc r8169 iTCO_wdt iTCO_vendor_support sg ahci
ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[last unloaded: scsi_wait_scan]
kernel: Pid: 2299, comm: nfsd Not tainted 2.6.25-rc1 #46
kernel: RIP: 0010:[<ffffffff80268313>]  [<ffffffff80268313>]
iov_iter_advance+0x4f/0x67
kernel: RSP: 0018:ffff810073c4d8a8  EFLAGS: 00010246
kernel: RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000000000
kernel: RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff810073c4d940
kernel: RBP: 0000000000001000 R08: 0000000000000000 R09: ffff81006a509000
kernel: R10: 0000000000001000 R11: 6a6a6a6a6a6a6a6a R12: 0000000000ef7000
kernel: R13: 0000000000001000 R14: ffff810073c4d940 R15: 0000000000007000
kernel: FS:  00007f1898ea86f0(0000) GS:ffff81007e3b99c0(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: ffff81006a509008 CR3: 000000007b1e2000 CR4: 00000000000006e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process nfsd (pid: 2299, threadinfo ffff810073c4c000, task
ffff81007c62f500)
kernel: Stack:  ffffffff8026999b ffff8100698a9500 ffff810073c4d970
ffff81006a5b65b0
kernel:  ffff8100698a9658 0000000100000014 ffff810073c4db50 0000000000ef0000
kernel:  ffff810073c4dad0 ffff81007d84fe80 ffff8100698a9658 ffffffff88042bc0
kernel: Call Trace:
kernel:  [<ffffffff8026999b>] ? generic_file_buffered_write+0x1dc/0x631
kernel:  [<ffffffff80237fcb>] ? current_fs_time+0x1e/0x24
kernel:  [<ffffffff80222ec7>] ? __change_page_attr_set_clr+0x57/0xaf
kernel:  [<ffffffff8026a12f>] ? __generic_file_aio_write_nolock+0x33f/0x3a9
kernel:  [<ffffffff8026a1fa>] ? generic_file_aio_write+0x61/0xc1
kernel:  [<ffffffff880322fa>] ? :ext3:ext3_file_write+0x16/0x94
kernel:  [<ffffffff880322e4>] ? :ext3:ext3_file_write+0x0/0x94
kernel:  [<ffffffff80290443>] ? do_sync_readv_writev+0xc0/0x107
kernel:  [<ffffffff802454b6>] ? autoremove_wake_function+0x0/0x2e
kernel:  [<ffffffff802902d9>] ? rw_copy_check_uvector+0x6c/0xdc
kernel:  [<ffffffff80290af6>] ? do_readv_writev+0xb2/0x18b
kernel:  [<ffffffff8841048a>] ? :exportfs:find_acceptable_alias+0x1a/0xe2
kernel:  [<ffffffff884105fb>] ? :exportfs:exportfs_decode_fh+0xa9/0x1de
kernel:  [<ffffffff88417c2d>] ? :nfsd:nfsd_acceptable+0x0/0xd3
kernel:  [<ffffffff88418bf6>] ? :nfsd:nfsd_vfs_write+0xe9/0x2dd
kernel:  [<ffffffff8023fad7>] ? set_current_groups+0x156/0x161
kernel:  [<ffffffff8841dfc1>] ? :nfsd:nfsd_setuser+0x116/0x201
kernel:  [<ffffffff88419483>] ? :nfsd:nfsd_write+0x79/0xe2
kernel:  [<ffffffff8842329a>] ? :nfsd:nfsd4_write+0xd0/0xfc
kernel:  [<ffffffff88423833>] ? :nfsd:nfsd4_proc_compound+0x1ad/0x2b9
kernel:  [<ffffffff88415245>] ? :nfsd:nfsd_dispatch+0xde/0x1b6
kernel:  [<ffffffff8832b25e>] ? :sunrpc:svc_process+0x3f0/0x6e2
kernel:  [<ffffffff8841567c>] ? :nfsd:nfsd+0x0/0x2c0
kernel:  [<ffffffff8841581f>] ? :nfsd:nfsd+0x1a3/0x2c0
kernel:  [<ffffffff8022f1d1>] ? schedule_tail+0x28/0x5d
kernel:  [<ffffffff8020cc18>] ? child_rip+0xa/0x12
kernel:  [<ffffffff8841567c>] ? :nfsd:nfsd+0x0/0x2c0
last message repeated 2 times
kernel:  [<ffffffff8020cc0e>] ? child_rip+0x0/0x12
kernel:
kernel:
kernel: Code: eb 24 49 8b 51 08 48 89 d0 48 29 c8 4c 39 c0 49 0f 47 c0
48 98 48 01 c1 48 39 ca 75 06 49 83 c1 10 31 c9 49 29 c0 4d 85 c0 75
d7 <49> 83 79 08 00 75 05 4d 85 d2 75 cb 4c 89 0f 48 89 4f 10 48 29
kernel: RIP  [<ffffffff80268313>] iov_iter_advance+0x4f/0x67
kernel:  RSP <ffff810073c4d8a8>
kernel: CR2: ffff81006a509008
kernel: ---[ end trace 0ce02d00f5455fd8 ]---
