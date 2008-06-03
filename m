Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYFCENv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYFCENv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYFCENn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:13:43 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:58264 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750791AbYFCENm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:13:42 -0400
Message-ID: <4844C4D9.8030502@gawab.com>
Date: Mon, 02 Jun 2008 21:13:13 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080522)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [Question] about modules/inline benefits
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been compiling linus' git kernel (recompiling every -rc). I usually 
compile many features/drivers as modules. I was wondering what the 
benefits/drawbacks there are for modules compared to inlining.

What would be the differences between modules and inlining if you know 
the hardware/features needed?

Is it better to not use modules if you're compiling for just one 
computer that you know the hardware/features needed? (I know distros 
have to use modules because they have to work on a wide variety of hardware)

Are there any performance/efficiency/memory benefits for inlining/module?

Are some drivers/features better suited to be compiled as modules?

Do modules slow down the boot process?


I currently have these modules:
i915
acpi_cpufreq
cpufreq_powersave
cpufreq_stats
cpufreq_userspace
cpufreq_conservative
container
sbs
sbshc
ext3
jbd
mbcache
arc4
ecb
crypto_blkcipher
rtc
dcdbas
cryptomgr
crypto_algapi
psmouse
evdev
snd_hda_intel
snd_pcm_oss
snd_mixer_oss
snd_pcm
iwl3945
mac80211
snd_timer
crc32
snd_page_alloc
video
backlight
output
ac
button
battery
intel_agp
reiserfs
sr_mod
cdrom
sg
ata_piix
ehci_hcd
uhci_hcd
usbcore
thermal
processor
fan

If inlining is more efficient/advantageous, then I might compile-in 
everything I can, and use modules for testing new features and such.

Justin Madru
