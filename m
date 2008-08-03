Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYHCHhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYHCHhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYHCHhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:37:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:24168 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYHCHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=KhocJK5djt/KsNNmjq522qvuycyweYAooqWVznEwABsxXEmCVeRNpPVOESLLwmKbR/
         sqNZ2QKaAexluMOQklEI3E3xVhgJcq8TdZxfau2d8ErPI6+Ro7HI8eBeP6+dl+wipwaP
         51qVWSN4T3WW2gLNrUsKXdI8ch6OLMirtWGLM=
Date: Sun, 3 Aug 2008 13:07:05 +0530
From: Rabin Vincent <rabin@rab.in>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge.A.S@tochka.ru, mxhaard@users.sourceforge.net, moinejf@free.fr,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: Re: gspca_zc3xx oops - 2.6.27-rc1
Message-ID: <20080803073705.GA2754@debian>
References: <82e4877d0808020922x64177318j6f8fe15955704521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0808020922x64177318j6f8fe15955704521@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 12:22:18PM -0400, Parag Warudkar wrote:
>  4571.473627] usb 8-8.3: new full speed USB device using ehci_hcd and
> address 7
> [ 4571.571787] usb 8-8.3: configuration #1 chosen from 1 choice
> [ 4571.665523] Linux video capture interface: v2.00
> [ 4571.713677] gspca: main v2.2.0 registered
> [ 4573.740658] usbcore: registered new interface driver zc3xx
> [ 4573.765220] zc0301: V4L2 driver for ZC0301[P] Image Processor and
> Control Chip v1:1.10
> [ 4573.765260] usbcore: registered new interface driver zc0301
> [ 4575.305949] BUG: unable to handle kernel NULL pointer dereference
> at 00000000
> [ 4575.305954] IP: [<f915c2d4>] :gspca_zc3xx:setcontrast+0x34/0xf0
> [ 4575.305961] *pdpt = 000000001ac9c001 *pde = 0000000000000000
> [ 4575.305964] Oops: 0000 [#1] SMP
> [ 4575.305967] Modules linked in: zc0301 gspca_zc3xx gspca_main
> videodev v4l1_compat af_packet radeon drm binfmt_misc rfcomm l2cap
> bluetooth kvm_intel kvm ppdev ipv6 acpi_cpufreq cpufreq_powersave
> cpufreq_stats cpufreq_conservative cpufreq_ondemand freq_table
> cpufreq_userspace container video output pci_slot battery
> iptable_filter ip_tables x_tables ac sbp2 lp snd_hda_intel snd_pcm_oss
> psmouse snd_mixer_oss appledisplay serio_raw pl2303 snd_pcm snd_timer
> usbserial snd_page_alloc snd_hwdep pcspkr parport_serial snd soundcore
> iTCO_wdt parport_pc parport iTCO_vendor_support intel_agp agpgart
> shpchp button pci_hotplug e1000e evdev ext3 jbd mbcache sg sr_mod
> cdrom sd_mod usbhid hid usb_storage libusual ahci libata scsi_mod
> ohci1394 dock ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan
> thermal_sys fuse
> [ 4575.306009]
> [ 4575.306011] Pid: 15345, comm: kopete Not tainted (2.6.27-rc1 #3)
> [ 4575.306013] EIP: 0060:[<f915c2d4>] EFLAGS: 00010286 CPU: 0
> [ 4575.306016] EIP is at setcontrast+0x34/0xf0 [gspca_zc3xx]
> [ 4575.306018] EAX: ffffffff EBX: 00000120 ECX: f60f84f8 EDX: 00000000
> [ 4575.306019] ESI: f4194000 EDI: 00000000 EBP: f5597c00 ESP: da81bd64
> [ 4575.306021]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 4575.306023] Process kopete (pid: 15345, ti=da81a000 task=f5c7fb10
> task.ti=da81a000)
> [ 4575.306024] Stack: 00000000 f9163c00 f4194000 f5597c00 f559d000
> f915d25b 0000000b d9448000
> [ 4575.306029]        f45963c0 f4194000 00000300 f559d000 f9151e09
> 00000000 00000000 f41947bc
> [ 4575.306033]        f419479c 00000006 f55fce00 00006000 00000002
> 00000020 00000001 f91531c0
> [ 4575.306038] Call Trace:
> [ 4575.306044]  [<f915d25b>] sd_start+0x12b/0x4a0 [gspca_zc3xx]
> [ 4575.306048]  [<f9151e09>] vidioc_streamon+0x269/0x340 [gspca_main]
> [ 4575.306055]  [<fa1b41b3>] __video_do_ioctl+0x15b3/0x3bb0 [videodev]
> [ 4575.306060]  [<c012445a>] resched_task+0x1a/0x60
> [ 4575.306065]  [<c0127098>] try_to_wake_up+0xa8/0x140
> [ 4575.306068]  [<c0123a2b>] __wake_up_common+0x4b/0x80
> [ 4575.306070]  [<c03425a5>] _spin_lock+0x5/0x10
> [ 4575.306073]  [<c01b3dd7>] mnt_drop_write+0x57/0x110
> [ 4575.306077]  [<c0131963>] current_fs_time+0x13/0x20
> [ 4575.306080]  [<c01b0d27>] file_update_time+0x47/0xd0
> [ 4575.306083]  [<c01a322e>] pipe_write+0x32e/0x450
> [ 4575.306086]  [<fa1b6a85>] video_ioctl2+0xc5/0x210 [videodev]
> [ 4575.306090]  [<c0107c65>] __switch_to+0x155/0x160
> [ 4575.306094]  [<c012852f>] finish_task_switch+0x1f/0xb0
> [ 4575.306096]  [<c0340adb>] schedule+0x24b/0x680
> [ 4575.306098]  [<c01a89c8>] vfs_ioctl+0x78/0x90
> [ 4575.306101]  [<c01a8c31>] do_vfs_ioctl+0x251/0x2a0
> [ 4575.306103]  [<c01a8cd6>] sys_ioctl+0x56/0x70
> [ 4575.306105]  [<c0108d3b>] sysenter_do_call+0x12/0x2f
> [ 4575.306108]  =======================
> [ 4575.306109] Code: 83 ec 04 0f b6 90 da 07 00 00 8b a8 04 02 00 00
> 0f b6 80 d9 07 00 00 8b 3c 95 f4 dc 15 f9 8b 14 95 d8 dc 15 f9 83 c0
> 80 89 14 24 <0f> b6 37 0f af f0 8d b6 00 00 00 00 0f b6 83 00 dc 15 f9
> 0f af
> [ 4575.306133] EIP: [<f915c2d4>] setcontrast+0x34/0xf0 [gspca_zc3xx]
> SS:ESP 0068:da81bd64
> [ 4575.306141] ---[ end trace 0d1ec2bc5f41176e ]---

I'm not familiar with v4l, but I'll take a crack at this.  This decodes to:

   3:   0f b6 90 da 07 00 00    movzbl 0x7da(%eax),%edx
   a:   8b a8 04 02 00 00       mov    0x204(%eax),%ebp
  10:   0f b6 80 d9 07 00 00    movzbl 0x7d9(%eax),%eax
  17:   8b 3c 95 f4 dc 15 f9    mov    -0x6ea230c(,%edx,4),%edi
  1e:   8b 14 95 d8 dc 15 f9    mov    -0x6ea2328(,%edx,4),%edx
  25:   83 c0 80                add    $0xffffff80,%eax
  28:   89 14 24                mov    %edx,(%esp)
  2b:   0f b6 37                movzbl (%edi),%esi <---- offender
  2e:   0f af f0                imul   %eax,%esi
  31:   8d b6 00 00 00 00       lea    0x0(%esi),%esi
  37:   0f b6 83 00 dc 15 f9    movzbl -0x6ea2400(%ebx),%eax

%edi is Tgamma, and it is NULL because sd->gamma was 0, and the zeroth element
of gamma_tb was loaded.

Now sd->gamma shouldn't be zero because in sd_ctrls, the minimum value for it
is set to 1.  This range should be checked by vidioc_s_ctrl in gspca.c, and we
have this there:

               if (ctrl->value < ctrls->qctrl.minimum
                   && ctrl->value > ctrls->qctrl.maximum)
                        return -ERANGE;

There's a typo in this check, so userspace is able to set gamma to zero, and
the crash happens when streaming is started.

Could you please try the patch below?

>From 6827a2973d512479c8cf61d4a7ae1b6c4099b65b Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 3 Aug 2008 12:00:04 +0530
Subject: [PATCH] gspca: Fix ioctl range checking

Correctly check that the value to be set is within range.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 drivers/media/video/gspca/gspca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 3a051c9..f2ddd9d 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -904,7 +904,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 		if (ctrl->id != ctrls->qctrl.id)
 			continue;
 		if (ctrl->value < ctrls->qctrl.minimum
-		    && ctrl->value > ctrls->qctrl.maximum)
+		    || ctrl->value > ctrls->qctrl.maximum)
 			return -ERANGE;
 		PDEBUG(D_CONF, "set ctrl [%08x] = %d", ctrl->id, ctrl->value);
 		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
