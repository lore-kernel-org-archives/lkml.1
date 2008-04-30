Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbYD3Ojy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbYD3Ojy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYD3Ojm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:39:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:25695 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYD3Ojl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xC948mh0e0mgEgTFMFaKQH15UHOvJhtHfLjsNh3gYGuwTfQF94TdjxwvuBMnMnmGzZ2za5R8cTjkHSE7ilDY3LwQ8nXMaG0wBEdEqwQzBPfqVESc6bI3CJzVMm/QnTpJjmcm6KB6pEBLuftga1PzBgE0kn5sPBhmJNVsDnlaoxs=
Message-ID: <37219a840804300739t6bade9c0o2eeaeb0ef42dffee@mail.gmail.com>
Date: Wed, 30 Apr 2008 10:39:31 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [v4l-dvb-maintainer] [patch, -git] drivers/media build fix for modular builds
Cc: "Andrew Morton" <akpm@linux-foundation.org>, sfr@canb.auug.org.au,
       video4linux-list@redhat.com, "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, mchehab@infradead.org,
       linux-dvb-maintainer@linuxtv.org, "Ingo Molnar" <mingo@elte.hu>,
       torvalds@linux-foundation.org, "David Miller" <davem@davemloft.net>
In-Reply-To: <1209560592.5265.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429185009.716c3284@gaivota> <20080430074807.GA11224@elte.hu>
	 <20080430.005212.46815036.davem@davemloft.net>
	 <20080430081345.GA16519@elte.hu>
	 <1209544030.30990.2.camel@marge.simson.net>
	 <1209544951.15609.3.camel@marge.simson.net>
	 <1209545784.31419.2.camel@marge.simson.net>
	 <1209547231.4898.2.camel@marge.simson.net>
	 <20080430044009.6c5bbc8d.akpm@linux-foundation.org>
	 <1209560592.5265.2.camel@marge.simson.net>
X-Google-Sender-Auth: 5d4cc742a0520dfb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 9:03 AM, Mike Galbraith <efault@gmx.de> wrote:
>
>  On Wed, 2008-04-30 at 04:40 -0700, Andrew Morton wrote:
>  > On Wed, 30 Apr 2008 11:20:31 +0200 Mike Galbraith <efault@gmx.de> wrote:
>  >
>  > > [   16.299803] kernel BUG at kernel/module.c:784!
>  > > [   16.307170] invalid opcode: 0000 [1] SMP
>  > > [   16.314110] CPU 3
>  > > [   16.318911] Modules linked in: tuner(+) snd_hda_intel(+) saa7134(+) compat_ioctl32 firewire_ohci videodev snd_pcm firewire_core v4l1_compat v4l2_common snd_timer videobuf_dma_sg videobuf_core crc_itu_t snd_page_alloc snd_hwdep ir_kbd_i2c ohci1394 snd ir_common usb_storage rtc_cmos ieee1394 tveeprom rtc_core i2c_i801 button sr_mod intel_agp serio_raw e1000e iTCO_wdt i2c_core iTCO_vendor_support rtc_lib cdrom sg soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
>  > > [   16.386303] Pid: 2239, comm: modprobe Not tainted 2.6.26-smp #1
>  > > [   16.395339] RIP: 0010:[<ffffffff80254714>]  [<ffffffff80254714>] __symbol_put+0x22/0x31
>  >
>  > Does this make it feel better?
>
>  Well, it doesn't go BUG() any more, but it now goes oops.
>
>  [   13.443404] saa7133[0]: i2c eeprom 00: be 16 0d 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>  [   13.456281] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
>  [   13.469575] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 29 02 51 96 2b
>  [   13.483794] saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
>  [   13.498518] saa7133[0]: i2c eeprom 40: ff 28 00 c0 96 10 03 00 c0 1c fd 79 44 9f c2 8f
>  [   13.507664] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507670] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507676] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507680] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507684] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507688] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507692] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507696] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507700] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507703] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.507707] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  [   13.666587] TUNER: Unable to find symbol tda829x_probe()
>  [   13.674638] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
>  [   13.691175] DVB: Unable to find symbol tda9887_attach()
>  [   13.698968] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>  [   13.709509] IP: [<ffffffff80302934>] strlcpy+0x11/0x36
>  [   13.711135] PGD be167067 PUD be140067 PMD 0
>  [   13.711137] Oops: 0000 [1] SMP
>  [   13.711139] CPU 2
>  [   13.711140] Modules linked in: tuner(+) snd_hda_intel(+) saa7134(+) compat_ioctl32 snd_pcm videodev firewire_ohci v4l1_compat firewire_core v4l2_common snd_timer videobuf_dma_sg videobuf_core crc_itu_t snd_page_alloc snd_hwdep ir_kbd_i2c rtc_cmos snd rtc_core ohci1394 ir_common usb_storage usbhid tveeprom ieee1394 sr_mod e1000e i2c_i801 rtc_lib cdrom i2c_core hid iTCO_wdt button intel_agp serio_raw ff_memless soundcore iTCO_vendor_support sg ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
>  [   13.711158] Pid: 2175, comm: modprobe Not tainted 2.6.26-smp #3
>  [   13.711160] RIP: 0010:[<ffffffff80302934>]  [<ffffffff80302934>] strlcpy+0x11/0x36
>  [   13.711163] RSP: 0018:ffff8100bcc45b68  EFLAGS: 00010286
>  [   13.711164] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffffffffff
>  [   13.711165] RDX: 0000000000000014 RSI: 0000000000000000 RDI: 0000000000000000
>  [   13.711167] RBP: ffff8100bcc45b68 R08: ffff8100bf0b7404 R09: 0000000000000000
>  [   13.711169] R10: ffff8100bcc45908 R11: ffff81003784ab70 R12: ffff8100bf0b6400
>  [   13.711170] R13: ffff8100bf0b7400 R14: 000000000000004a R15: 000000000000000e
>  [   13.711172] FS:  00007fcb8bad66f0(0000) GS:ffff8100bf806780(0000) knlGS:0000000000000000
>  [   13.711174] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>  [   13.711175] CR2: 0000000000000000 CR3: 00000000be142000 CR4: 00000000000006e0
>  [   13.711177] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [   13.711178] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  [   13.711180] Process modprobe (pid: 2175, threadinfo ffff8100bcc44000, task ffff8100bd112c40)
>  [   13.711181] Stack:  ffff8100bcc45c08 ffffffffa02d43a3 0000000000000096 ffff8100bd486490
>  [   13.711185]  0000000000000000 ffffffffa02d681c ffff8100bcc45bd8 ffffffff80253b08
>  [   13.711187]  ffff8100bcc45bf8 ffff8100bf0b7400 ffff8100bf0b6400 ffffffffa02d8e80
>  [   13.711190] Call Trace:
>  [   13.711196]  [<ffffffffa02d43a3>] :tuner:set_type+0x682/0x9ed
>  [   13.711201]  [<ffffffff80253b08>] ? __find_symbol+0x2c5/0x34b
>  [   13.711213]  [<ffffffffa02d4cdb>] :tuner:tuner_probe+0x4d1/0x50f
>  [   13.711220]  [<ffffffffa0135ba6>] ? :i2c_core:__i2c_check_addr+0x0/0x31
>  [   13.711225]  [<ffffffffa02d478d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
>  [   13.711234]  [<ffffffffa0200362>] :v4l2_common:v4l2_i2c_attach+0x65/0x96
>  [   13.711237]  [<ffffffffa02d480a>] ? :tuner:tuner_probe+0x0/0x50f
>  [   13.711243]  [<ffffffffa02d478d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
>  [   13.711248]  [<ffffffffa02d47ab>] :tuner:v4l2_i2c_drv_attach_legacy+0x1e/0x20
>  [   13.711255]  [<ffffffffa0134b6c>] :i2c_core:i2c_probe_address+0xbe/0x105
>  [   13.711264]  [<ffffffffa0134d0f>] :i2c_core:i2c_probe+0x15c/0x16f
>  [   13.711268]  [<ffffffffa02d478d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
>  [   13.711275]  [<ffffffffa02d4784>] :tuner:v4l2_i2c_drv_probe_legacy+0x3f/0x48
>  [   13.711284]  [<ffffffffa013541b>] :i2c_core:i2c_register_driver+0xa4/0xef
>  [   13.711292]  [<ffffffffa02d47c0>] :tuner:i2c_add_driver+0x13/0x15
>  [   13.711296]  [<ffffffffa01a9083>] :tuner:v4l2_i2c_drv_init+0x83/0xf2
>  [   13.711300]  [<ffffffff80256170>] sys_init_module+0x18be/0x19f4
>  [   13.711341]  [<ffffffffa0134d6d>] ? :i2c_core:i2c_master_send+0x0/0x48
>  [   13.711351]  [<ffffffff80290142>] ? vfs_read+0xa8/0x102
>  [   13.711368]  [<ffffffff8020c18b>] system_call_after_swapgs+0x7b/0x80
>  [   13.711386]
>  [   13.711387]
>  [   13.711387] Code: 4c 29 c2 48 39 d0 72 04 48 8d 4a ff fc 4c 89 cf 4c 01 c0 f3 a4 c6 07 00 c9 c3 55 31 c0 48 83 c9 ff fc 49 89 f8 48 89 f7 48 89 e5 <f2> ae 48 85 d2 48 f7 d1 48 8d 41 ff 74 15 48 39 d0 48 89 c1 72
>  [   13.711400] RIP  [<ffffffff80302934>] strlcpy+0x11/0x36
>  [   13.711402]  RSP <ffff8100bcc45b68>
>  [   13.711403] CR2: 0000000000000000
>  [   13.711408] ---[ end trace 482cc92db4db2b64 ]---
>  [   13.729702] saa7133[0]: registered device video0 [v4l2]
>  [   13.729719] saa7133[0]: registered device vbi0
>  [   13.810238] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc000152c873]
>  [   14.766645] DVB: Unable to find symbol tda827x_attach()
>  [   14.775058] saa7133[0]/dvb: no tda827x tuner found at addr: 60
>  [   14.784121] DVB: registering new adapter (saa7133[0])
>  [   14.792324] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
>  [   14.882015] tda1004x: setting up plls for 48MHz sampling clock
>  [   16.886159] tda1004x: found firmware revision 26 -- ok


Hello-

Andrew's patch should have fixed the issue.  His patch was correct, btw...

Acked-by: Michael Krufky <mkrufky@linuxtv.org>

If you do make clean, does this issue persist?

Is your .config posted somewhere in this thread?  (I dont see it)
Please post the LKML link if the .config is already posted.

Regards,

Mike
