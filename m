Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbXECNXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbXECNXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXECNXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:23:55 -0400
Received: from mail1.perex.cz ([212.20.107.53]:35231 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbXECNXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:23:52 -0400
X-Greylist: delayed 1923 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 09:23:52 EDT
Date: Thu, 3 May 2007 14:51:46 +0200 (CEST)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0705031448320.8516@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-05-03.patch.gz

The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt |   19 +-
 Documentation/sound/alsa/Bt87x.txt              |    4 +-
 MAINTAINERS                                     |    6 +-
 include/linux/i2c-id.h                          |    1 +
 include/sound/ak4114.h                          |    4 +-
 include/sound/mpu401.h                          |    1 +
 include/sound/pcm.h                             |    7 +-
 include/sound/version.h                         |    4 +-
 sound/aoa/codecs/snd-aoa-codec-onyx.c           |    4 +-
 sound/aoa/codecs/snd-aoa-codec-tas.c            |    4 +-
 sound/aoa/soundbus/core.c                       |    2 -
 sound/aoa/soundbus/i2sbus/i2sbus-core.c         |    5 +-
 sound/aoa/soundbus/soundbus.h                   |    2 +
 sound/core/pcm_native.c                         |   30 +-
 sound/core/rtctimer.c                           |    3 +-
 sound/drivers/mpu401/mpu401.c                   |   12 +-
 sound/drivers/mpu401/mpu401_uart.c              |   18 +-
 sound/drivers/mts64.c                           |    4 +-
 sound/drivers/portman2x4.c                      |    4 +-
 sound/i2c/other/ak4114.c                        |  114 +-
 sound/isa/Kconfig                               |   18 +
 sound/isa/ad1816a/ad1816a.c                     |    8 +-
 sound/isa/ad1848/ad1848.c                       |  167 +--
 sound/isa/adlib.c                               |  122 +-
 sound/isa/cmi8330.c                             |  115 +-
 sound/isa/cs423x/cs4231.c                       |  213 +--
 sound/isa/cs423x/cs4231_lib.c                   |    4 +-
 sound/isa/cs423x/cs4236.c                       |  131 +-
 sound/isa/es1688/es1688.c                       |  251 ++--
 sound/isa/es18xx.c                              |  110 +-
 sound/isa/gus/gusclassic.c                      |  292 ++--
 sound/isa/gus/gusextreme.c                      |  379 ++---
 sound/isa/gus/gusmax.c                          |   71 +-
 sound/isa/gus/interwave.c                       |  101 +-
 sound/isa/opl3sa2.c                             |  127 +-
 sound/isa/opti9xx/miro.c                        |   80 +-
 sound/isa/opti9xx/opti92x-ad1848.c              |  108 +-
 sound/isa/sb/sb16.c                             |  113 +-
 sound/isa/sb/sb16_csp.c                         |   23 +-
 sound/isa/sb/sb8.c                              |   90 +-
 sound/isa/sgalaxy.c                             |  107 +-
 sound/isa/sscape.c                              |  120 +-
 sound/isa/wavefront/wavefront.c                 |  111 +-
 sound/isa/wavefront/wavefront_fx.c              |   19 +-
 sound/pci/Kconfig                               |   27 +
 sound/pci/ac97/Makefile                         |    2 +-
 sound/pci/ac97/ac97_codec.c                     |   43 +-
 sound/pci/ac97/ac97_local.h                     |   55 +-
 sound/pci/ac97/ac97_patch.c                     |  194 ++-
 sound/pci/ac97/ac97_patch.h                     |  110 +-
 sound/pci/ac97/ac97_pcm.c                       |    1 -
 sound/pci/ali5451/ali5451.c                     |  869 +++++-----
 sound/pci/au88x0/au88x0_sb.h                    |   40 -
 sound/pci/azt3328.c                             |   34 +-
 sound/pci/azt3328.h                             |    4 +-
 sound/pci/bt87x.c                               |    4 +-
 sound/pci/ca0106/ca0106_main.c                  |    4 +-
 sound/pci/cs46xx/cs46xx_lib.c                   |    2 +-
 sound/pci/cs46xx/imgs/cwcemb80.h                | 1607 ------------------
 sound/pci/echoaudio/echoaudio.c                 |    4 +-
 sound/pci/echoaudio/echoaudio_3g.c              |    4 +-
 sound/pci/emu10k1/emu10k1_main.c                |    9 +
 sound/pci/emu10k1/p16v.c                        |    4 +-
 sound/pci/ens1370.c                             |    8 +-
 sound/pci/es1968.c                              |   11 +-
 sound/pci/hda/Makefile                          |    9 +-
 sound/pci/hda/hda_codec.c                       |  629 ++++---
 sound/pci/hda/hda_intel.c                       |   31 +-
 sound/pci/hda/hda_local.h                       |   12 +
 sound/pci/hda/patch_analog.c                    |   54 +-
 sound/pci/hda/patch_atihdmi.c                   |   17 +-
 sound/pci/hda/patch_cmedia.c                    |   14 +-
 sound/pci/hda/patch_conexant.c                  |  307 ++---
 sound/pci/hda/patch_realtek.c                   | 2076 +++++++++++++++++++----
 sound/pci/hda/patch_sigmatel.c                  |   56 +-
 sound/pci/hda/patch_via.c                       |   14 +-
 sound/pci/ice1712/amp.c                         |    2 +-
 sound/pci/ice1712/amp.h                         |    2 +-
 sound/pci/ice1712/aureon.c                      |   18 +-
 sound/pci/ice1712/aureon.h                      |    2 +-
 sound/pci/ice1712/delta.c                       |   34 +-
 sound/pci/ice1712/delta.h                       |    2 +-
 sound/pci/ice1712/ews.c                         |   24 +-
 sound/pci/ice1712/ews.h                         |    2 +-
 sound/pci/ice1712/hoontech.c                    |    6 +-
 sound/pci/ice1712/hoontech.h                    |    2 +-
 sound/pci/ice1712/ice1712.c                     |   50 +-
 sound/pci/ice1712/ice1712.h                     |    3 +
 sound/pci/ice1712/ice1724.c                     |   47 +-
 sound/pci/ice1712/juli.c                        |   24 +-
 sound/pci/ice1712/juli.h                        |    2 +-
 sound/pci/ice1712/phase.c                       |   14 +-
 sound/pci/ice1712/phase.h                       |    2 +-
 sound/pci/ice1712/pontis.c                      |    6 +-
 sound/pci/ice1712/pontis.h                      |    2 +-
 sound/pci/ice1712/prodigy192.c                  |  360 ++++-
 sound/pci/ice1712/prodigy192.h                  |   10 +-
 sound/pci/ice1712/revo.c                        |   26 +-
 sound/pci/ice1712/revo.h                        |    2 +-
 sound/pci/ice1712/vt1720_mobo.c                 |    6 +-
 sound/pci/ice1712/vt1720_mobo.h                 |    2 +-
 sound/pci/ice1712/wtm.c                         |    2 +-
 sound/pci/intel8x0.c                            |   20 +-
 sound/pci/korg1212/korg1212.c                   |   22 +-
 sound/pci/maestro3.c                            |   34 +-
 sound/pci/pcxhr/pcxhr.c                         |   28 +-
 sound/pci/rme32.c                               |    7 +-
 sound/pci/rme9652/hdsp.c                        |   93 +-
 sound/pci/rme9652/hdspm.c                       |  185 ++-
 sound/pci/rme9652/rme9652.c                     |    8 +-
 sound/pci/trident/trident_main.c                |    4 +-
 sound/pci/ymfpci/ymfpci_main.c                  |   50 +-
 sound/soc/Kconfig                               |   18 +-
 sound/soc/Makefile                              |    2 +-
 sound/soc/at91/Kconfig                          |   10 +-
 sound/soc/at91/Makefile                         |    4 +-
 sound/soc/at91/{at91-i2s.c => at91-ssc.c}       |  259 ++-
 sound/soc/at91/{at91-i2s.h => at91-ssc.h}       |   14 +-
 sound/soc/at91/eti_b1_wm8731.c                  |    8 +-
 sound/soc/codecs/Kconfig                        |    4 +
 sound/soc/codecs/Makefile                       |    2 +
 sound/soc/codecs/ac97.c                         |    1 +
 sound/soc/codecs/ac97.h                         |    1 +
 sound/soc/codecs/wm8753.c                       | 1811 ++++++++++++++++++++
 sound/soc/codecs/wm8753.h                       |  126 ++
 sound/soc/codecs/wm9712.c                       |    7 +-
 sound/soc/pxa/Kconfig                           |    4 -
 sound/soc/s3c24xx/Kconfig                       |   10 +
 sound/soc/s3c24xx/Makefile                      |    6 +
 sound/soc/s3c24xx/s3c24xx-i2s.c                 |  441 +++++
 sound/soc/s3c24xx/s3c24xx-i2s.h                 |   37 +
 sound/soc/s3c24xx/s3c24xx-pcm.c                 |  468 +++++
 sound/soc/s3c24xx/s3c24xx-pcm.h                 |   31 +
 sound/soc/soc-dapm.c                            |    6 +-
 sound/sparc/cs4231.c                            |    4 +-
 sound/usb/Kconfig                               |   28 +
 sound/usb/Makefile                              |    2 +-
 sound/usb/caiaq/Makefile                        |    3 +
 sound/usb/caiaq/caiaq-audio.c                   |  707 ++++++++
 sound/usb/caiaq/caiaq-audio.h                   |    7 +
 sound/usb/caiaq/caiaq-device.c                  |  436 +++++
 sound/usb/caiaq/caiaq-device.h                  |  116 ++
 sound/usb/caiaq/caiaq-input.c                   |  246 +++
 sound/usb/caiaq/caiaq-input.h                   |    8 +
 sound/usb/caiaq/caiaq-midi.c                    |  177 ++
 sound/usb/caiaq/caiaq-midi.h                    |    8 +
 146 files changed, 10074 insertions(+), 5424 deletions(-)
 rename sound/soc/at91/{at91-i2s.c => at91-ssc.c} (73%)
 rename sound/soc/at91/{at91-i2s.h => at91-ssc.h} (72%)

The following things were done:

Abhijit Bhopatkar (1):
      [ALSA] hda-codec - Add first generation macbook subsystem ID

Akinobu Mita (1):
      [ALSA] sound: fix incorrect use of platform_device_register()

Andrea Arcangeli (1):
      [ALSA] hda-codec - Fix front/rear mic inputs on AD1986A codec

Andreas Mohr (1):
      [ALSA] azt3328.c: small cleanup patch

Ben Dooks (2):
      [ALSA] ASoC Samsung S3C24xx I2S support
      [ALSA] ASoC Samsung S3C24xx audio DMA

Clemens Ladisch (2):
      [ALSA] Kconfig: fix FW_LOADER dependencies
      [ALSA] Kconfig: clarify help text for external firmware entries

Daniel Mack (1):
      [ALSA] Add Native Instrument usb audio device support

David Brownell (1):
      [ALSA] fix SND_SOC Kconfig

Frank Mandarino (3):
      [ALSA] ASoC AT91xxxx - SSC port DSP support
      [ALSA] ASoC AT91xxxx eti B1 machine SSC changes
      [ALSA] ASoC AT91xxxx build fix

Frederik Deweerdt (1):
      [ALSA] pcm_native: lockdep warning when launching jack

Giuliano Pochini (1):
      [ALSA] echoaudio - increase sleep time at loading firmware

Graeme Gregory (5):
      [ALSA] ASoC Samsung S3C24xx build
      [ALSA] ASoC WM9712 kmemdup
      [ALSA] ASoC export AC97 DAI
      [ALSA] ASoC Samsung S3c24xx updates - audio DMA cleanup
      [ALSA] ASoC Samsung S3C24xx updates - i2s

James Courtier-Dutton (1):
      [ALSA] snd-emu10k1: Prevent E-Mu 1010 Notebook card from hanging PC.

Jaroslav Kysela (1):
      [ALSA] version 1.0.14rc4

Jean Delvare (1):
      [ALSA] sound: strlcpy is smart enough

Johannes Berg (2):
      [ALSA] aoa: fix a sparse warning
      [ALSA] snd-aoa-i2sbus: use MODULE_DEVICE_TABLE instead of plain MODULE_ALIAS

John Utz (1):
      [ALSA] ac97 - Smart 5.1 for VIA 1617a codec

Julian Cable (1):
      [ALSA] hdsp - Add support for fine tuning of sample rate support to HDSP 9632

Kailang Yang (1):
      [ALSA] hda-codec - Add ALC662 support

Karsten Wiese (1):
      [ALSA] snd-usb-caiaq: Make playback work

Liam Girdwood (3):
      [ALSA] SoC WM8753 codec support
      [ALSA] ASoC WM8753 codec - build changes
      [ALSA] ASoC Kconfig description

Milind Arun Choudhary (1):
      [ALSA] sound: SPIN_LOCK_UNLOCKED cleanup

Pavel Hofman (3):
      [ALSA] Fix misc bugs in i2c/others/ak4114.c
      [ALSA] ice1724 - Functioning support for Prodigy 192
      [ALSA] ice1724 - Misc fixes for Prodigy192

Ralf Baechle (2):
      [ALSA] hda_intel: build fix
      [ALSA] ice1712: build fixes

Rask Ingemann Lambertsen (1):
      [ALSA] ad1816a: Fix modprobe snd_mpu401 && modprobe snd_ad1816a

Remy Bruno (1):
      [ALSA] hdspm - Support for Master mode of AES32 and recent MADI

Rene Herman (11):
      [ALSA] isa_bus: ad1848
      [ALSA] isa_bus: adlib
      [ALSA] isa_bus: cs4231
      [ALSA] isa_bus: es1688
      [ALSA] es1688 - code clean-up
      [ALSA] isa_bus: gusclassic
      [ALSA] isa_bus: gusextreeme
      [ALSA] gusextreme: set codec_flag
      [ALSA] isa_bus device/driver naming
      [ALSA] Fix alsa-devel ML address
      [ALSA] es1968 - Fix stuttering capture

Robert P. J. Day (2):
      [ALSA] remove unused header file: sound/pci/cs46xx/imgs/cwcemb80.h
      [ALSA] Delete unused header file sound/pci/au88x0/au88x0_sb.h

Seth Forshee (1):
      [ALSA] ASoC DAPM switching for reentrant codec paths

Sylvain FORET (1):
      [ALSA] snd_hda_intel: fix for intel imac

Takashi Iwai (41):
      [ALSA] hda-codec - Fix models for some lpatops/mobos
      [ALSA] Port the rest of ALSA ISA drivers to isa_driver
      [ALSA] Add snd_pcm_group_for_each_entry() for code cleanup
      [ALSA] ac97 - Make patch functions static
      [ALSA] bt87x - Add ATI TV-Wonder to the supported list
      [ALSA] mpu401 - Add MPU401_INFO_UART_ONLY bitflag
      [ALSA] Enable Kconfig options for external firmwares
      [ALSA] hda-codec - Allow model=generic always for generic parser
      [ALSA] Fix NULL dereference with null modelname
      [ALSA] Fix compilation error in sparc/cs4231.c
      [ALSA] soc - Fix dependencies in s3c24xx/Kconfig
      [ALSA] ac97 - Fix MSI L720 laptop
      [ALSA] hda-codec - Code clean up of patch_sigmatel.c
      [ALSA] Fix conflicts between const and __devinitdata
      [ALSA] hda-codec - Fix Macmini and Macbook pin configs
      [ALSA] hda-intel - Probe additional slots only if necessary
      [ALSA] ak4114 - Fix a typo in DIF2 bit definition
      [ALSA] hda-codec - Fix missing array terminators
      [ALSA] pcxhr - Minor optimization in trigger callback
      [ALSA] ice1724 - Fix AP192 4wire mode access
      [ALSA] ak4114 - Fix possible Oops with callbacks
      [ALSA] ali5451 - Code clean up, irq handler fix
      [ALSA] hda-codec - Fix SPDIF output
      [ALSA] ice1724 - call snd_ak4114_build() in juli
      [ALSA] ice1724 - Add comments for naming of PCM streams
      [ALSA] hda-codec - Add support of 96kHz back
      [ALSA] hda-codec - clean up patch_realtek.c
      [ALSA] hda-codec - Allow opening SPDIF while analog dup mode
      [ALSA] hda-intel - Merge hda-codec module to a single module
      [ALSA] hda-codec - Code clean up
      [ALSA] Fix alsa-devel ML address
      [ALSA] hda-codec - Fix surround output on AD1986A
      [ALSA] intel8x0 - Fix Oops in crash kernel
      [ALSA] hda-codec - Fix 8-channel auto-configuration
      [ALSA] hda-codec - Add line_out_type to auto_pin_cfg struct
      [ALSA] hda-codec - Fix output pin types in auto configuration
      [ALSA] hda-intel - Fix detection of audio codec on Toshiba A100
      [ALSA] hda-codec - Fix model for ASUS A9rp
      [ALSA] Don't use request_firmware if internal firmwares are defined
      [ALSA] hda-codec - Prefer audio codec name as the mixer name
      [ALSA] Add description of imac-intel model

Tobin Davis (5):
      [ALSA] hda-codec - Add Sony VGC-LA1 to patch_sigmatel.c
      [ALSA] hda-codec - Conexant improvements
      [ALSA] hda-codec - Add support for Gigabyte S-Series GA-M57SLI-S4 motherboard
      [ALSA] hda-codec - Add support for Asus A8JN Laptop
      [ALSA] HDA-Intel: Fix headphone squeal on Conexant audio

Wolke Liu (1):
      [ALSA] hda-intel - Add ATI RS780,R600 HDMI audio support

vignesh babu (1):
      [ALSA] is_power_of_2 in rtctimer.c

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
