Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYK3UUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYK3UUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 15:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYK3UUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 15:20:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50382 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYK3UUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 15:20:37 -0500
Message-ID: <4932F59D.2060002@redhat.com>
Date: Sun, 30 Nov 2008 22:20:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
References: <20081130193401.GA7690@hades>
In-Reply-To: <20081130193401.GA7690@hades>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques wrote:
> Hi,
>
> Maybe this is duplicated bug report, but since I was not able to find any
> reference to it, I am reporting it anyway.
>
> I am running 2.6.28-rc6-00007-ged31348 on x86_64.
>
> I just tried to start kvm and got the following:
>
> [  883.483978] ------------[ cut here ]------------
> [  883.483995] kernel BUG at /home/miguel/projects/linux/trees/linux-2.6/arch/x86/kvm/../../../virt/kvm/kvm_main.c:1824!
> [  883.484006] invalid opcode: 0000 [#1] PREEMPT SMP 
> [  883.484021] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> [  883.484031] Dumping ftrace buffer:
> [  883.484038]    (ftrace buffer empty)
> [  883.484044] CPU 1 
> [  883.484052] Modules linked in: kqemu loop aes_x86_64 aes_generic af_packet binfmt_misc bridge stp llc rfcomm bnep sco l2cap bluetooth vboxdrv kvm_amd kvm 
> parport_pc ppdev parport ipv6 powernow_k8 cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_ondemand freq_table cpufreq_conservative container sbs wm
> i sbshc iptable_filter ip_tables x_tables sbp2 arc4 snd_hda_intel ecb snd_pcm snd_page_alloc snd_hwdep ath5k snd_seq snd_timer snd_seq_device mac80211 led_cl
> ass uvcvideo i2c_piix4 snd compat_ioctl32 videodev v4l1_compat cfg80211 i2c_core k8temp psmouse rfkill video output battery soundcore ac input_polldev button
>  evdev ext3 jbd mbcache sr_mod cdrom ata_generic pata_acpi sg sd_mod pata_atiixp ahci ide_pci_generic ohci1394 ieee1394 ide_core ehci_hcd ohci_hcd libata usb
>  core scsi_mod r8169 mii thermal processor fan fuse
>  [  883.484270] Pid: 10886, comm: kvm Tainted: G        W  2.6.28-rc6-00007-ged31348 #1
>  [  883.484270] RIP: 0010:[<ffffffffa04b8262>]  [<ffffffffa04b8262>] kvm_handle_fault_on_reboot+0x12/0x20 [kvm]
>   

Is it repeatable? Does it happen if you prefix the qemu command with 
'taskset 1'?



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

