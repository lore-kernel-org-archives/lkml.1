Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZFWQLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZFWQLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZFWQLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:11:37 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.66]:41253 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZFWQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:11:36 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Wed, 24 Jun 2009 01:10:41 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: Andrew Randrianasulu <randrik_a@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       mingo@elte.hu, nishimura@mxp.nes.nec.co.jp
Subject: Re: list_add corruption in current Linus's tree?
Message-Id: <20090624011041.3c89a451.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <309427.75128.qm@web65313.mail.ac2.yahoo.com>
References: <309427.75128.qm@web65313.mail.ac2.yahoo.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 08:48:04 -0700 (PDT)
Andrew Randrianasulu <randrik_a@yahoo.com> wrote:

> 
> Hello!
> 
> I'm currently using vanilla kernel form kernel.org, up to commit d888a4c76c51092993643f8992bf55b3c28da483. Since yesterday i saw many warnings like this in dmesg:
> 
> ------------[ cut here ]------------
> WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
> Hardware name: MS-6380E
> list_add corruption. next->prev should be prev (cf801454), but was c22302fc. (next=c2282c28).
> Modules linked in: radeon ttm drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect sg snd_seq_dummy snd_seq_oss sd_mod snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipv6 nfsd lockd nfs_acl auth_rpcgss sunrpc usb_storage scsi_mod usb_libusual tuner_simple tuner_types ppdev tda9887 tda8290 snd_cs4236 snd_mpu401 snd_emu10k1 snd_via82xx snd_wavefront snd_ac97_codec snd_wss_lib ac97_bus snd_opl3_lib uhci_hcd saa7134 snd_mpu401_uart snd_pcm ir_common snd_rawmidi snd_timer snd_page_alloc ehci_hcd snd_util_mem videobuf_dma_sg snd_seq_device snd_hwdep videobuf_core snd parport_pc tveeprom usbcore rtc_cmos rtc_core emu10k1_gp ns558 soundcore parport floppy gameport rtc_lib shpchp 8139too pci_hotplug via_agp xfs exportfs ufs agpgart tuner v4l2_common videodev v4l1_compat w83627hf hwmon_vid hwmon i2c_viapro i2c_dev fbcon tileblit font bitblit softcursor fb
> Pid: 4000, comm: X Tainted: G        W  2.6.30-i486 #17
> Call Trace:
>  [<c1033bd6>] warn_slowpath_common+0x65/0x95
>  [<c1033c44>] warn_slowpath_fmt+0x29/0x2c
>  [<c1156ebf>] __list_add+0x27/0x5c
>  [<c10b9381>] mem_cgroup_add_lru_list+0x43/0x55
>  [<c10975b4>] add_page_to_lru_list+0x3d/0x42
>  [<c10978a1>] ____pagevec_lru_add+0xea/0x12c
>  [<c1097be4>] lru_add_drain+0x3c/0x86
>  [<c10a68a3>] unmap_region+0x34/0x10d
>  [<c10a7629>] do_munmap+0x1df/0x235
>  [<c10a76b4>] sys_munmap+0x35/0x44
>  [<c1002bc5>] syscall_call+0x7/0xb
> ---[ end trace fda7f44fa2651cfc ]---
> 
> but many, many more. Should i create bug in kernel bugzilla, or it is known  issue?
> 
It's a known issue.

I think Andrew has already queued the fix(http://lkml.org/lkml/2009/6/22/566).

Thank you for your report.

Daisuke Nishimura.

