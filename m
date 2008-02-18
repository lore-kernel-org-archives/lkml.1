Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYBRTJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYBRTJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYBRTJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:09:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:33181 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751050AbYBRTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:09:25 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/LaapnXn/LweVXCHFi3Ju+6wB0Out8eDdaXyUA0f
	4sr1U3JIZjW+qZ
Date: Mon, 18 Feb 2008 20:09:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Jaroslav Kysela <perex@perex.cz>
Subject: [ALSA] 2.6.25-rc2 compilation broken
Message-ID: <Pine.LNX.4.64.0802182003380.11540@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has this already been fixed:

  CC [M]  sound/drivers/opl3/opl3_synth.o
sound/drivers/opl3/opl3_synth.c: In function snd_opl3_find_patch:
sound/drivers/opl3/opl3_synth.c:308: error: OPL3_PATCH_HASH_SIZE undeclared (first use in this function)
sound/drivers/opl3/opl3_synth.c:308: error: (Each undeclared identifier is reported only once
sound/drivers/opl3/opl3_synth.c:308: error: for each function it appears in.)
sound/drivers/opl3/opl3_synth.c:311: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:323: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:324: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c: In function snd_opl3_clear_patches:
sound/drivers/opl3/opl3_synth.c:335: error: OPL3_PATCH_HASH_SIZE undeclared (first use in this function)
sound/drivers/opl3/opl3_synth.c:337: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
sound/drivers/opl3/opl3_synth.c:342: error: struct snd_opl3 has no member named patch_table
make[3]: *** [sound/drivers/opl3/opl3_synth.o] Error 1

To reproduce just disable audio sequencer support:

-# CONFIG_SND_SEQUENCER is not set
+CONFIG_SND_SEQUENCER=m

Below is the problematic sound configuration.

Thanks
Guennadi
---
Guennadi Liakhovetski

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=m
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set
