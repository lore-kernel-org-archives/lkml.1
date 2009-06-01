Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZFANQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZFANQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbZFANQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:16:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbZFANQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:16:51 -0400
Message-ID: <4A23D43B.3030900@online.de>
Date: Mon, 01 Jun 2009 15:14:35 +0200
From: Juergen Keidel <wizant.keidel@online.de>
Reply-To: wizant.keidel@online.de
Organization: WizAnt Software
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: p_gortmaker@yahoo.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org
Subject: RTC-driver kernel 2.6.xxx missing Symbols
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/jdqQvpAozlNDcksPV1mBwjuFFzqeO+DTNKmn
 tGB9sRIm6876on4VJ0zoJs/gFunHFcSXqng5r8Ji9x4+eLxb0q
 WbM8/e6VGOcMD0FrLmC1YTNLflGzkiMyx+U2Kp+ULg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
The actual kernel has a new reworked rtc driving system. before, I think
2.6.5, the driver was rtc (rtc.c in drivers/char from  Paul Gortmaker,
which exported the function rtc_control, rtc_register, rtc_unregister.
These functions are very useful for drivers wich need acces to the rtc.
The new rtc-system (rtc-cmos) is missing these functions.
As I found out, some drivers especially within the sound area are using
the functionality, so they won't load anymore!
(sound/core/rtctimer.c)
Is there a way around with the new system or is it planned to reactivate
these functionality.
Actually, I have to rmove rtc_cmos and load the old rtc, to get my
drivers working.
One of the Systems I'm running:
Linux wizant1 2.6.27.21-0.1-pae #1 SMP 2009-03-31 14:50:44 +0200 i686
i686 i386 GNU/Linux
 
Gnu C                  4.3
Gnu make               3.81
binutils               11.1
2.19
util-linux             scripts/ver_linux: line 23: fdformat: command not
found
mount                  support
module-init-tools      found
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Kbd                    1.14.1
Sh-utils               6.12
udev                   128
Modules Loaded         michael_mic arc4 ecb crypto_blkcipher
ieee80211_crypt_tkip af_packet binfmt_misc snd_pcm_oss snd_mixer_oss
snd_seq snd_seq_device ipv6 cpufreq_conservative cpufreq_userspace
cpufreq_powersave acpi_cpufreq speedstep_lib fuse reiserfs ext2 loop
dm_mod b44 video sdhci_pci ipw2200 output snd_intel8x0 snd_intel8x0m ssb
yenta_socket ohci1394 snd_ac97_codec sdhci rsrc_nonstatic pcmcia
ieee80211 ac97_bus ieee80211_crypt pcmcia_core mii mmc_core ieee1394
battery button iTCO_wdt ac fglrx usbhid intel_agp snd_pcm
iTCO_vendor_support snd_timer hid rtc_cmos snd soundcore agpgart
rtc_core ff_memless i2c_i801 pcspkr rtc_lib snd_page_alloc sr_mod
serio_raw joydev sg cdrom i2c_core sd_mod crc_t10dif ehci_hcd uhci_hcd
usbcore edd ext3 mbcache jbd fan ide_pci_generic piix ide_core
ata_generic ata_piix libata scsi_mod dock thermal processor thermal_sys
hwmon

Thank you
    Jürgen Keidel
