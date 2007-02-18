Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbXBRWfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbXBRWfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 17:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXBRWfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 17:35:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59502 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbXBRWfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 17:35:23 -0500
Date: Sun, 18 Feb 2007 14:35:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-mm2 -- EIP is at __make_request+0xeb/0x2ee
Message-Id: <20070218143517.238d7a0e.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0702181347l4551aaefxf083e5260ea274ce@mail.gmail.com>
References: <a44ae5cd0702181347l4551aaefxf083e5260ea274ce@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 13:47:44 -0800 "Miles Lane" <miles.lane@gmail.com> wrote:

> It looks like there are some slight differences between the stack traces I
> have and the ones that have already been posted.
> I hope this helps,
>           Miles
> 
> psmouse.c: TouchPad at isa0060/serio1/input0 lost synchronization, throwing
> 1 bytes away.
> BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
>  printing eip:
> c01f238c
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP
> last sysfs file: /devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> Modules linked in: ieee80211_crypt_wep binfmt_misc rfcomm l2cap bluetooth
> ipv6 capability commoncap apm i915 drm acpi_cpufreq cpufreq_powersave
> cpufreq_performance cpufreq_conservative video dock container button battery
> ac nls_ascii nls_cp437 vfat fat nls_base fuse sbp2 parport_pc lp parport
> pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss
> snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq snd_timer snd_seq_device sdhci mmc_core tifm_7xx1
> tifm_core yenta_socket rsrc_nonstatic pcmcia_core snd soundcore ipw2200
> ieee80211 ieee80211_crypt firmware_class rtc snd_page_alloc iTCO_wdt
> iTCO_vendor_support shpchp pci_hotplug sg sr_mod cdrom sd_mod ohci1394
> ieee1394 8139too mii ehci_hcd uhci_hcd usbcore thermal processor fan unix
> CPU:    0
> EIP:    0060:[<c01f238c>]    Not tainted VLI
> EFLAGS: 00210297   (2.6.20-mm2 #13)
> EIP is at __make_request+0xeb/0x2ee

Looks fairly similar.  I guess I need to do a git-blockless -mm3 :(
