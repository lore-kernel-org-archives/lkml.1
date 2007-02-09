Return-Path: <linux-kernel-owner+w=401wt.eu-S1946470AbXBIOCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946470AbXBIOCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946471AbXBIOCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:02:13 -0500
Received: from gate.perex.cz ([212.20.107.50]:36548 "EHLO gate.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946470AbXBIOCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:02:09 -0500
Date: Fri, 9 Feb 2007 15:02:05 +0100 (CET)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103-a.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0702091451010.5511@tm8103-a.perex-int.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463789724-479039958-1171029122=:5511"
Content-ID: <Pine.LNX.4.61.0702091501060.5511@tm8103-a.perex-int.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463789724-479039958-1171029122=:5511
Content-Type: TEXT/PLAIN; CHARSET=iso8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.61.0702091501061.5511@tm8103-a.perex-int.cz>

Linus, please do an update from:

  http://www.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git
  (linus branch)

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-02-09.patch.g=
z

The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt    |   60 +-
 .../sound/alsa/DocBook/alsa-driver-api.tmpl        |    4 +-
 .../sound/alsa/DocBook/writing-an-alsa-driver.tmpl |   33 +-
 Documentation/sound/alsa/hda_codec.txt             |   10 +-
 Documentation/sound/alsa/soc/DAI.txt               |   56 +
 Documentation/sound/alsa/soc/clocking.txt          |   51 +
 Documentation/sound/alsa/soc/codec.txt             |  197 ++
 Documentation/sound/alsa/soc/dapm.txt              |  297 +++
 Documentation/sound/alsa/soc/machine.txt           |  113 +
 Documentation/sound/alsa/soc/overview.txt          |   83 +
 Documentation/sound/alsa/soc/platform.txt          |   58 +
 Documentation/sound/alsa/soc/pops_clicks.txt       |   52 +
 MAINTAINERS                                        |    6 +
 drivers/input/touchscreen/ucb1400_ts.c             |    2 +-
 include/linux/i2c-id.h                             |    2 +
 include/sound/ac97_codec.h                         |    4 +-
 include/sound/ad1848.h                             |    2 +-
 include/sound/ak4114.h                             |    3 +-
 include/sound/ak4117.h                             |    2 +-
 include/sound/ak4xxx-adda.h                        |    6 +-
 include/sound/control.h                            |    5 +-
 include/sound/core.h                               |   62 +-
 include/sound/emu10k1.h                            |  418 +++-
 include/sound/pcm.h                                |    4 +
 include/sound/pt2258.h                             |   37 +
 include/sound/sb16_csp.h                           |   14 +
 include/sound/snd_wavefront.h                      |    2 +
 include/sound/soc-dapm.h                           |  286 ++
 include/sound/soc.h                                |  461 ++++
 include/sound/typedefs.h                           |  173 --
 include/sound/version.h                            |    4 +-
 include/sound/vx_core.h                            |    2 +-
 include/sound/ymfpci.h                             |    6 +-
 sound/Kconfig                                      |    2 +
 sound/Makefile                                     |    2 +-
 sound/ac97_bus.c                                   |    4 +
 sound/aoa/aoa.h                                    |    2 +-
 sound/aoa/codecs/snd-aoa-codec-onyx.c              |   11 +-
 sound/aoa/core/snd-aoa-alsa.c                      |    5 +-
 sound/aoa/core/snd-aoa-alsa.h                      |    2 +-
 sound/aoa/core/snd-aoa-core.c                      |    4 +-
 sound/aoa/fabrics/snd-aoa-fabric-layout.c          |   13 +-
 sound/aoa/soundbus/i2sbus/i2sbus-core.c            |   22 +-
 sound/aoa/soundbus/i2sbus/i2sbus-pcm.c             |  407 ++--
 sound/aoa/soundbus/i2sbus/i2sbus.h                 |    6 +
 sound/arm/aaci.h                                   |    2 +-
 sound/core/control.c                               |   42 +-
 sound/core/control_compat.c                        |    5 +-
 sound/core/device.c                                |   24 +-
 sound/core/hwdep.c                                 |   19 +-
 sound/core/init.c                                  |   22 +-
 sound/core/memalloc.c                              |   10 +-
 sound/core/misc.c                                  |   28 +
 sound/core/pcm.c                                   |   50 +-
 sound/core/pcm_lib.c                               |    5 +
 sound/core/pcm_memory.c                            |   23 +
 sound/core/rawmidi.c                               |   29 +-
 sound/core/seq/seq_clientmgr.c                     |   14 +-
 sound/core/seq/seq_device.c                        |   25 +-
 sound/core/seq/seq_ports.c                         |   51 +-
 sound/core/seq/seq_virmidi.c                       |    4 +-
 sound/core/sound.c                                 |   15 +-
 sound/core/timer.c                                 |   80 +-
 sound/drivers/Kconfig                              |   11 +
 sound/drivers/Makefile                             |    2 +
 sound/drivers/dummy.c                              |    2 +-
 sound/drivers/portman2x4.c                         |  876 +++++++
 sound/drivers/serial-u16550.c                      |  221 +-
 sound/drivers/vx/vx_mixer.c                        |    2 +-
 sound/i2c/Makefile                                 |    1 +
 sound/i2c/other/Makefile                           |    4 +-
 sound/i2c/other/ak4114.c                           |   29 +-
 sound/i2c/other/ak4117.c                           |    2 +-
 sound/i2c/other/ak4xxx-adda.c                      |  110 +-
 sound/i2c/other/pt2258.c                           |  233 ++
 sound/isa/Kconfig                                  |    2 +
 sound/isa/ad1816a/ad1816a_lib.c                    |   10 +-
 sound/isa/ad1848/ad1848_lib.c                      |    6 +-
 sound/isa/gus/gus_main.c                           |    6 +-
 sound/isa/opl3sa2.c                                |    4 +-
 sound/isa/sb/sb16_csp.c                            |   61 +-
 sound/isa/wavefront/wavefront.c                    |    1 +
 sound/isa/wavefront/wavefront_fx.c                 |  812 +------
 sound/isa/wavefront/yss225.c                       | 2739 ++++++++++++++++=
++++
 sound/pci/Kconfig                                  |   30 +-
 sound/pci/ac97/ac97_codec.c                        |   64 +-
 sound/pci/ac97/ac97_patch.c                        |  549 ++++-
 sound/pci/ac97/ac97_patch.h                        |    1 +
 sound/pci/ac97/ak4531_codec.c                      |    6 +-
 sound/pci/als300.c                                 |    6 +-
 sound/pci/atiixp.c                                 |   31 +-
 sound/pci/atiixp_modem.c                           |    2 +-
 sound/pci/ca0106/ca0106_main.c                     |   21 +-
 sound/pci/ca0106/ca0106_mixer.c                    |   50 +-
 sound/pci/cs4281.c                                 |    2 +-
 sound/pci/echoaudio/darla20.c                      |    1 +
 sound/pci/echoaudio/darla24.c                      |    1 +
 sound/pci/echoaudio/echo3g.c                       |    1 +
 sound/pci/echoaudio/echo3g_dsp.c                   |    2 +-
 sound/pci/echoaudio/echoaudio.c                    |   18 +-
 sound/pci/echoaudio/gina20.c                       |    1 +
 sound/pci/echoaudio/gina24.c                       |    1 +
 sound/pci/echoaudio/indigo.c                       |    1 +
 sound/pci/echoaudio/indigodj.c                     |    1 +
 sound/pci/echoaudio/indigoio.c                     |    1 +
 sound/pci/echoaudio/layla20.c                      |    1 +
 sound/pci/echoaudio/layla24.c                      |    1 +
 sound/pci/echoaudio/mia.c                          |    1 +
 sound/pci/echoaudio/mona.c                         |    1 +
 sound/pci/emu10k1/emu10k1_main.c                   |  616 ++++-
 sound/pci/emu10k1/emu10k1x.c                       |    6 +-
 sound/pci/emu10k1/emufx.c                          |  204 ++-
 sound/pci/emu10k1/emumixer.c                       |  745 ++++++-
 sound/pci/emu10k1/emupcm.c                         |  147 +-
 sound/pci/emu10k1/emuproc.c                        |   34 +-
 sound/pci/emu10k1/io.c                             |  104 +
 sound/pci/emu10k1/p16v.c                           |   14 +-
 sound/pci/emu10k1/p17v.h                           |   47 +
 sound/pci/emu10k1/voice.c                          |    2 +-
 sound/pci/ens1370.c                                |  154 +-
 sound/pci/es1938.c                                 |    2 +-
 sound/pci/fm801.c                                  |    2 +-
 sound/pci/hda/Makefile                             |   11 +-
 sound/pci/hda/hda_codec.c                          |   68 +-
 sound/pci/hda/hda_intel.c                          |   33 +-
 sound/pci/hda/hda_local.h                          |   12 +-
 sound/pci/hda/hda_patch.h                          |    6 +
 sound/pci/hda/patch_analog.c                       |  165 +-
 sound/pci/hda/patch_cmedia.c                       |   24 +-
 sound/pci/hda/patch_conexant.c                     | 1311 ++++++++++
 sound/pci/hda/patch_realtek.c                      | 2367 +++++++++++++++-=
-
 sound/pci/hda/patch_sigmatel.c                     |  692 ++++--
 sound/pci/hda/patch_via.c                          | 1396 ++++++++++
 sound/pci/ice1712/Makefile                         |    2 +-
 sound/pci/ice1712/amp.c                            |    4 +-
 sound/pci/ice1712/amp.h                            |    2 +-
 sound/pci/ice1712/aureon.c                         |  186 +-
 sound/pci/ice1712/aureon.h                         |    6 +-
 sound/pci/ice1712/delta.c                          |   34 +-
 sound/pci/ice1712/delta.h                          |    2 +-
 sound/pci/ice1712/ews.c                            |   24 +-
 sound/pci/ice1712/ews.h                            |    2 +-
 sound/pci/ice1712/hoontech.c                       |    7 +-
 sound/pci/ice1712/hoontech.h                       |    2 +-
 sound/pci/ice1712/ice1712.c                        |   74 +-
 sound/pci/ice1712/ice1712.h                        |   18 +-
 sound/pci/ice1712/ice1724.c                        |   78 +-
 sound/pci/ice1712/juli.c                           |   36 +-
 sound/pci/ice1712/juli.h                           |    2 +-
 sound/pci/ice1712/phase.c                          |   76 +-
 sound/pci/ice1712/phase.h                          |    2 +-
 sound/pci/ice1712/pontis.c                         |   42 +-
 sound/pci/ice1712/pontis.h                         |    2 +-
 sound/pci/ice1712/prodigy192.c                     |   40 +-
 sound/pci/ice1712/prodigy192.h                     |    2 +-
 sound/pci/ice1712/revo.c                           |  372 +++-
 sound/pci/ice1712/revo.h                           |   13 +-
 sound/pci/ice1712/vt1720_mobo.c                    |   59 +-
 sound/pci/ice1712/vt1720_mobo.h                    |    2 +-
 sound/pci/ice1712/wtm.c                            |  542 ++++
 sound/pci/ice1712/wtm.h                            |   20 +
 sound/pci/intel8x0.c                               |  208 +-
 sound/pci/intel8x0m.c                              |  120 +-
 sound/pci/korg1212/korg1212.c                      |   45 +-
 sound/pci/maestro3.c                               |  373 ++--
 sound/pci/mixart/mixart_mixer.c                    |    4 +-
 sound/pci/nm256/nm256.c                            |   56 +-
 sound/pci/pcxhr/pcxhr_mixer.c                      |    6 +-
 sound/pci/rme9652/hdsp.c                           |   38 +
 sound/pci/rme9652/hdspm.c                          | 1242 ++++++++--
 sound/pci/trident/trident_main.c                   |    4 +-
 sound/pci/via82xx.c                                |  134 +-
 sound/pci/via82xx_modem.c                          |    2 +-
 sound/pci/vx222/vx222.c                            |    4 +-
 sound/pci/vx222/vx222_ops.c                        |    2 +-
 sound/pci/ymfpci/ymfpci_image.h                    |    6 +-
 sound/pci/ymfpci/ymfpci_main.c                     |  171 +-
 sound/pcmcia/vx/vxp_mixer.c                        |    2 +-
 sound/pcmcia/vx/vxpocket.c                         |    2 +-
 sound/soc/Kconfig                                  |   32 +
 sound/soc/Makefile                                 |    4 +
 sound/soc/at91/Kconfig                             |   32 +
 sound/soc/at91/Makefile                            |   11 +
 sound/soc/at91/at91-i2s.c                          |  720 +++++
 sound/soc/at91/at91-i2s.h                          |   27 +
 sound/soc/at91/at91-pcm.c                          |  432 +++
 sound/soc/at91/at91-pcm.h                          |   72 +
 sound/soc/at91/eti_b1_wm8731.c                     |  375 +++
 sound/soc/codecs/Kconfig                           |   15 +
 sound/soc/codecs/Makefile                          |    9 +
 sound/soc/codecs/ac97.c                            |  156 ++
 sound/soc/codecs/ac97.h                            |   18 +
 sound/soc/codecs/wm8731.c                          |  758 ++++++
 sound/soc/codecs/wm8731.h                          |   44 +
 sound/soc/codecs/wm8750.c                          | 1049 ++++++++
 sound/soc/codecs/wm8750.h                          |   67 +
 sound/soc/codecs/wm9712.c                          |  771 ++++++
 sound/soc/codecs/wm9712.h                          |   14 +
 sound/soc/pxa/Kconfig                              |   60 +
 sound/soc/pxa/Makefile                             |   20 +
 sound/soc/pxa/corgi.c                              |  383 +++
 sound/soc/pxa/poodle.c                             |  352 +++
 sound/soc/pxa/pxa2xx-ac97.c                        |  431 +++
 sound/soc/pxa/pxa2xx-ac97.h                        |   22 +
 sound/soc/pxa/pxa2xx-i2s.c                         |  318 +++
 sound/soc/pxa/pxa2xx-i2s.h                         |   20 +
 sound/soc/pxa/pxa2xx-pcm.c                         |  372 +++
 sound/soc/pxa/pxa2xx-pcm.h                         |   34 +
 sound/soc/pxa/spitz.c                              |  394 +++
 sound/soc/pxa/tosa.c                               |  289 ++
 sound/soc/soc-core.c                               | 1587 ++++++++++++
 sound/soc/soc-dapm.c                               | 1323 ++++++++++
 sound/sparc/dbri.c                                 |    2 +-
 sound/usb/usbaudio.c                               |  189 +-
 sound/usb/usbaudio.h                               |    1 +
 sound/usb/usbquirks.h                              |   32 +-
 216 files changed, 28241 insertions(+), 3797 deletions(-)


The following things were done:

Adrian Bunk (4):
      [ALSA] make sound/pci/hda/patch_sigmatel.c:stac92xx_dmic_labels[] sta=
tic
      [ALSA] make sound/core/control.c:snd_ctl_new() static
      [ALSA] sound/soc/soc-dapm.c: make 4 functions static
      [ALSA] echo3g_dsp.c shouldn't include #include <linux/irq.h>

Andrew Johnson (1):
      [ALSA] soc - ASoC 0.13 pxa2xx DMA

Andrew L. Neporada (1):
      [ALSA] hda-codec - Clevo M540JE, M550JE laptops (Nvidia MCP51 chipset=
, ALC883 codec)

Andrew Morton (3):
      [ALSA] arm header fix
      [ALSA] ucb1400_ts.c compilation fix (struct snd_ac97)
      [ALSA] Fix the soc code after dhowells workqueue changes.

Bjoern Fay (1):
      [ALSA] usbaudio - Add support for Edirol UA-101

Clemens Ladisch (11):
      [ALSA] usb-audio: merge playback/capture hardware information structs
      [ALSA] usb-audio: allow pausing
      [ALSA] soc-core: fix multi-line string literal
      [ALSA] pci: select FW_LOADER instead of depending on it
      [ALSA] emu10k1: select FW_LOADER
      [ALSA] ymfpci: add request_firmware()
      [ALSA] sb16: add request_firmware()
      [ALSA] wavefront: simplify YSS225 register initialization
      [ALSA] wavefront: add request_firmware()
      [ALSA] korg1212: add request_firmware()
      [ALSA] maestro3: add request_firmware()

Clement Guedez (1):
      [ALSA] Add support of the ESI Waveterminal 192M to the ice1724 ALSA d=
river

Cory T. Tusar (1):
      [ALSA] hda-codec - Dell Latitude D820 + D/Port

Dan Carpenter (1):
      [ALSA] atiixp - Add a parameter ac97_quirk

Daniel Jacobowitz (1):
      [ALSA] ac97 - Fix vt1617a build ops

Frank Mandarino (14):
      [ALSA] ASoC: core code
      [ALSA] ASoC AT91RM92000 audio DMA
      [ALSA] ASoC AT91RM92000 I2S support
      [ALSA] ASoC AT91RM92000 eti_b1 machine support
      [ALSA] ASoC AT91RM92000 build
      [ALSA] ASoC AT91 DAI modes update
      [ALSA] Update AT91 ASoC driver for 2.6.19 kernel.
      [ALSA] ASoC at91 - Fix NULL pointer dereference in at91_i2s_shutdown
      [ALSA] ASoC WM8731 support for 32k @ 12MHz sysclk
      [ALSA] soc - ASoC 0.13 WM8731 codec
      [ALSA] soc - ASoC 0.13 AT91xxxx slave patch
      [ALSA] soc - ASoC 0.13 AT91xxxx I2S
      [ALSA] soc - ASoC 0.13 AT91xxxx DMA
      [ALSA] soc - ASoC 0.13 AT91xxxx Eti_B1 board support

Giuliano Pochini (1):
      [ALSA] echoaudio, add TLV support

Graeme Gregory (1):
      [ALSA] soc - 0.13 ASoC headers

Gregor Jasny (1):
      [ALSA] usbaudio - Fix Oops with broken usb descriptors

Hubert Kahlert (1):
      [ALSA] Fix mask to stop AT91 SSC clock on shutdown

Jakub Schmidtke (1):
      [ALSA] hda-codec - Add ALC861VD/ALC660VD support

James C Georgas (1):
      [ALSA] Remove AC97 POP control for STAC9708/11

James Courtier-Dutton (10):
      [ALSA] snd-emu10k1: Added support for emu1010, including E-Mu 1212m a=
nd E-Mu 1820m
      [ALSA] snd_emu10k1: Added support for 14dB Attenuation PADS on DACs a=
nd ADCs.
      [ALSA] snd-emu10k1: Add emu1010 internal clock rate control for 44100=
 or 48000.
      [ALSA] snd-emu10k1: emu1010: replace long udelay with msleep.
      [ALSA] snd-emu10k1: Update Enum naming.
      [ALSA] snd-ca0106: Updated Enum control names.
      [ALSA] emu10k1: Add Audio capture support for Audigy 2 ZS Notebook.
      [ALSA] emu10k1: Rename the digital optical capture control for the Au=
digy 2 ZS
      [ALSA] ca0106: Fix sound capture on Audigy LS via AC97.
      [ALSA] emu10k1: Update registers defines for the Audigy 2/emu10k2.5

Jaroslav Kysela (4):
      [ALSA] hda_intel: increase maximum DMA buffer size to 1024MB
      [ALSA] pcm core: add prealloc_max file to substream directory to show=
 maximum DMA size
      [ALSA] hda-codec - add ASUS W7J (0x1043, 0x1205) to quirk list - 3sta=
ck
      [ALSA] version 1.0.14rc2

Jean Delvare (1):
      [ALSA] snd-ak4114: Fix two array overflows

Jerome Demange (1):
      [ALSA] ac97 - enables sound output through speakers on MSI S250 lapto=
p

Jochen Voss (2):
      [ALSA] Enable capture from line-in and CD on Revolution 5.1
      [ALSA] Enable the analog loopback of the Revolution 5.1

Johannes Berg (7):
      [ALSA] allow registering an alsa device with struct device pointer
      [ALSA] alsa core: add struct device pointer to struct snd_pcm
      [ALSA] aoa: set device pointer in pcms
      [ALSA] aoa: fix up i2sbus_attach_codec
      [ALSA] alsa core: convert to list_for_each_entry*
      [ALSA] snd-aoa: fix onyx resume
      [ALSA] aoa: remove suspend/resume printks

John Daiker (1):
      [ALSA] usbaudio.c: remove unneeded casts

Jonathan Woithe (1):
      [ALSA] hda-codec - Make internal speaker work on Acer C20x tablets

Joseph Chan (1):
      [ALSA] hda-codec - Add support for VIA VT1708(A) HD audio codec

Kailang Yang (2):
      [ALSA] hda-codec - Add new modesl for Realtek codecs
      [ALSA] hda-codec - Add HP BPC-D7000 support

Karsten Wiese (1):
      [ALSA] snd_hwdep_release() racefix

Krzysztof Helt (1):
      [ALSA] sparc dbri comment fix

Leonard Norrgard (1):
      [ALSA] sound: hda: detect ALC883 on MSI K9A Platinum motherboards (MS=
-7280)

Liam Girdwood (31):
      [ALSA] ASoC: Build files
      [ALSA] ASoC: documentation & maintainer
      [ALSA] ASoC pxa2xx DMA support
      [ALSA] ASoC pxa2xx I2S support
      [ALSA] ASoC pxa2xx AC97 support
      [ALSA] ASoC pxa2xx Corgi machine support
      [ALSA] ASoC pxa2xx Spitz machine support
      [ALSA] ASoC pxa2xx Tosa machine support
      [ALSA] ASoC pxa2xx Poodle machine support
      [ALSA] ASoC pxa2xx build support
      [ALSA] ASoC DAI capabilities labelling
      [ALSA] ASoC debug output build breakage
      [ALSA] ASoC - Fix build warnings in soc-core.c
      [ALSA] ASoC: Add support for BCLK based on (Rate * Chn * Word Size)
      [ALSA] ASoC - mixer name changes for older OSS app support
      [ALSA] Remove trailing white space from wm9712.c
      [ALSA] Additional credits to soc-core
      [ALSA] ASoC codec probe failure bug
      [ALSA] ASoC codec error reporting
      [ALSA] ASoC force running of delayed PM work at suspend() and remove(=
)
      [ALSA] ASoC very minor coding style fix for snd_soc_new_pcms()
      [ALSA] soc - ASoC 0.13 core changes
      [ALSA] soc - ASoC 0.13 WM8750 codec driver
      [ALSA] soc - ASoC 0.13 WM9712 codec driver
      [ALSA] soc - ASoC 0.13 generic AC97 codec
      [ALSA] soc - ASoC 0.13 pxa2xx AC97 driver
      [ALSA] soc - ASoC Sharp corgi machine
      [ALSA] soc - ASoC 0.13 spitz machine
      [ALSA] soc - ASoC 0.13 Sharp tosa machine
      [ALSA] soc - ASoC 0.13 Sharp poodle machine
      [ALSA] ASoC documentation updates

Mariusz Domanski (1):
      [ALSA] hda-codec - Add asus model to ALC861 codec

Mariusz Kozlowski (1):
      [ALSA] sound: aoa of_node_put and kfree cleanup

Martin Langer (1):
      [ALSA] ac97_bus power management

Matt Porter (2):
      [ALSA] hda: add dig mic support for sigmatel codecs
      [ALSA] hda: add sigmatel 9205 eapd support

Matthias Koenig (1):
      [ALSA] Add snd-portman2x4 driver for Midiman Portman 2x4 MIDI device

Nicolas Kaiser (1):
      [ALSA] Documentation/sound/alsa/DocBook: typos

Olaf Hering (2):
      [ALSA] create device symlink in snd-aoa
      [ALSA] create driver symlink in snd-aoa /sys/bus/aoa-soundbus/devices=
/*/

Oliver Neukum (1):
      [ALSA] cleanup and error reporting for sound/core/init.c

Paul Mackerras (1):
      [ALSA] aoa i2sbus: Stop Apple i2s DMA gracefully

Peter Eriksen (1):
      [ALSA] sound/isa/gus/gus_main.c: Use abs() instead of x < 0 ? -x : x.

Philipp Zabel (2):
      [ALSA] ASoC - Bit clock matching error
      [ALSA] soc - ASoC 0.13 pxa2xx i2s driver

Randy Cushman (3):
      [ALSA] ac97 - fix microphone and line_in selection logic
      [ALSA] ac97 - fix malfunctioning mixer controls for AD1985
      [ALSA] ac97 - fix various issues with AD1986/AD1986A support

Randy Dunlap (2):
      [ALSA] korg1212: fix printk format warning
      [ALSA] add struct snd_pcm_substream forward declaration

Ra=C3=BAl S=C3=A1nchez Siles (1):
      [ALSA] Solve typos/compilation problems for debug functions in soc-da=
pm and at91-i2s

Remy Bruno (3):
      [ALSA] hdsp: support for mixer matrix of RME9632 rev 152
      [ALSA] hdspm: Add support for AES32
      [ALSA] hdsp - Add DDS register support for RME9632 rev >=3D 152

Richard Purdie (7):
      [ALSA] ASoC: core and dapm headers
      [ALSA] ASoC: dynamic audio power management (DAPM)
      [ALSA] ASoC codecs: WM8731 support
      [ALSA] ASoC codecs: WM8750 support
      [ALSA] ASoC codecs: WM9712 support
      [ALSA] ASoC codecs: generic AC97 support
      [ALSA] ASoC codecs: build files

Robert P. J. Day (2):
      [ALSA] sound: Change final two instances of kcalloc(1,...) to kzalloc=
()
      [ALSA] Remove useless reference to obsolete KERNELD

Rolf Stefan Wilke (1):
      [ALSA] emu10k1 - Fix STAC9758 front channel

Seth Forshee (1):
      [ALSA] soc - 0.13 ASoC DAPM bug fix for unnamed streams

Takashi Iwai (50):
      [ALSA] emu10k1 - Fix compile warning
      [ALSA] intel8x0 - Use pci_iomap
      [ALSA] Fix irq handler in soc/at91/at91rm9200-i2s.c
      [ALSA] hda-codec - Add missing comma
      [ALSA] Remove trailing whitespaces from soc/* files
      [ALSA] ac97 - Suppress power-saving mode on non-supporting drivers
      [ALSA] hda-codec - Fix model for Lenovo A60 desktop
      [ALSA] hda-codec - Fix model for ASUS M2N-MX
      [ALSA] hdspm - Fix printk warnings
      [ALSA] ice1724 - Add support of M-Audio Audiophile 192
      [ALSA] hda-codec - Add support for Sony UX-90s
      [ALSA] hda-codec - Fix ALC861 connection of front-output
      [ALSA] hda-codec - Add model for ASUS W3j laptop
      [ALSA] hda-intel - Disable INTX when MSI is used
      [ALSA] hda-codec - Add asus-laptop model for ALC861 (ALC660)
      [ALSA] Remove obsolete typedefs.h
      [ALSA] Fix obsolete *_t typedefs
      [ALSA] Add PCI quirk list helper function
      [ALSA] atiixp - Use quirk list helper function
      [ALSA] nm256 - Use quirk list helper function
      [ALSA] maestro3 - Use quirk list helper function
      [ALSA] via82xx - Use quirk list helper function
      [ALSA] ens1371 - Clean up quirks
      [ALSA] intel8x0 - Add spdif_aclink option
      [ALSA] Fix documentation of ASoC
      [ALSA] Clean up serial-u16500.c
      [ALSA] hda-codec - Use snd_pci_quirk_lookup() for board config lookup
      [ALSA] hda-codec - Fix compile warnings without CONFIG_SND_DEBUG
      [ALSA] Add description about spdif_aclink option for snd-intel8x0
      [ALSA] Fix AC97_BUS in soc/pxa/Kconfig
      [ALSA] hda-codec - Use global workqueue
      [ALSA] ak4114 - Use global workqueue
      [ALSA] soc - Use global workqueue
      [ALSA] soc - Fix delayed_work related changes on 2.6.20 kernel
      [ALSA] Fix a typo in the last patch_realtek.c change
      [ALSA] Fix irq handler arguments in documents
      [ALSA] hda-intel - Don't try to probe invalid codecs
      [ALSA] emu10k1 - Fix ABI for older ld10k1
      [ALSA] ice1712 - Reorganize existing eeprom data
      [ALSA] Add 'const' to files in pci/ice1712/
      [ALSA] Add some more 'const', but needs changes in i2c/other/ak4*
      [ALSA] Add even more 'const' to everything related to TLV
      [ALSA] hda-codec - Add model for Uniwill X40AIx
      [ALSA] Remove delayed work properly at free and suspend
      [ALSA] usbaudio - Fix Oops with unconventional sample rates
      [ALSA] Fix possible invalid memory access in PCM core
      [ALSA] hda-intel - Add black/whitelist for position_fix option
      [ALSA] soc - Clean up with kmemdup()
      [ALSA] Fix possible deadlocks in sequencer at removal of ports
      [ALSA] ca0106 - Add missing sysfs device assignment

Teru KAMOGASHIRA (1):
      [ALSA] Current driver does not utilize 44.1kHz high quality sampling =
rate converter.

Thomas De Schampheleire (1):
      [ALSA] hda-codec - Missing Mic Boost on Realtek ALC882/883

Tobin Davis (15):
      [ALSA] hda-codec - Add support for Medion laptops
      [ALSA] hda-codec - Add toshiba model to ALC861 codec
      [ALSA] Add Conexant audio support to the HD Audio driver
      [ALSA] hda-codec - Change Gigabyte K8N51 from 6stack to 6stack-digout
      [ALSA] hda-codec - Add support for Evesham Voyager C530RD laptops
      [ALSA] hda-codec - Add missing array to conexant driver
      [ALSA] hda-codec (realtek): add support for MacPro series workstation=
s
      [ALSA] hda-codec - Add quirk for Turbo-X Coeus G610P
      [ALSA] Fix typo and add entry to documentation
      [ALSA] hda-codec - Add Asus P5W DH to alc882_cfg_tbl
      [ALSA] hda-codec - Change default config for Asus P5GD1
      [ALSA] hda-codec - Add support for Toshiba M105 to Realtek patch
      [ALSA] hda-codec - Add support for Sigmatel STAC9202/9250/9251 codecs
      [ALSA] hda-codec - Add support for Samsung Q1 Ultra
      [ALSA] hda-codec - Add support for Fujitsu PI1556 Realtek ALC880

Toshimune Konno (1):
      [ALSA] ice1724 - Add support for Prodigy 7.1 XT

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
---1463789724-479039958-1171029122=:5511--
