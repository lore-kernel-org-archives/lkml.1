Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbYGNJJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbYGNJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYGNJJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:09:20 -0400
Received: from mail1.perex.cz ([212.20.107.53]:1310 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbYGNJJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:09:18 -0400
Date: Mon, 14 Jul 2008 11:09:08 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103-a.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       ALSA development <alsa-devel@alsa-project.org>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463789724-93151169-1216026548=:7676"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463789724-93151169-1216026548=:7676
Content-Type: TEXT/PLAIN; charset=iso8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE


Linus, please pull from:

  git pull git://git.alsa-project.org/alsa-kernel.git for-linus

gitweb interface:

  http://git.alsa-project.org/?p=3Dalsa-kernel.git;a=3Dshortlog;h=3Dfor-lin=
us

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-for-linus-2008-07-=
14.patch.gz
 =20
The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt    |   17 +-
 .../sound/alsa/DocBook/writing-an-alsa-driver.tmpl |    4 +-
 include/asm-mips/mach-au1x00/au1xxx_psc.h          |    8 +
 include/sound/ad1843.h                             |   46 +
 include/sound/control.h                            |    3 -
 include/sound/core.h                               |    8 +-
 include/sound/cs4231-regs.h                        |    8 +
 include/sound/cs4231.h                             |    3 +
 include/sound/emu10k1.h                            |    1 +
 include/sound/seq_kernel.h                         |    2 +-
 include/sound/soc-dapm.h                           |   42 +-
 include/sound/soc.h                                |  175 ++-
 include/sound/uda1341.h                            |    2 -
 include/sound/version.h                            |    4 +-
 sound/Kconfig                                      |   34 +-
 sound/aoa/Kconfig                                  |   11 +-
 sound/aoa/codecs/Kconfig                           |    4 -
 sound/aoa/fabrics/Kconfig                          |    1 -
 sound/aoa/soundbus/Kconfig                         |    1 -
 sound/arm/Kconfig                                  |   21 +-
 sound/arm/sa11xx-uda1341.c                         |    2 -
 sound/core/Kconfig                                 |   29 +-
 sound/core/control.c                               |    7 +-
 sound/core/init.c                                  |   67 +-
 sound/core/memalloc.c                              |   62 -
 sound/core/seq/seq_clientmgr.c                     |    2 +-
 sound/core/seq/seq_device.c                        |    6 +-
 sound/core/sound.c                                 |    8 +-
 sound/core/timer.c                                 |    6 +-
 sound/drivers/Kconfig                              |   91 +-
 sound/drivers/vx/vx_hwdep.c                        |    2 +-
 sound/i2c/cs8427.c                                 |    6 +-
 sound/i2c/l3/uda1341.c                             |    2 -
 sound/isa/Kconfig                                  |   61 +-
 sound/isa/cs423x/cs4231_lib.c                      |  118 ++-
 sound/isa/opti9xx/opti92x-ad1848.c                 | 1126 +-------------
 sound/isa/sb/Makefile                              |    2 -
 sound/isa/wavefront/wavefront_synth.c              |    2 +-
 sound/mips/Kconfig                                 |   27 +-
 sound/mips/Makefile                                |    4 +
 sound/mips/ad1843.c                                |  561 +++++++
 sound/mips/hal2.c                                  |  947 ++++++++++++
 sound/mips/hal2.h                                  |  245 +++
 sound/mips/sgio2audio.c                            | 1006 ++++++++++++
 sound/oss/Kconfig                                  |   49 +-
 sound/oss/dmasound/dmasound_core.c                 |    7 +-
 sound/oss/dmasound/dmasound_paula.c                |    2 +-
 sound/oss/dmasound/dmasound_q40.c                  |    2 +-
 sound/oss/msnd.c                                   |    2 -
 sound/oss/msnd.h                                   |    2 -
 sound/oss/msnd_classic.h                           |    2 -
 sound/oss/msnd_pinnacle.c                          |    5 -
 sound/oss/msnd_pinnacle.h                          |    2 -
 sound/parisc/Kconfig                               |   13 +-
 sound/pci/Kconfig                                  |  104 +--
 sound/pci/Makefile                                 |    2 +-
 sound/pci/ac97/Makefile                            |   12 +-
 sound/pci/ac97/ac97_codec.c                        |   11 +-
 sound/pci/ac97/ac97_patch.c                        |   81 +-
 sound/pci/{ac97 =3D> }/ak4531_codec.c                |   34 +-
 sound/pci/au88x0/au88x0_game.c                     |    2 -
 sound/pci/azt3328.c                                | 1235 ++++++++++-----
 sound/pci/azt3328.h                                |  207 +++-
 sound/pci/ca0106/ca0106_main.c                     |    5 +
 sound/pci/emu10k1/emu10k1_main.c                   |    1 +
 sound/pci/emu10k1/emumixer.c                       |   13 +-
 sound/pci/emu10k1/memory.c                         |   69 +-
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/hda_codec.h                          |    2 +-
 sound/pci/hda/hda_hwdep.c                          |    2 +-
 sound/pci/hda/hda_intel.c                          |  306 +++-
 sound/pci/hda/hda_proc.c                           |    5 +-
 sound/pci/hda/patch_analog.c                       |   38 +-
 sound/pci/hda/patch_conexant.c                     |   33 +-
 sound/pci/hda/patch_realtek.c                      |  548 +++++++-
 sound/pci/hda/patch_sigmatel.c                     |   71 +-
 sound/pci/ice1712/envy24ht.h                       |   10 +-
 sound/pci/ice1712/ice1712.h                        |    2 +
 sound/pci/ice1712/ice1724.c                        |  213 ++-
 sound/pci/maestro3.c                               |   42 +-
 sound/pci/nm256/nm256.c                            |    4 +-
 sound/pci/oxygen/hifier.c                          |   33 +-
 sound/pci/oxygen/oxygen.c                          |   76 +-
 sound/pci/oxygen/oxygen.h                          |   14 +
 sound/pci/oxygen/oxygen_io.c                       |   22 +-
 sound/pci/oxygen/oxygen_lib.c                      |  106 ++-
 sound/pci/oxygen/oxygen_pcm.c                      |   53 +-
 sound/pci/oxygen/virtuoso.c                        |  252 ++--
 sound/pci/pcxhr/pcxhr.c                            |    4 +-
 sound/pci/pcxhr/pcxhr_core.c                       |   18 +-
 sound/pci/trident/trident_main.c                   |    5 +-
 sound/pci/trident/trident_memory.c                 |  178 ---
 sound/pci/via82xx.c                                |    6 +
 sound/pci/ymfpci/ymfpci_main.c                     |    2 +
 sound/pcmcia/Kconfig                               |   15 +-
 sound/pcmcia/vx/vxp_ops.c                          |    2 +-
 sound/ppc/Kconfig                                  |   26 +-
 sound/ppc/daca.c                                   |    2 -
 sound/ppc/tumbler.c                                |    2 -
 sound/sh/Kconfig                                   |   16 +-
 sound/soc/Kconfig                                  |   19 +-
 sound/soc/Makefile                                 |    3 +-
 sound/soc/at32/Kconfig                             |   34 +
 sound/soc/at32/Makefile                            |   11 +
 sound/soc/at32/at32-pcm.c                          |  491 ++++++
 sound/soc/at32/at32-pcm.h                          |   79 +
 sound/soc/at32/at32-ssc.c                          |  849 ++++++++++
 sound/soc/at32/at32-ssc.h                          |   59 +
 sound/soc/at32/playpaq_wm8510.c                    |  522 +++++++
 sound/soc/at91/Kconfig                             |    2 +-
 sound/soc/at91/at91-pcm.c                          |    6 +-
 sound/soc/at91/at91-ssc.c                          |   12 +-
 sound/soc/at91/at91-ssc.h                          |    2 +-
 sound/soc/at91/eti_b1_wm8731.c                     |   53 +-
 sound/soc/au1x/Kconfig                             |   32 +
 sound/soc/au1x/Makefile                            |   13 +
 sound/soc/au1x/dbdma2.c                            |  421 +++++
 sound/soc/au1x/psc-ac97.c                          |  387 +++++
 sound/soc/au1x/psc-i2s.c                           |  414 +++++
 sound/soc/au1x/psc.h                               |   53 +
 sound/soc/au1x/sample-ac97.c                       |  144 ++
 sound/soc/codecs/Kconfig                           |   22 +-
 sound/soc/codecs/Makefile                          |    8 +
 sound/soc/codecs/ac97.c                            |   31 +-
 sound/soc/codecs/ac97.h                            |    2 +-
 sound/soc/codecs/ak4535.c                          |  696 +++++++++
 sound/soc/codecs/ak4535.h                          |   46 +
 sound/soc/codecs/cs4270.c                          |    8 +-
 sound/soc/codecs/cs4270.h                          |    2 +-
 sound/soc/codecs/tlv320aic3x.c                     |  384 +++--
 sound/soc/codecs/tlv320aic3x.h                     |   55 +-
 sound/soc/codecs/uda1380.c                         |  852 ++++++++++
 sound/soc/codecs/uda1380.h                         |   89 ++
 sound/soc/codecs/wm8510.c                          |  817 ++++++++++
 sound/soc/codecs/wm8510.h                          |  103 ++
 sound/soc/codecs/wm8731.c                          |   79 +-
 sound/soc/codecs/wm8731.h                          |    2 +-
 sound/soc/codecs/wm8750.c                          |   87 +-
 sound/soc/codecs/wm8750.h                          |    2 +-
 sound/soc/codecs/wm8753.c                          |  183 ++--
 sound/soc/codecs/wm8753.h                          |    2 +-
 sound/soc/codecs/wm8990.c                          | 1626 ++++++++++++++++=
++++
 sound/soc/codecs/wm8990.h                          |  832 ++++++++++
 sound/soc/codecs/wm9712.c                          |   53 +-
 sound/soc/codecs/wm9712.h                          |    2 +-
 sound/soc/codecs/wm9713.c                          |   79 +-
 sound/soc/codecs/wm9713.h                          |    2 +-
 sound/soc/davinci/Kconfig                          |    2 +-
 sound/soc/davinci/davinci-evm.c                    |   40 +-
 sound/soc/davinci/davinci-i2s.c                    |   16 +-
 sound/soc/davinci/davinci-i2s.h                    |    2 +-
 sound/soc/davinci/davinci-pcm.c                    |    2 +-
 sound/soc/fsl/Kconfig                              |    6 +-
 sound/soc/fsl/fsl_dma.c                            |    2 +-
 sound/soc/fsl/fsl_dma.h                            |    2 +-
 sound/soc/fsl/fsl_ssi.c                            |   24 +-
 sound/soc/fsl/fsl_ssi.h                            |    4 +-
 sound/soc/fsl/mpc8610_hpcd.c                       |   72 +-
 sound/soc/omap/Kconfig                             |    4 -
 sound/soc/omap/n810.c                              |  106 +-
 sound/soc/omap/omap-mcbsp.c                        |   16 +-
 sound/soc/omap/omap-mcbsp.h                        |    2 +-
 sound/soc/omap/omap-pcm.c                          |    2 +-
 sound/soc/pxa/Kconfig                              |   11 +-
 sound/soc/pxa/Makefile                             |    3 +-
 sound/soc/pxa/corgi.c                              |   70 +-
 sound/soc/pxa/em-x270.c                            |  102 ++
 sound/soc/pxa/poodle.c                             |   50 +-
 sound/soc/pxa/pxa2xx-ac97.c                        |   18 +-
 sound/soc/pxa/pxa2xx-ac97.h                        |    2 +-
 sound/soc/pxa/pxa2xx-i2s.c                         |   17 +-
 sound/soc/pxa/pxa2xx-i2s.h                         |    2 +-
 sound/soc/pxa/pxa2xx-pcm.c                         |    2 +-
 sound/soc/pxa/spitz.c                              |   91 +-
 sound/soc/pxa/tosa.c                               |   47 +-
 sound/soc/s3c24xx/Kconfig                          |    4 +-
 sound/soc/s3c24xx/neo1973_wm8753.c                 |  237 ++--
 sound/soc/s3c24xx/s3c2412-i2s.c                    |   15 +-
 sound/soc/s3c24xx/s3c2412-i2s.h                    |    2 +-
 sound/soc/s3c24xx/s3c2443-ac97.c                   |   15 +-
 sound/soc/s3c24xx/s3c24xx-ac97.h                   |    2 +-
 sound/soc/s3c24xx/s3c24xx-i2s.c                    |   25 +-
 sound/soc/s3c24xx/s3c24xx-i2s.h                    |    2 +-
 sound/soc/s3c24xx/s3c24xx-pcm.c                    |    6 +-
 sound/soc/s3c24xx/smdk2443_wm9710.c                |    3 -
 sound/soc/sh/Kconfig                               |    5 +-
 sound/soc/sh/dma-sh7760.c                          |    2 +-
 sound/soc/sh/hac.c                                 |    2 +-
 sound/soc/sh/sh7760-ac97.c                         |    4 +-
 sound/soc/sh/ssi.c                                 |    8 +-
 sound/soc/soc-core.c                               |  443 ++++--
 sound/soc/soc-dapm.c                               |  344 ++++-
 sound/sparc/Kconfig                                |   17 +-
 sound/sparc/dbri.c                                 |    2 +-
 sound/spi/Kconfig                                  |   13 +-
 sound/usb/Kconfig                                  |   16 +-
 sound/usb/caiaq/caiaq-audio.c                      |    1 +
 sound/usb/caiaq/caiaq-device.c                     |   12 +-
 sound/usb/caiaq/caiaq-device.h                     |    1 +
 sound/usb/usbaudio.c                               |    4 -
 sound/usb/usbquirks.h                              |   38 +
 201 files changed, 16473 insertions(+), 3893 deletions(-)
 rename sound/pci/{ac97 =3D> }/ak4531_codec.c (96%)

Adrian Bunk (6):
      [ALSA] remove CVS keywords
      sound: sound/oss/: remove CVS keywords
      [ALSA] remove SND_GUS_SYNTH
      [ALSA] usbaudio.c: remove #ifndef CONFIG_USB_EHCI_SPLIT_ISO code
      ALSA: make sparc/dbri.c:snd_dbri_proc() static
      sound: sound/oss/dmasound/: cleanups

Akio Idehara (1):
      [ALSA] hda - Add Toshiba dynabook SS RX1 support

Andreas Mohr (2):
      [ALSA] PCI168 snd-azt3328 Linux driver: another huge update
      ALSA: PCI168 snd-azt3328: some more fixups

Andy Green (1):
      ALSA: ASoC: Don't block system resume

Chris Mennie (1):
      [ALSA] usb-audio - Support for Roland SonicCell sound module

Clemens Ladisch (12):
      [ALSA] oxygen: fix version in MODULE_LICENSE
      [ALSA] oxygen: add symbol for I/O space size
      [ALSA] oxygen: save register writes
      [ALSA] oxygen: simplify DAC volume initialization
      [ALSA] oxygen: separate out hardware initialization code
      [ALSA] virtuoso: add xonar_enable_output()
      [ALSA] oxygen: add PM support
      [ALSA] oxygen: add symbols for buffer/period size constraints
      [ALSA] virtuoso: restrict period time to less than 10 s
      [ALSA] ice1724: fix MIDI
      ALSA: usb-audio: fix Yamaha KX quirk
      ALSA: usb-audio: add some Yamaha USB MIDI quirks

Daniel Jacobowitz (1):
      [ALSA] ac97 - Add virtual master control to VT1616/VT1617A codec.

Daniel Mack (3):
      [ALSA] soc - tlv320aic3x - revisit clock setup
      [ALSA] soc - tlv320aic3x - add GPIO support
      [ALSA] snd_usb_caiaq: add support for 'Session I/O' interface

David Howells (2):
      ALSA: Fix a const pointer usage warning in the Digigram VX soundcard =
driver
      ALSA: Fix a const to non-const assignment in the Digigram VXpocket so=
und driver

Dmitry Baryshkov (2):
      ALSA: tosa: fix compilation with new DAPM API
      ALSA: ASoC: pxa2xx-ac97: fix warning due to missing argument in fucti=
on declaration

Geoffrey Wossum (1):
      [ALSA] Revised AT32 ASoC Patch

Graeme Gregory (1):
      [ALSA] soc - DAPM - add hook to read state of DAPM widget

Harvey Harrison (2):
      [ALSA] i2c: cs8427.c use put_unaligned helper
      alsa: add annotations to bitwise type snd_pcm_hw_param_t

Jarkko Nikula (8):
      [ALSA] ASoC: Convert N810 machine driver to use gpiolib
      ALSA: ASoC: Cover also Nokia N810 WiMAX Edition in N810 machine drive=
r
      ALSA: ASoC: Add support for generic DAPM register modifier widget
      ALSA: ASoC: TLV320AIC3X: Use register modifier widget for mic bias
      ALSA: ASoC: TLV320AIC3X: Modify only interface related bits in aic3x_=
set_dai_fmt
      ALSA: ASoC: TLV320AIC3X: Add support for digital microphone input
      ALSA: ASoC: Add digital mic configuration to N810 machine driver
      ALSA: ASoC: TLV320AIC3X: Add mixer control for ADC highpass filter

Jaroslav Kysela (8):
      ALSA: Release v1.0.17rc1
      ALSA: Release 1.0.17rc2
      ALSA: Remove duplicate MODULE_AUTHOR/DESCRIPTION/LICENCE from snd-ens=
1370.ko
      ALSA: emu10k1 - fix possible memory leak in memory allocation routine=
s
      [ALSA] Revert "alsa: add annotations to bitwise type snd_pcm_hw_param=
_t"
      ALSA: Release v1.0.17rc3
      ALSA: HDA - HP dc7600 with pci sub IDs 0x103c/0x3011 belongs to hp-30=
13 model
      ALSA: Release v1.0.17

Jiang zhe (1):
      [ALSA] hda - support intel DG33 motherboards

Johannes Berg (1):
      ALSA: remove CONFIG_KMOD from sound

Juergen Beisert (1):
      [ALSA] ac97: add support for wm9711 master left inv switch

Kailang Yang (6):
      [ALSA] hda - Add support of Teradici controller
      [ALSA] hda - Add ICH9 controller support (8086:2911)
      [ALSA] hda - Add ALC663 support
      [ALSA] hda - Fix vref pincap check in alc882 auto-detection
      [ALSA] hda - show correct codec chip in PCM stream names
      [ALSA] hda - Fix EAPD and COEF setups for realtek codecs

Krzysztof Helt (3):
      [ALSA] opti93x: fix sound ouput for Opti930
      ALSA: opti93x: add support for Opti93x codec in cs4231-lib
      ALSA: opti93x: use cs4231 lib

Liam Girdwood (16):
      ALSA: asoc: core - refactored DAPM pin control API.
      ALSA: asoc: core - merge structs snd_soc_codec_dai and snd_soc_cpu_da=
i.
      ALSA: asoc: at32 - merge structs snd_soc_codec_dai and snd_soc_cpu_da=
i.
      ALSA: asoc: at91 - merge structs snd_soc_codec_dai and snd_soc_cpu_da=
i.
      ALSA: asoc: davinci - merge structs snd_soc_codec_dai and snd_soc_cpu=
_dai.
      ALSA: asoc: codecs - merge structs snd_soc_codec_dai and snd_soc_cpu_=
dai.
      ALSA: asoc: fsl - merge structs snd_soc_codec_dai and snd_soc_cpu_dai=
=2E
      ALSA: asoc: omap - merge structs snd_soc_codec_dai and snd_soc_cpu_da=
i.
      ALSA: asoc: pxa - merge structs snd_soc_codec_dai and snd_soc_cpu_dai=
=2E
      ALSA: asoc: s3c24xx - merge structs snd_soc_codec_dai and snd_soc_cpu=
_dai.
      ALSA: asoc: sh - merge structs snd_soc_codec_dai and snd_soc_cpu_dai.
      ALSA: asoc: core - add Digital Audio Interface (DAI) control function=
s.
      ALSA: asoc: machines - add Digital Audio Interface (DAI) control func=
tions.
      ALSA: asoc: n810 - fix build error.
      ALSA: asoc: at32 - DAI struct merge and enable_pin() change.
      ALSA: asoc: kbuild - only show menus for the current ASoC CPU platfor=
m.

Manuel Lauss (2):
      ALSA: ASoC: AC97 codec PM
      ALSA: ASoC: Au12x0/Au1550 PSC Audio support

Mark Brown (30):
      [ALSA] soc - DAPM - Add bulk control registration
      [ALSA] soc - DAPM - Bulk route registration
      [ALSA] soc - tlv320aic3x - Convert to use bulk registration APIs
      [ALSA] soc - Zaurus - Convert to bulk DAPM registration APIs
      [ALSA] soc - eti_b1_wm8731 - Convert to use bulk DAPM control registr=
ation
      [ALSA] soc - neo1973_wm8753 - Convert to bulk DAPM registration APIs
      [ALSA] soc - davinci-evm - Update for bulk DAPM registration APIs
      [ALSA] soc - n810 - Update for bulk DAPM registration APIs
      [ALSA] ASoC: Remove in-code changelogs
      [ALSA] ASoC: Make CPU and codec DAI operations have same type
      [ALSA] ASoC: Clarify API for bias configuration
      [ALSA] ASoC: core checkpatch cleanups
      [ALSA] soc - Convert Wolfson codec drivers to use bulk DAPM registrat=
ion
      [ALSA] ASoC: Add SOC_DOUBLE_S8_TLV control type
      [ALSA] ASoC: Add WM8510 driver
      [ALSA] ASoC: Add WM8990 driver
      [ALSA] ASoC: Fix default mono mixer configuration for WM8510
      ALSA: ASoC: Fix register cache sizes for Wolfson codecs
      ALSA: ASoC: Fix register cache size for UDA1380
      ALSA: ASoC: Tweak tlv320aicx reg_cache_size
      ALSA: ASoC: Add missing includes
      ALSA: ASoC: Pass the DAI being configured into CPU DAI probe and remo=
ve
      ALSA: ASoC: Fix WM9713 voice PCM slave mode configuration
      ALSA: ASoC: Check for exact register match in wm97xx_reset()
      ALSA: ASoC: Replace custom debug macros with pr_ equivalents
      ALSA: ASoC: Advertise 16000Hz rate for WM9713 PCM interface
      ALSA: ASoC: Make pop/click debug wait times dynamically configurable
      ALSA: ASoC: Fix warning from strict_strtoul()
      ALSA: ASoC: Switch DAPM to use of standard DEBUG macro
      ALSA: ASoC: Dump DAPM state for non-stream changes

Matthew Ranostay (3):
      ALSA: hda: Add support for 92HD73xxx codecs
      ALSA: hda - removed redundant gpio_mask
      ALSA: hda: 92hd71bxx PC Beep

Mike Montour (3):
      ALSA: ASoC: Add TLV information to remaining WM8753 controls
      ALSA: ASoC: Add SOC_SINGLE_EXT_TLV control type
      ALSA: ASoC: Add TLV information to the LM4857 controls on the GTA01

Mike Rapoport (2):
      [ALSA] Add EM-X270 ASoC driver
      ALSA: ac97 - fix patch_ucb1400 for proper resume

Milton Miller (1):
      ALSA: correct kcalloc usage

Philipp Zabel (1):
      [ALSA] ASoC: Add UDA1380 driver

Pierre Ossman (1):
      ALSA: trident - pause s/pdif output

Randy Dunlap (1):
      ALSA: ASoC: fix PM=3Dn build

Richard Chan (1):
      ALSA: Add Yamaha KX49 (USB MIDI controller) to usbquirks.h

Richard Purdie (1):
      ALSA: ASoC: Add AK4535 driver

Stephen Rothwell (1):
      [ALSA] sound: fix export symbol typo

Takashi Iwai (44):
      [ALSA] Remove unneeded ugly hack for i386 in memalloc.c
      [ALSA] hda - Fix DMA position inaccuracy
      sound: Convert to menuconfig
      [ALSA] Fix AC97 kconfig items
      [ALSA] Replace CONFIG_SND_DEBUG_DETECT with CONFIG_SND_DEBUG_VERBOSE
      [ALSA] Improve the slots option handling
      [ALSA] Clean up sound/pci/ac97/Makefile
      [ALSA] Make ak4531 local to ens1370 driver
      [ALSA] trident - clean up obsolete synth codes
      sound: Clean up sound/oss/Kconfig
      [ALSA] trivial clean up of sound/isa/sb/Makefile
      [ALSA] emu10k1 - simplify page allocation for synth
      [ALSA] emu10k1 - Fix inverted Analog/Digital mixer switch on Audigy2
      [ALSA] hda - Fix PLL gating control on Realtek codecs
      [ALSA] hda - increase max_codecs of ICH to 4
      [ALSA] ac97 - Fix power_save option value as time-out
      ALSA: emu10k1 - Fix page allocation with GFP_DMA
      ALSA: hda - Add bdl_pos_adj option
      ALSA: hda - remove position_fix=3D3
      ALSA: hda - bdl_pos_adj option to each instance
      ALSA: hda - Fix bdl_pos_adj value for ATI SB chipsets
      ALSA: hda - Add description of bdl_pos_adj option
      ALSA: hda - Add a warning if pending IRQ is found
      ALSA: hda - Fix stac9205_cfg_tbl
      ALSA: hda - Remove unused mutex
      ALSA: make snd_ctl_elem_read() and snd_ctl_elem_write() static
      ALSA: hda - bdl_pos_adj=3D32 as default
      ALSA: hda - use upper_32_bits()
      ALSA: emu10k1 - simplify the last fix
      ALSA: hda - Fix wrong volumes in AD1988 auto-probe mode
      ALSA: ca0106 - Add entry for another MSI K8N Diamond MB
      ALSA: hda - Fix digital converter proc output
      ALSA: hda - Add MacBook 3.1 support
      ALSA: ymfpci - fix initial volume for 44.1kHz output
      ALSA: hda - disable amp override on non-HP machines
      ALSA: Fix AC97 power down
      ALSA: ALSA: hda - Fix ALC883 medion model
      ALSA: hda - Add missing Thinkpad Z60m support
      ALSA: ALSA: hda - Fix speaker output on Toshiba P105
      ALSA: hda - Add support for Lenovo 3000 N200
      ALSA: wavefront - add const
      ALSA: hda - Fix internal mic vref pin setup
      ALSA: hda - Fix missing init for unsol events on micsense model
      ALSA: hda - Fix FSC V5505 model

Thomas Bogendoerfer (2):
      ALSA: ALSA driver for SGI HAL2 audio device
      ALSA: ALSA driver for SGI O2 audio board

Tim Niemeyer (1):
      [ALSA] soc - Patch to add debug messages to the neo1973_wm8753 (GTA01=
) sound driver

Timur Tabi (1):
      ALSA: Fix register programming in Freescale MPC8610 HPCD sound driver

Travis Place (2):
      ALSA: hda - Added model selection for iMac 24"
      ALSA: hda - Added SSID for 'Fujitsu Siemens Amilo M1451G' laptop

Ville Syrj=E4l=E4 (1):
      [ALSA] maestro3: Fix hw volume on HP OmniBook

Walter Sheets (1):
      ALSA: via82xx - Add VIA audio device #1841 to ac97_quirk list

Werner Almesberger (1):
      [ALSA] soc - Fix s3c24xx-i2s LR sync while timer ticks are disabled

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.
---1463789724-93151169-1216026548=:7676--
