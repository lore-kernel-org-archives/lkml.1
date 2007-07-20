Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbXGTJ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbXGTJ7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 05:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbXGTJ7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 05:59:30 -0400
Received: from mail1.perex.cz ([212.20.107.53]:37646 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbXGTJ72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 05:59:28 -0400
X-Greylist: delayed 1192 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 05:59:28 EDT
Date: Fri, 20 Jul 2007 11:39:33 +0200 (CEST)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103-a.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: Andrew Morton <akpm@osdl.org>, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0707201138001.7678@tm8103-a.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-07-20.patch.gz

The following files will be updated:

 CREDITS                                         |   10 +-
 Documentation/sound/alsa/ALSA-Configuration.txt |   75 ++-
 Documentation/sound/alsa/Audiophile-Usb.txt     |  242 ++++--
 Documentation/sound/alsa/OSS-Emulation.txt      |   15 +
 include/linux/i2c-id.h                          |    7 +-
 include/sound/ak4xxx-adda.h                     |    1 +
 include/sound/cs46xx.h                          |    4 +
 include/sound/cs46xx_dsp_spos.h                 |    2 +
 include/sound/emu10k1.h                         |   16 +
 include/sound/sb.h                              |    1 +
 include/sound/version.h                         |    2 +-
 include/sound/wavefront_fx.h                    |    9 -
 sound/Kconfig                                   |    2 +
 sound/Makefile                                  |    2 +-
 sound/aoa/codecs/snd-aoa-codec-onyx.c           |    4 +-
 sound/core/pcm_native.c                         |    2 +-
 sound/core/seq/seq_instr.c                      |    6 +-
 sound/core/timer.c                              |   27 +-
 sound/drivers/dummy.c                           |    2 +-
 sound/drivers/mpu401/mpu401.c                   |    2 +-
 sound/drivers/portman2x4.c                      |    2 +-
 sound/drivers/serial-u16550.c                   |    2 +-
 sound/drivers/virmidi.c                         |    2 +-
 sound/i2c/other/ak4xxx-adda.c                   |   24 +-
 sound/isa/Kconfig                               |   32 +-
 sound/isa/ad1848/ad1848_lib.c                   |    4 +-
 sound/isa/opl3sa2.c                             |    2 +
 sound/isa/opti9xx/opti92x-ad1848.c              |    3 +
 sound/isa/sb/Makefile                           |   15 +-
 sound/isa/sb/sb16_main.c                        |   10 +
 sound/isa/sb/sb_common.c                        |    5 +-
 sound/isa/sb/sb_mixer.c                         |    3 +
 sound/isa/sscape.c                              |    4 +-
 sound/isa/wavefront/wavefront_synth.c           |    2 +-
 sound/pci/Kconfig                               |   11 +
 sound/pci/Makefile                              |    2 +
 sound/pci/ali5451/ali5451.c                     |    7 +-
 sound/pci/als300.c                              |    7 +-
 sound/pci/ca0106/ca0106_main.c                  |   19 +
 sound/pci/cs46xx/cs46xx_lib.c                   |   77 ++-
 sound/pci/cs46xx/cs46xx_lib.h                   |    3 +
 sound/pci/cs46xx/dsp_spos.c                     |  170 +++-
 sound/pci/cs5530.c                              |  306 ++++++
 sound/pci/emu10k1/emu10k1_main.c                |  125 +++-
 sound/pci/emu10k1/emufx.c                       |   78 ++-
 sound/pci/emu10k1/emumixer.c                    |   16 +
 sound/pci/emu10k1/emupcm.c                      |   39 +-
 sound/pci/ens1370.c                             |    4 +-
 sound/pci/hda/hda_intel.c                       |   53 +-
 sound/pci/hda/hda_proc.c                        |    6 +
 sound/pci/hda/patch_analog.c                    |  630 +++++++++++++-
 sound/pci/hda/patch_atihdmi.c                   |    1 +
 sound/pci/hda/patch_conexant.c                  |    2 +
 sound/pci/hda/patch_realtek.c                   |  919 ++++++++++++++++++-
 sound/pci/hda/patch_si3054.c                    |    4 +
 sound/pci/hda/patch_sigmatel.c                  |  266 ++++--
 sound/pci/ice1712/revo.c                        |    7 +-
 sound/pci/nm256/nm256.c                         |    3 +-
 sound/pci/rme9652/rme9652.c                     |    2 +-
 sound/pci/via82xx.c                             |    4 +-
 sound/pci/via82xx_modem.c                       |    4 +-
 sound/ppc/Kconfig                               |   20 +
 sound/ppc/Makefile                              |    3 +-
 sound/ppc/snd_ps3.c                             | 1125 +++++++++++++++++++++++
 sound/ppc/snd_ps3.h                             |  135 +++
 sound/ppc/snd_ps3_reg.h                         |  891 ++++++++++++++++++
 sound/sh/Kconfig                                |   14 +
 sound/sh/Makefile                               |    8 +
 sound/sh/aica.c                                 |  665 +++++++++++++
 sound/sh/aica.h                                 |   81 ++
 sound/soc/Kconfig                               |    1 +
 sound/soc/Makefile                              |    2 +-
 sound/soc/s3c24xx/Kconfig                       |   27 +
 sound/soc/s3c24xx/Makefile                      |    9 +
 sound/soc/s3c24xx/lm4857.h                      |   32 +
 sound/soc/s3c24xx/neo1973_wm8753.c              |  670 ++++++++++++++
 sound/soc/s3c24xx/s3c2443-ac97.c                |  401 ++++++++
 sound/soc/s3c24xx/s3c24xx-ac97.h                |   25 +
 sound/soc/s3c24xx/s3c24xx-i2s.c                 |    4 +-
 sound/soc/s3c24xx/smdk2443_wm9710.c             |   85 ++
 sound/soc/sh/Kconfig                            |   38 +
 sound/soc/sh/Makefile                           |   14 +
 sound/soc/sh/dma-sh7760.c                       |  354 +++++++
 sound/soc/sh/hac.c                              |  322 +++++++
 sound/soc/sh/sh7760-ac97.c                      |   92 ++
 sound/soc/sh/ssi.c                              |  400 ++++++++
 sound/usb/usbaudio.c                            |   22 +-
 sound/usb/usbquirks.h                           |   72 ++-
 sound/usb/usx2y/usbusx2yaudio.c                 |    7 +-
 89 files changed, 8426 insertions(+), 399 deletions(-)


The following things were done:

Adrian Bunk (2):
      [ALSA] sound/pci/hda/patch_realtek.c: remove dead code
      [ALSA] fix SND_CS5530=y, ISA=n compilation

Adrian McMenamin (1):
      [ALSA] Add ALSA support for the SEGA Dreamcast PCM device

Alan Horstmann (1):
      [ALSA] More description on duplex streams with OSS emulation

Andrew Morton (1):
      [ALSA] ali5451 warning fix

Ash Willis (1):
      [ALSA] Disable debugging output for the ALS300 driver

Carlo Beccaria (1):
      [ALSA] usb-audio: add Roland SH-201 support

Claudio Matsuoka (14):
      [ALSA] usb-audio - Add quirk for Roland Juno-G
      [ALSA] hda-codec - Add support for HP Spartan
      [ALSA] hda-codec - Add support for HP Nettle
      [ALSA] hda-codec - Fix 5.1 output in LG LW20
      [ALSA] hda-codec - Fix HP Nettle 5.1 output
      [ALSA] hda-codec - Add HP Lucknow 5.1 support
      [ALSA] Update Claudio's CREDITS information
      [ALSA] hda-codec - Add VIA HDA to si3054
      [ALSA] hda-codec - Add LG LW20 si3054 modem id
      [ALSA] hda-codec - Add LG LW20 line-in capture source
      [ALSA] hda-codec - Add quirk for HP Samba
      [ALSA] hda-codec - Rename HP model-specific quirks
      [ALSA] hda-codec - Add quirks for HP dx2200/dx2250
      [ALSA] hda-codec - Add quirk for Asus P5LD2

Clemens Ladisch (1):
      [ALSA] timer: check for incorrect device state in non-debug compiles, too

Daniel Drake (1):
      [ALSA] usb-audio: another Logitech QuickCam ID

Daniel T Chen (1):
      [ALSA] hda-codec - Add quirk for another MSI laptop to alc883_cfg_tbl[]

Dave Jones (1):
      [ALSA] Yet another Uniwill laptop with ALC861 codec

George Shapovalov (1):
      [ALSA] usb-audio: another Logitech camera/microphone ID match

Graeme Gregory (5):
      [ALSA] ASoC S3C24xx machine drivers - s3c2443-AC97
      [ALSA] ASoC S3C24xx machine drivers - Openmoko Neo1973
      [ALSA] ASoC S3C24xx machine drivers - SMDK 2443
      [ALSA] ASoC S3C24xx machine drivers - Kconfig
      [ALSA] ASoC S3C24xx machine drivers - lm4857-h missing patch

Ivan N. Zlatev (1):
      [ALSA] hda-codec - Fix pin configs for Intel Macs

James Courtier-Dutton (3):
      [ALSA] snd-emu10k1: Initial support for E-Mu 1616 and 1616m.
      [ALSA] snd-emu10k1:Enable E-Mu 1616m notebook firmware loading.
      [ALSA] snd-ca0106: Add support for X-Fi Extreme Audio.

Jaroslav Kysela (1):
      [ALSA] version 1.0.14

Jaroslav Kysela perex@suse.cz (1):
      [ALSA] remove duplicate Logitech Quickcam USB ID in usbquirks.h

Jonathan Phenix (1):
      [ALSA] hda-codec - Output MFG information for HDA devices

Kailang Yang (4):
      [ALSA] hda-codec - Add proper model for HP xw series
      [ALSA] hda-codec - Add support of ALC268 codec
      [ALSA] hda-codec - Some fixes for Realtek codec supports
      [ALSA] hda-codec - Fix ALC662 auto mode

Liam Girdwood (1):
      [ALSA] ASoC S3C24xx machine drivers - I2C ID for LM4857

Manuel Lauss (2):
      [ALSA] SH7760 ASoC support
      [ALSA] soc/sh: let SND_SOC_PCM_SH7760 depend on SH_DMABRG

Masakazu Mokuno (1):
      [ALSA] Add PS3 sound driver

Matt Reimer (1):
      [ALSA] Make s3c24xx_i2s_set_clkdiv() change the correct bits

Matthew Ranostay (3):
      [ALSA] hda: add eapd support to additional idt codecs
      [ALSA] hda: stac9202 mixer fix
      [ALSA] hda: Enable SPDIF in/out on some stac9205 boards

Mike Crash (1):
      [ALSA] hda: support for S/PDIF out on ASUS M2V

Nicola Fagnani (1):
      [ALSA] hda-intel: support for iMac 24'' released on 09/2006

Paul Vojta (2):
      [ALSA] opl3sa2 - Add Neomagic MagicWave 3D ISA PnP ID
      [ALSA] nm256 - Add mention of opl3sa2 to a diagnostic message

Pavel Hofman (2):
      [ALSA] ice1724 - Add PCM Playback Switch to Revo 7.1
      [ALSA] emu10k1 - EMU 1212 with 16 capture channels

Peer Chen (1):
      [ALSA] Add the MCP73/77 support to hda_intel driver

Randy Dunlap (4):
      [ALSA] fix section mismatch
      [ALSA] more section mismatches
      [ALSA] fix ensoniq section mismatch
      [ALSA] portman2x4 section mismatch

Richard Knutsson (1):
      [ALSA] usbusx2yaudio: kfree(NULL) is valid

Ritesh Raj Sarraf (1):
      [ALSA] USB ID for intergrated quickcam on dell xps m1210

Robert P. J. Day (1):
      [ALSA] Remove unreferenced header file include/sound/wavefront_fx.h

Takashi Iwai (31):
      [ALSA] Fix unfreed pnp driver in opti9xx ISA driver
      [ALSA] hda-codec - Add AD1884 / AD1984 codec support
      [ALSA] Add description about probe_mask option for snd-hda-intel
      [ALSA] hda-codec - Add support of newer version of Intel iMac
      [ALSA] hda-codec - Fix wrong mixer controls for AD1984 thinkpad model
      [ALSA] Add support for Cyrix/NatSemi Geode CS5530 (VSA1)
      [ALSA] Fix SB-module dependency with PCI drivers
      [ALSA] hda-codec - Fix STAC922x capture boost level
      [ALSA] ali5451 - Fix invalid type of codec->irq field
      [ALSA] rme9652 - Fix the hw_pointer check
      [ALSA] hda-codec - Fix Oops with AD1984 thinkpad model
      [ALSA] hda-codec - Fix AD1984 basic model
      [ALSA] hda-codec - Fix Thinkpad X61/T61 outputs
      [ALSA] hda-codec - Add model for Toshiba A135
      [ALSA] hda-codec - Fix ALC662 auto-configuration code
      [ALSA] hda-codec - Add model dell for Dell XPS M1210
      [ALSA] hda-codec - Add AD1882 codec support
      [ALSA] Fix invalid schedule_timeout_interruptible()
      [ALSA] hda-codec - Fix the error in DAC assignment of STAC codec
      [ALSA] hda-codec - Fix the recording selection on VAIO laptop
      [ALSA] hda-codec - Add missing model parameter strings for ALC262
      [ALSA] Add missing model entries for HD-audio codecs
      [ALSA] Fix substream to check in PCM drain
      [ALSA] hda-codec - Fix number of pin widgets with STAC codecs
      [ALSA] hda-intel - Show the last command in warning messages
      [ALSA] aica - fix behaviour in poor resource conditions
      [ALSA] usbaudio - Add quirk for Roland EXR series
      [ALSA] hda-codec - Fix Toshiba A100 with ALC861
      [ALSA] hda-codec - Fix default pin config of Abit AW9D-MAX
      [ALSA] cs46xx - Fix PM resume
      [ALSA] hda-codec - Fix input with STAC92xx

Thibault Le Meur (2):
      [ALSA] usb-audio - Fix audiophile-USB quirk for little-endian
      [ALSA] usb-audio - Fix AC3 with M-Audio Audiophile USB

Tobin Davis (4):
      [ALSA] hda-codec - Add HP Pavillion quirk to Realtek code
      [ALSA] hda-codec - Add Fujitsu Siemens v3515 support to patch_conexant
      [ALSA] HDA - Change default configuration for Fujitsu Si3515
      [ALSA] HDA-Intel - Add support for MSI K9AGM2-FIH motherboard

Yoann Padioleau (1):
      [ALSA] snd-aoa-codec-onyx: fix typo

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
