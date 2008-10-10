Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYJJMnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYJJMnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYJJMnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:43:16 -0400
Received: from mail1.perex.cz ([212.20.107.53]:59299 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbYJJMnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:43:14 -0400
X-Greylist: delayed 1851 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 08:43:13 EDT
Date: Fri, 10 Oct 2008 14:12:18 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0810101409490.14793@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1770839881-1223640738=:14793"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1770839881-1223640738=:14793
Content-Type: TEXT/PLAIN; charset=iso8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE


Linus, please pull from:

  git pull git://git.alsa-project.org/alsa-kernel.git for-linus

gitweb interface:

  http://git.alsa-project.org/?p=3Dalsa-kernel.git;a=3Dshortlog;h=3Dfor-lin=
us

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-for-linus-2008-10-=
10.patch.gz
 =20
The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt    |   62 +-
 .../sound/alsa/DocBook/writing-an-alsa-driver.tmpl |   62 +-
 MAINTAINERS                                        |    2 +
 arch/arm/plat-omap/include/mach/mtd-xip.h          |    2 +-
 arch/um/Kconfig.char                               |    4 +
 drivers/media/video/saa7134/saa7134-alsa.c         |   13 +-
 drivers/usb/host/ehci-ixp4xx.c                     |    2 +-
 include/sound/ad1848.h                             |  218 --
 include/sound/asound.h                             |   52 +-
 include/sound/asoundef.h                           |   89 +-
 include/sound/core.h                               |   32 +-
 include/sound/cs4231.h                             |  175 --
 include/sound/jack.h                               |   75 +
 include/sound/memalloc.h                           |   16 +-
 include/sound/minors.h                             |    2 +
 include/sound/pcm.h                                |   39 +-
 include/sound/pxa2xx-lib.h                         |   45 +
 include/sound/sb.h                                 |    5 +
 include/sound/snd_wavefront.h                      |    1 -
 include/sound/soc-of-simple.h                      |   25 +
 include/sound/soc.h                                |   74 +-
 include/sound/version.h                            |    2 +-
 include/sound/vx_core.h                            |    9 -
 include/sound/wss.h                                |  235 ++
 sound/Kconfig                                      |    5 +
 sound/aoa/codecs/snd-aoa-codec-tas.c               |    6 +-
 sound/arm/Kconfig                                  |    9 +
 sound/arm/Makefile                                 |    4 +
 sound/arm/aaci.c                                   |    6 +-
 sound/arm/pxa2xx-ac97-lib.c                        |  384 ++++
 sound/arm/pxa2xx-ac97.c                            |  247 +--
 sound/arm/pxa2xx-pcm-lib.c                         |  278 +++
 sound/arm/pxa2xx-pcm.c                             |  252 +--
 sound/arm/pxa2xx-pcm.h                             |   13 +-
 sound/arm/sa11xx-uda1341.c                         |    7 +-
 sound/core/Kconfig                                 |   10 +
 sound/core/Makefile                                |    1 +
 sound/core/control.c                               |   54 +-
 sound/core/control_compat.c                        |    3 +-
 sound/core/device.c                                |   26 +-
 sound/core/hwdep.c                                 |   16 +-
 sound/core/info.c                                  |   23 +-
 sound/core/info_oss.c                              |    6 +-
 sound/core/init.c                                  |    3 +-
 sound/core/jack.c                                  |  163 ++
 sound/core/memalloc.c                              |   56 +-
 sound/core/oss/copy.c                              |   30 +-
 sound/core/oss/io.c                                |   24 +-
 sound/core/oss/linear.c                            |   29 +-
 sound/core/oss/mixer_oss.c                         |   18 +-
 sound/core/oss/mulaw.c                             |   27 +-
 sound/core/oss/pcm_oss.c                           |   52 +-
 sound/core/oss/pcm_plugin.c                        |   38 +-
 sound/core/oss/rate.c                              |   42 +-
 sound/core/oss/route.c                             |   12 +-
 sound/core/pcm.c                                   |   84 +-
 sound/core/pcm_compat.c                            |    3 +-
 sound/core/pcm_lib.c                               |  102 +-
 sound/core/pcm_memory.c                            |   40 +-
 sound/core/pcm_native.c                            |  140 +-
 sound/core/pcm_timer.c                             |    6 +-
 sound/core/rawmidi.c                               |   25 +-
 sound/core/rtctimer.c                              |    6 +-
 sound/core/seq/oss/seq_oss.c                       |   12 +-
 sound/core/seq/oss/seq_oss_synth.c                 |    6 +-
 sound/core/seq/seq_clientmgr.c                     |   30 +-
 sound/core/seq/seq_compat.c                        |    3 +-
 sound/core/seq/seq_device.c                        |    6 +-
 sound/core/seq/seq_fifo.c                          |   15 +-
 sound/core/seq/seq_memory.c                        |   12 +-
 sound/core/seq/seq_midi.c                          |   15 +-
 sound/core/seq/seq_ports.c                         |   13 +-
 sound/core/seq/seq_prioq.c                         |    4 +-
 sound/core/seq/seq_queue.c                         |    6 +-
 sound/core/seq/seq_timer.c                         |   24 +-
 sound/core/sgbuf.c                                 |   62 +-
 sound/core/sound.c                                 |   14 +-
 sound/core/sound_oss.c                             |   12 +-
 sound/core/timer.c                                 |   33 +-
 sound/core/timer_compat.c                          |    9 +-
 sound/drivers/dummy.c                              |   41 +-
 sound/drivers/mtpav.c                              |    8 +-
 sound/drivers/opl3/opl3_lib.c                      |    6 +-
 sound/drivers/opl3/opl3_midi.c                     |    6 +-
 sound/drivers/opl3/opl3_oss.c                      |   15 +-
 sound/drivers/opl3/opl3_synth.c                    |    3 +-
 sound/drivers/opl4/opl4_synth.c                    |    2 +-
 sound/drivers/vx/vx_cmd.c                          |    3 +-
 sound/drivers/vx/vx_core.c                         |   21 +-
 sound/drivers/vx/vx_hwdep.c                        |    6 +-
 sound/drivers/vx/vx_mixer.c                        |    3 +-
 sound/drivers/vx/vx_pcm.c                          |    9 +-
 sound/drivers/vx/vx_uer.c                          |    6 +-
 sound/i2c/cs8427.c                                 |   15 +-
 sound/i2c/i2c.c                                    |    6 +-
 sound/i2c/l3/uda1341.c                             |    3 +-
 sound/i2c/other/ak4114.c                           |    3 +-
 sound/i2c/other/ak4117.c                           |    3 +-
 sound/i2c/other/ak4xxx-adda.c                      |    4 +-
 sound/isa/Kconfig                                  |   44 +-
 sound/isa/Makefile                                 |    2 +-
 sound/isa/ad1816a/ad1816a.c                        |    4 +-
 sound/isa/ad1816a/ad1816a_lib.c                    |    6 +-
 sound/isa/ad1848/Makefile                          |    2 -
 sound/isa/ad1848/ad1848.c                          |   17 +-
 sound/isa/ad1848/ad1848_lib.c                      | 1267 -----------
 sound/isa/azt2320.c                                |   29 +-
 sound/isa/cmi8330.c                                |  106 +-
 sound/isa/cs423x/Makefile                          |    2 -
 sound/isa/cs423x/cs4231.c                          |   18 +-
 sound/isa/cs423x/cs4231_lib.c                      | 1945 ----------------
 sound/isa/cs423x/cs4236.c                          |   51 +-
 sound/isa/cs423x/cs4236_lib.c                      |  349 ++--
 sound/isa/es1688/es1688_lib.c                      |    3 +-
 sound/isa/gus/gus_main.c                           |    6 +-
 sound/isa/gus/gus_mixer.c                          |    6 +-
 sound/isa/gus/gus_pcm.c                            |   12 +-
 sound/isa/gus/gusmax.c                             |   50 +-
 sound/isa/gus/interwave.c                          |   67 +-
 sound/isa/opl3sa2.c                                |   99 +-
 sound/isa/opti9xx/miro.c                           |   28 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |   70 +-
 sound/isa/sb/emu8000.c                             |    3 +-
 sound/isa/sb/emu8000_patch.c                       |    3 +-
 sound/isa/sb/sb16_csp.c                            |    9 +-
 sound/isa/sb/sb16_main.c                           |    3 +-
 sound/isa/sb/sb8_main.c                            |    8 +-
 sound/isa/sb/sb_common.c                           |    3 +-
 sound/isa/sb/sb_mixer.c                            |    9 +-
 sound/isa/sc6000.c                                 |   18 +-
 sound/isa/sgalaxy.c                                |   43 +-
 sound/isa/sscape.c                                 |   63 +-
 sound/isa/wavefront/wavefront.c                    |   62 +-
 sound/isa/wavefront/wavefront_fx.c                 |    8 +-
 sound/isa/wavefront/wavefront_midi.c               |   24 +-
 sound/isa/wavefront/wavefront_synth.c              |    7 +-
 sound/isa/wss/Makefile                             |   10 +
 sound/isa/wss/wss_lib.c                            | 2322 ++++++++++++++++=
++++
 sound/mips/au1x00.c                                |    6 +-
 sound/oss/Kconfig                                  |   35 -
 sound/oss/Makefile                                 |    1 -
 sound/oss/aedsp16.c                                |    8 -
 sound/oss/dmasound/Kconfig                         |    1 +
 sound/oss/hal2.c                                   | 1558 -------------
 sound/oss/hal2.h                                   |  248 ---
 sound/oss/mpu401.c                                 |    2 +-
 sound/parisc/harmony.c                             |    3 +-
 sound/pci/Kconfig                                  |   33 +-
 sound/pci/ac97/ac97_codec.c                        |   41 +-
 sound/pci/ac97/ac97_patch.c                        |  208 ++-
 sound/pci/ad1889.c                                 |    6 +-
 sound/pci/ak4531_codec.c                           |   10 +-
 sound/pci/als4000.c                                |  391 +++-
 sound/pci/atiixp.c                                 |   13 +-
 sound/pci/atiixp_modem.c                           |   10 +-
 sound/pci/au88x0/au88x0.h                          |    7 +-
 sound/pci/au88x0/au88x0_core.c                     |   40 +-
 sound/pci/au88x0/au88x0_pcm.c                      |   14 +-
 sound/pci/azt3328.c                                |    6 +-
 sound/pci/bt87x.c                                  |    5 +-
 sound/pci/ca0106/ca0106_main.c                     |    2 +-
 sound/pci/ca0106/ca_midi.c                         |   20 +-
 sound/pci/cmipci.c                                 |    9 +-
 sound/pci/cs4281.c                                 |   13 +-
 sound/pci/cs46xx/cs46xx_lib.c                      |   91 +-
 sound/pci/cs46xx/dsp_spos.c                        |   51 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |  115 +-
 sound/pci/echoaudio/darla20_dsp.c                  |    3 +-
 sound/pci/echoaudio/darla24_dsp.c                  |    8 +-
 sound/pci/echoaudio/echo3g_dsp.c                   |    9 +-
 sound/pci/echoaudio/echoaudio.c                    |   22 +-
 sound/pci/echoaudio/echoaudio_3g.c                 |   11 +-
 sound/pci/echoaudio/echoaudio_dsp.c                |   21 +-
 sound/pci/echoaudio/echoaudio_gml.c                |    6 +-
 sound/pci/echoaudio/gina20_dsp.c                   |    6 +-
 sound/pci/echoaudio/gina24_dsp.c                   |   11 +-
 sound/pci/echoaudio/indigo_dsp.c                   |    8 +-
 sound/pci/echoaudio/indigodj_dsp.c                 |    8 +-
 sound/pci/echoaudio/indigoio_dsp.c                 |    8 +-
 sound/pci/echoaudio/layla20_dsp.c                  |    9 +-
 sound/pci/echoaudio/layla24_dsp.c                  |   11 +-
 sound/pci/echoaudio/mia_dsp.c                      |   13 +-
 sound/pci/echoaudio/midi.c                         |    6 +-
 sound/pci/echoaudio/mona_dsp.c                     |    6 +-
 sound/pci/emu10k1/emu10k1_callback.c               |    6 +-
 sound/pci/emu10k1/emu10k1_patch.c                  |   23 +-
 sound/pci/emu10k1/emu10k1x.c                       |   18 +-
 sound/pci/emu10k1/emufx.c                          |    6 +-
 sound/pci/emu10k1/emumpu401.c                      |   18 +-
 sound/pci/emu10k1/memory.c                         |   31 +-
 sound/pci/emu10k1/voice.c                          |    9 +-
 sound/pci/es1938.c                                 |    3 +-
 sound/pci/es1968.c                                 |    6 +-
 sound/pci/hda/Makefile                             |    2 +
 sound/pci/hda/hda_beep.c                           |  134 ++
 sound/pci/hda/hda_beep.h                           |   44 +
 sound/pci/hda/hda_codec.c                          |  113 +-
 sound/pci/hda/hda_codec.h                          |   93 +-
 sound/pci/hda/hda_generic.c                        |    3 +-
 sound/pci/hda/hda_intel.c                          |  146 +-
 sound/pci/hda/hda_local.h                          |   24 +-
 sound/pci/hda/hda_patch.h                          |    2 +
 sound/pci/hda/hda_proc.c                           |   25 +-
 sound/pci/hda/patch_analog.c                       |   96 +-
 sound/pci/hda/patch_atihdmi.c                      |   45 +-
 sound/pci/hda/patch_nvhdmi.c                       |  164 ++
 sound/pci/hda/patch_realtek.c                      | 1816 ++++++++++++++--
 sound/pci/hda/patch_sigmatel.c                     |  958 ++++++++-
 sound/pci/hda/patch_via.c                          | 1407 ++++++++++++-
 sound/pci/ice1712/ak4xxx.c                         |    3 +-
 sound/pci/ice1712/aureon.c                         |  699 ++++---
 sound/pci/ice1712/delta.c                          |    2 +-
 sound/pci/ice1712/delta.h                          |    1 +
 sound/pci/ice1712/ews.c                            |    9 +-
 sound/pci/ice1712/ice1712.c                        |  240 ++-
 sound/pci/ice1712/ice1712.h                        |   52 +-
 sound/pci/ice1712/ice1724.c                        |  188 +-
 sound/pci/ice1712/juli.c                           |   47 +-
 sound/pci/ice1712/phase.c                          |  277 ++-
 sound/pci/ice1712/phase.h                          |    8 +-
 sound/pci/ice1712/pontis.c                         |    5 +-
 sound/pci/ice1712/revo.c                           |   25 +-
 sound/pci/ice1712/wtm.c                            |  104 +-
 sound/pci/ice1712/wtm.h                            |    4 +-
 sound/pci/intel8x0.c                               |   50 +-
 sound/pci/intel8x0m.c                              |    3 +-
 sound/pci/korg1212/korg1212.c                      |    9 +-
 sound/pci/maestro3.c                               |   10 +-
 sound/pci/mixart/mixart.c                          |    4 +-
 sound/pci/mixart/mixart_core.c                     |   18 +-
 sound/pci/mixart/mixart_hwdep.c                    |   19 +-
 sound/pci/mixart/mixart_mixer.c                    |    8 +-
 sound/pci/nm256/nm256.c                            |   15 +-
 sound/pci/oxygen/hifier.c                          |   15 +-
 sound/pci/oxygen/oxygen.c                          |   92 +-
 sound/pci/oxygen/oxygen.h                          |  103 +-
 sound/pci/oxygen/oxygen_io.c                       |   22 +
 sound/pci/oxygen/oxygen_lib.c                      |  101 +-
 sound/pci/oxygen/oxygen_mixer.c                    |   48 +-
 sound/pci/oxygen/oxygen_pcm.c                      |   47 +-
 sound/pci/oxygen/virtuoso.c                        |  594 ++++--
 sound/pci/pcxhr/pcxhr.c                            |    6 +-
 sound/pci/pcxhr/pcxhr_core.c                       |   27 +-
 sound/pci/pcxhr/pcxhr_hwdep.c                      |   15 +-
 sound/pci/riptide/riptide.c                        |   31 +-
 sound/pci/rme9652/hdsp.c                           |   25 +-
 sound/pci/rme9652/hdspm.c                          |   52 +-
 sound/pci/rme9652/rme9652.c                        |   23 +-
 sound/pci/sonicvibes.c                             |   10 +-
 sound/pci/trident/trident_main.c                   |   22 +-
 sound/pci/trident/trident_memory.c                 |   37 +-
 sound/pci/via82xx.c                                |   60 +-
 sound/pci/via82xx_modem.c                          |    8 +-
 sound/pci/vx222/vx222_ops.c                        |   12 +-
 sound/pci/ymfpci/ymfpci_main.c                     |   21 +-
 sound/pcmcia/vx/vxp_ops.c                          |    3 +-
 sound/ppc/awacs.c                                  |   23 +-
 sound/ppc/beep.c                                   |    6 +-
 sound/ppc/tumbler.c                                |   17 +-
 sound/sh/aica.c                                    |    9 +-
 sound/soc/Kconfig                                  |    2 +
 sound/soc/Makefile                                 |    2 +-
 sound/soc/at32/playpaq_wm8510.c                    |    7 +-
 sound/soc/at91/at91-ssc.c                          |    2 +-
 sound/soc/at91/eti_b1_wm8731.c                     |    1 +
 sound/soc/blackfin/Kconfig                         |   85 +
 sound/soc/blackfin/Makefile                        |   20 +
 sound/soc/blackfin/bf5xx-ac97-pcm.c                |  429 ++++
 sound/soc/blackfin/bf5xx-ac97-pcm.h                |   29 +
 sound/soc/blackfin/bf5xx-ac97.c                    |  407 ++++
 sound/soc/blackfin/bf5xx-ac97.h                    |   36 +
 sound/soc/blackfin/bf5xx-ad1980.c                  |  113 +
 sound/soc/blackfin/bf5xx-i2s-pcm.c                 |  288 +++
 sound/soc/blackfin/bf5xx-i2s-pcm.h                 |   29 +
 sound/soc/blackfin/bf5xx-i2s.c                     |  292 +++
 sound/soc/blackfin/bf5xx-i2s.h                     |   14 +
 sound/soc/blackfin/bf5xx-sport.c                   | 1032 +++++++++
 sound/soc/blackfin/bf5xx-sport.h                   |  192 ++
 sound/soc/blackfin/bf5xx-ssm2602.c                 |  186 ++
 sound/soc/codecs/Kconfig                           |   91 +-
 sound/soc/codecs/Makefile                          |   22 +-
 sound/soc/codecs/ad1980.c                          |  309 +++
 sound/soc/codecs/ad1980.h                          |   23 +
 sound/soc/codecs/ak4535.c                          |  116 +-
 sound/soc/codecs/ak4535.h                          |    1 +
 sound/soc/codecs/ssm2602.c                         |  776 +++++++
 sound/soc/codecs/ssm2602.h                         |  130 ++
 sound/soc/codecs/tlv320aic26.c                     |  520 +++++
 sound/soc/codecs/tlv320aic26.h                     |   96 +
 sound/soc/codecs/tlv320aic3x.c                     |  108 +-
 sound/soc/codecs/tlv320aic3x.h                     |    3 +-
 sound/soc/codecs/uda1380.c                         |  115 +-
 sound/soc/codecs/uda1380.h                         |    1 +
 sound/soc/codecs/wm8510.c                          |  112 +-
 sound/soc/codecs/wm8510.h                          |    1 +
 sound/soc/codecs/wm8580.c                          | 1055 +++++++++
 sound/soc/codecs/wm8580.h                          |   42 +
 sound/soc/codecs/wm8731.c                          |  178 +-
 sound/soc/codecs/wm8731.h                          |    2 +
 sound/soc/codecs/wm8750.c                          |  177 +-
 sound/soc/codecs/wm8750.h                          |    2 +
 sound/soc/codecs/wm8753.c                          |  106 +-
 sound/soc/codecs/wm8753.h                          |    1 +
 sound/soc/codecs/wm8900.c                          | 1542 +++++++++++++
 sound/soc/codecs/wm8900.h                          |   64 +
 sound/soc/codecs/wm8903.c                          | 1813 +++++++++++++++
 sound/soc/codecs/wm8903.h                          | 1463 ++++++++++++
 sound/soc/codecs/wm8971.c                          |  942 ++++++++
 sound/soc/codecs/wm8971.h                          |   64 +
 sound/soc/codecs/wm8990.c                          |  109 +-
 sound/soc/codecs/wm8990.h                          |    1 +
 sound/soc/codecs/wm9713.c                          |   34 +-
 sound/soc/davinci/davinci-evm.c                    |    3 +-
 sound/soc/davinci/davinci-i2s.c                    |    4 +-
 sound/soc/davinci/davinci-i2s.h                    |    2 +-
 sound/soc/davinci/davinci-pcm.c                    |    2 +-
 sound/soc/davinci/davinci-pcm.h                    |    2 +-
 sound/soc/fsl/Kconfig                              |   10 +
 sound/soc/fsl/Makefile                             |    5 +
 sound/soc/fsl/mpc5200_psc_i2s.c                    |  884 ++++++++
 sound/soc/fsl/mpc8610_hpcd.c                       |   26 +-
 sound/soc/fsl/soc-of-simple.c                      |  171 ++
 sound/soc/omap/n810.c                              |    1 +
 sound/soc/pxa/Kconfig                              |    3 +
 sound/soc/pxa/corgi.c                              |    1 +
 sound/soc/pxa/poodle.c                             |    1 +
 sound/soc/pxa/pxa2xx-ac97.c                        |  272 +---
 sound/soc/pxa/pxa2xx-i2s.c                         |   20 +-
 sound/soc/pxa/pxa2xx-pcm.c                         |  265 +---
 sound/soc/pxa/pxa2xx-pcm.h                         |   15 -
 sound/soc/pxa/spitz.c                              |    1 +
 sound/soc/s3c24xx/neo1973_wm8753.c                 |  120 +-
 sound/soc/soc-core.c                               |  138 +-
 sound/soc/soc-dapm.c                               |  127 +-
 sound/sound_core.c                                 |   79 +-
 sound/sparc/amd7930.c                              |   19 +-
 sound/sparc/cs4231.c                               |    3 +-
 sound/sparc/dbri.c                                 |   17 +-
 sound/synth/emux/emux.c                            |    8 +-
 sound/synth/emux/emux_nrpn.c                       |    8 +-
 sound/synth/emux/emux_oss.c                        |   42 +-
 sound/synth/emux/emux_seq.c                        |   15 +-
 sound/synth/emux/emux_synth.c                      |   47 +-
 sound/synth/util_mem.c                             |   10 +-
 sound/usb/Kconfig                                  |   12 +
 sound/usb/Makefile                                 |    1 +
 sound/usb/usbaudio.c                               |   46 +-
 sound/usb/usbaudio.h                               |    6 +-
 sound/usb/usbmidi.c                                |   48 +
 sound/usb/usbmixer.c                               |   19 +-
 sound/usb/usbquirks.h                              |   80 +-
 sound/usb/usx2y/Makefile                           |    2 +
 sound/usb/usx2y/us122l.c                           |  692 ++++++
 sound/usb/usx2y/us122l.h                           |   27 +
 sound/usb/usx2y/usb_stream.c                       |  761 +++++++
 sound/usb/usx2y/usb_stream.h                       |  112 +
 356 files changed, 28893 insertions(+), 10661 deletions(-)
 delete mode 100644 include/sound/ad1848.h
 delete mode 100644 include/sound/cs4231.h
 delete mode 100644 sound/isa/ad1848/ad1848_lib.c
 delete mode 100644 sound/isa/cs423x/cs4231_lib.c
 delete mode 100644 sound/oss/hal2.c
 delete mode 100644 sound/oss/hal2.h

Alan Horstmann (1):
      sound: ASoC: Fix WM8731 SPI write

Alexander Beregalov (9):
      ALSA: ice1724/revo: simple clean up
      ALSA: sound/pci/Kconfig: update for ice1712/24
      ALSA: sound/pci: supported cards update
      ALSA: ALSA-Configuration.txt: supported cards update
      ALSA: revo51: add headphone output
      ALSA: ice1712/aureon.c: fix coding style
      ALSA: ice1712/wtm: fix coding style
      ALSA: ice1724.c: fix coding style
      ALSA: ice1712.c: fix coding style

Andreas Mohr (2):
      ALSA: als4000 - Code clean up
      ALSA: ALS4000 driver work, step 2

Clemens Ladisch (18):
      ALSA: usb-audio: add BOSS GT-10 support
      ALSA: oxygen: use SPDIF channel status symbols
      ALSA: oxygen: use a copy of the model struct
      ALSA: oxygen: add probe callback
      ALSA: oxygen: remove X-Meridian magic number
      ALSA: oxygen: handle X-Meridian dynamically
      ALSA: virtuoso: handle D2X/DX dynamically
      ALSA: virtuoso: create common functions for GPIO bit switch controls
      ALSA: oxygen: rename pcm_dev_cfg
      ALSA: oxygen: configure MIDI via device_config
      ALSA: oxygen: add UART I/O functions
      ALSA: oxygen: add self-documenting functions
      ALSA: virtuoso: allow I2C-connected PCM1796
      ALSA: virtuoso: make number of PCM1796 DACs configurable
      ALSA: virtuoso: rename AC97 callback function
      ALSA: oxygen: rename first PCM device
      ALSA: virtuoso: add Xonar HDAV1.3 support
      ALSA: oxygen: wait for ACK when resetting UART

Cliff Cai (14):
      ALSA: ASoC: AD1980 audio codec driver
      ALSA: ASoC: Add SPI support for WM8731
      ALSA: add dummy function to support shared mmap in nommu Blackfin arc=
h
      ALSA: ASoC codec: fix compiling error in ad1980 driver after ASoC API=
 changed
      sound: ASoC codec: SSM2602 audio codec driver
      sound: ASoC: Blackfin: SPORT peripheral interface driver
      sound: ASoC: Blackfin: DMA Driver for AC97 sound chip
      sound: ASoC: Blackfin: AC97 Blackfin CPU DAI driver
      sound: ASoC: Blackfin: DMA Driver for I2S sound chip
      sound: ASoC: Blackfin: I2S CPU DAI driver
      sound: ASoC: Blackfin: board driver for AD1980/1 audio codec
      sound: ASoC: Blackfin: board driver for SSM2602 sound chip
      sound: ASoC: Blackfin: add Blackfin arch ASoC Kconfig and Makefile
      sound: ASoC: Blackfin: Include Blackfin architecture support in build

Clive Messer (1):
      ALSA: hda - Fix another ALC889A (rev 0x100101)

Daniel THOMPSON (1):
      sound: Fix esoteric double free in the dummy sound driver.

David Woodhouse (1):
      ALSA: hda - Add PCI subsystem ID for MacBookPro4,1

Dmitry Baryshkov (5):
      ALSA: ASoC: Permit simultaneous compilation of both PXA AC97 drivers
      sound: ASoC: Support runtime selection of CPU in pxa2xx-i2s
      ALSA: Separate common pxa2xx-ac97 code
      ALSA: pxa2xx-ac97-lib: support building for several CPUs
      ALSA: Separate common pxa2xx-pcm code

Eran Tromer (1):
      ALSA: usb-audio: add support for E-Mu Tracker Pre

Grant Likely (3):
      ALSA: ASoC: Add OpenFirmware helper for matching bus and codec driver=
s
      ALSA: ASoC: Add mpc5200-psc I2S driver
      ALSA: ASoC: Add Texas Instruments TLV320AIC26 codec driver

Harald Welte (10):
      ALSA: HDA patch_via.c: cleanup
      ALSA: HDA patch_via.c: HP and CD pin connect config
      ALSA: HDA patch_via.c: Fix inversion of surround and side channels
      ALSA: HDA patch_via.c: Add VT1708S and VT1702 support
      ALSA: HDA patch_via.c: Mute on headphone plug-in
      ALSA: HDA patch_via.c: Independent DAC for headphone
      ALSA: HDA patch_via.c: Second S/PDIF (HDMI) support
      ALSA: HDA VIA: Fix crash on codecs without Headphone
      ALSA: HDA VIA: Fix 2nd S/PDIF out function
      ALSA: HDA VIA: Replace buggy Mic Boost

Harvey Harrison (1):
      ALSA: ac97_patch make functions static

Herton Ronaldo Krzesinski (4):
      ALSA: hda: fix oopses in snd-hda-intel after digital slave support ad=
ditions
      ALSA: hda - Fix ALC662 DAC mixer mutes also for auto config model
      ALSA: hda - Map ALC662 model for Gigabyte 945GCM-S2L
      ALSA: hda - Map ALC662 model for Foxconn 45CMX/45GMX/45CMX-K

Hiroshi Miura (1):
      ALSA: hda - Add support of Toshiba RX1

Ilpo J=E4rvinen (1):
      mpu401: reindent misindented spinlock

Jaroslav Kysela (8):
      ALSA: Fix commit: Add automatic model setting for the Acer Aspire 592=
0G laptop
      sound: Revert "ALSA: Fix limit of 8 PCM devices in SNDRV_CTL_IOCTL_PC=
M_NEXT_DEVICE"
      ALSA: hda - put all HDA codec IDs to components for precise hw detect=
ion
      ALSA: dummy driver - do not use assignment in if condition
      ALSA: release v1.0.18rc1
      ALSA: Cosmetic change: CA0106 on MSI K8N Diamond PLUS Motherboard
      ALSA: intel8x0: implement ac97_clock whitelist
      ALSA: Release v1.0.18rc3

Jean Delvare (11):
      ALSA: ASoC: Add missing new-line at end of strings
      ALSA: ASoC: Convert uda1380 to a new-style i2c driver
      ALSA: ASoC: Convert ak4535 to a new-style i2c driver
      ALSA: ASoC: Convert wm8750 to a new-style i2c driver
      ALSA: ASoC: Convert wm8731 to a new-style i2c driver
      ALSA: ASoC: Convert wm8990 to a new-style i2c driver
      sound: ASoC: Fix an error path in neo1973_wm8753
      sound: ASoC: Convert wm8753 to a new-style i2c driver
      sound: ASoC: Convert neo1973/lm4857 to a new-style i2c driver
      sound: ASoC: Convert wm8510 to a new-style i2c driver
      ALSA: ASoC: Convert tlv320aic3x to a new-style i2c driver (v2)

John L. Utz III (1):
      ALSA: ac97 - vt1618 7.1 Audio Support

Jon Smirl (3):
      ALSA: ASoC: Convert bitfields in ASoC into full int width
      ALSA: ASoC: Rename mask to max to reflect usage
      ALSA: ASoC: convert use of uint to unsigned int

Joseph Chan (1):
      ALSA: hda - Fix VIA recording problem

Julien Brunel (1):
      ALSA: sound/soc/at32: Useless NULL test

Kailang Yang (7):
      ALSA: hda - fix spaces in patch_realtek.c
      ALSA: hda - Add support of HP DC7600
      ALSA: hda - Add support of Toshiba S06
      ALSA: hda - Add support of Acer Aspire One
      ALSA: hda - Add support of Quanta FL1
      ALSA: hda - support more ALC888 devices
      ALSA: hda - Add more ALC662/663 codec support

Karsten Wiese (1):
      ALSA: Add USB US122L driver

Kenneth Kiraly (1):
      sound: ASoC: Add WM8971 CODEC driver

Krzysztof Helt (17):
      ALSA: wss_lib: move cs4231_lib into wss_lib
      ALSA: wss_lib: rename cs4231.h into wss.h
      ALSA: wss_lib: rename cs4321_foo to wss_foo
      ALSA: wss_lib: use struct snd_wss instead of snd_ad1848
      ALSA: wss_lib: use wss constants instead of ad1848 ones
      ALSA: wss_lib: replace ad1848 mixer element macros with wss ones
      ALSA: wss_lib: use CS4231P instead of AD1848P (kill the AD1848P)
      ALSA: wss_lib: use wss mixer code instead of ad1848 one
      ALSA: wss_lib: use wss pcm code instead of ad1848 one
      ALSA: wss_lib: use wss detection code instead of ad1848 one
      ALSA: wss_lib: fix opti93x capture formats limitations
      ALSA: wss_lib: remove second mutexes initialization
      ALSA: opl3sa2: drop snd_card pointer from the snd_opl3sa2 structure
      ALSA: wss_lib: snd_wss_calibrate_mute improvement
      ALSA: opl3sa2: replace nd_opl3sa2_info_xxx() with snd_wss_info_xxx()
      ALSA: wss_lib: do not mess mixer settings during probe
      ALSA: fix section mismatch in the sound_core

Mark Brown (22):
      ALSA: Add jack reporting API
      ALSA: Build jack detection
      ALSA: ASoC: Allow codecs to override register display
      ALSA: ASoC: Make OpenFirmware helper include file conditional
      ALSA: ASoC: Export DAI and codec for TLV320AIC26
      ALSA: ASoC: Staticise keyclick dev_attr in tlv320aic26
      ALSA: ASoC: Add all CODECs Kconfig option
      ALSA: ASoC: Add WM8900 CODEC driver
      ALSA: ASoC: Add WM8580 CODEC driver
      ALSA: ASoC: Add WM8903 CODEC driver
      ALSA: ASoC: WM8903 I2C cleanups
      ALSA: ASoC: Convert DAPM pop time configuration to debugfs
      ALSA: ASoC: Make all codecs depend on rather than selecting I2C
      ALSA: ASoC: Don't suggest compile time selection of codec access
      ALSA: ASoC: Fix indentation in WM9713
      ALSA: ASoC: Sort Kconfig and Makefile entries for codecs
      ALSA: ASoC: Use codec digital mute when stopping playback
      sound: ASoC: Fix dependency on AC97_BUS
      sound: ASoC: DAPM support for ADC on WM9713 PCM interface
      sound: ASoC: Add WM8750 SPI support
      ALSA: ASoC: Correct inverted Mic PGA Switch control in wm8510 driver
      ALSA: ASoC: Check for machine type in GTA01 machine driver

Matthew Ranostay (22):
      ALSA: hda: digital pc-beep support hd-audio codecs
      ALSA: hda: added 92HD81/83 support
      ALSA: hda: dynamically create capture mux controls
      ALSA: hda: 92HD75xx fixes
      ALSA: hda: SPDIF mux controls
      ALSA: hda: removed unneeded hp_nid references
      ALSA: hda: slave digital out support
      ALSA: hda: digital slave support for IDT codecs
      ALSA: hda: SPDIF mux name change
      ALSA: hda - add missing slave_dig_outs for 92HD73bxx
      ALSA: hda: Added a STAC_HP_M4 quirk
      ALSA: hda: Input port AMP controls
      ALSA: hda: fixed hp_nid DAC for DELL_M6
      ALSA: hda: 92hd73xx fixes
      ALSA: hda: SPDIF mux fixes for STAC927x
      ALSA: hda: use last DAC defined for hp_pin
      ALSA: hda: slave_dig_outs code block in wrong location
      ALSA: hda: 92xx S/PDIF In support
      ALSA: hda: HP laptop quirk
      ALSA: hda: SPDIF stream muting support
      ALSA: hda: STAC_HP_M4
      ALSA: hda: VREF powerdown for headphones

Mauro Carvalho Chehab (1):
      ALSA: hda: Add support for ECS/PC Chips boards with Sigmatel codecs

Maximilian Rehkopf (1):
      ALSA: ice1724: enable MIDI on Terratec Aureon 7.1 Universe

Michael Kerrisk (1):
      ALSA: Documentation/sound/alsa/ALSA-Configuration.txt: fix typo

Misha Zhilin (1):
      ALSA: ice1724 - Support for Terrasoniq/MUSONIK TS22 PCI card

Pascal Terjan (1):
      ALSA: hda - Fix sound on NEC Versa S9100

Pawel MOLL (3):
      ALSA: Fix limit of 8 PCM devices in SNDRV_CTL_IOCTL_PCM_NEXT_DEVICE
      ALSA: IEC958 definition for consumer status channel update
      ALSA: Fix limit of 8 PCM devices in SNDRV_CTL_IOCTL_PCM_NEXT_DEVICE

Pedro Lopez-Cabanillas (2):
      ALSA: snd-usb-audio: support for Edirol UA-4FX device
      ALSA: usb-audio: dynamic detection of MIDI interfaces in uaxx-quirk

Peter Korsgaard (1):
      ALSA: hda: appletv support

Phillip Michael Jordan (1):
      ALSA: snd_usb_audio: fix SB Extigy IR Remote regression

Randy Dunlap (1):
      ALSA: us122l - Add missing dependency on CONFIG_SND_HWDEP

Rene Herman (7):
      ALSA: re-order AC97 codec ID table.
      ALSA: wss_lib: opti92x-ad1848 WSS_HW_DETECT fix
      ALSA: snd-cs4236: add Techmakers MF-4236PW PnP card ID
      ALSA: wss_lib: fix AZT2320 probe.
      ALSA: wss_lib: rework snd_ad1848_probe()
      ALSA: wss_lib: missing closing brace in (ifdeffed out) debug function=
=2E
      ALSA: snd-ad1816a: add different TerraTec EWS64 S model

Richard Zhao (1):
      ALSA: ASoC: add new param mux to dapm_mux_update_power

Robert P. J. Day (1):
      sound: remove reference to dead sound OSS vars AEDSP16_MSS and SBPRO

Robin H. Johnson (5):
      ALSA: HDA: patch_analog: Fix SPDIF output on AD1989B
      ALSA: HDA: hda_local: Less magic numbers.
      ALSA: HDA: hda_proc: Fix printf format specifier
      ALSA: HDA: patch_analog: Implement multiple outputs for AD1988
      ALSA: HDA: patch_analog: Quirk for Asus P5Q Premium/Pro boards.

Roel Kluin (1):
      ALSA: aoa - Remove duplicate assignment of SNDRV_PCM_FMTBIT_S{16,24}_=
BE bits

Takashi Iwai (46):
      ALSA: hda - use input_free_device()
      ALSA: ac97 - Enable mono-out on ALC203 codec as default
      ALSA: Introduce snd_BUG_ON() macro
      ALSA: Kill snd_assert() in sound/core/*
      ALSA: Kill snd_assert() in sound/isa/*
      ALSA: Kill snd_assert() in sound/pci/*
      ALSA: Kill snd_assert() in other places
      ALSA: Kill snd_assert() definition
      ALSA: Clean up snd_BUG()
      ALSA: hda - Don't reset SPDIF in each status change
      ALSA: hda - initialize node 0x21 properly on AD1988 codecs
      ALSA: Add missing description of usb-audio parameters
      ALSA: usb-audio - Add ignore_ctl_error parameter
      ALSA: fix a typo during snd_assert() removal
      ALSA: hda - Add definitions of HDMI-related verbs
      ALSA: hda - print a few HDMI information in proc
      ALSA: hda - set up HDMI channels
      ALSA: hda - Add AD1882A codec support
      ALSA: hda - disable delayed period-ack with bdl_pos_adj=3D0
      ALSA: Update MAINTAINERS
      ALSA: hda - Create beep control on ALC269 codec
      ALSA: Clean up SG-buffer helper functions and macros
      ALSA: Fix allocation size calculation in snd_dma_alloc_pages_fallback=
()
      ALSA: Allocate larger pages in sgbuf
      ALSA: hda - check page continuity
      ALSA: via82xx - ignore buffer preallocation errors
      ALSA: via82xx - check continuous pages in buffer setup
      ALSA: hda - Fix ALC269 capture source
      ALSA: hda - Add descriptions of missing model values
      ALSA: remove obsolete *_FIRMARE_IN_KERNEL in isa/Kconfig
      ALSA: ice1724 - limit channels for multi-channel playback
      ALSA: atiixp - Add PCI ID for SB600 (1002:4382)
      ALSA: intel8x0 - use snd_pci_quirk for clock list
      ALSA: aaci - Fix NULL test at error path
      ALSA: harmony - fix a typo
      ALSA: hda - allow probing of 4 codecs
      ALSA: remove stale files
      ALSA: use correct lock in snd_ctl_dev_disconnect()
      ALSA: Remove bitwise from snd_pcm_hw_param_t
      ALSA: intel8x0 - Add quirk for Fujitsu Lifebook P7010
      ALSA: hda - Fix / clean-up slave digital out codes
      ALSA: usb - Fix possible Oops at USB-MIDI disconnection
      ALSA: hda - Fix PCI SSID for ASROCK K18N78FullHD-hSLI
      ALSA: Increase components array size
      ALSA: Add a note on dependency of RTC stuff
      ALSA: mtpav - Fix race in probe

Tejun Heo (1):
      sound: make OSS sound core optional

Thomas Bogendoerfer (1):
      sound: oss: remove driver for SGI HAL2 audio device

Timur Tabi (1):
      ALSA: ASoC - fix DMA channel selection in Freescale MPC8610 sound dri=
vers

Travis Place (1):
      ALSA: hda - Add model for Toshiba L305 laptop

Uwe Kleine-K=F6nig (2):
      ALSA: fix section for sa11xx-uda1341 platform driver
      ALSA: Fix section for snd-aica platform driver

Vedran Miletic (4):
      ALSA: ice1724: Enable MIDI on TerraTec PHASE 22 and PHASE 28
      ALSA: ice1712/ice1724: Coding style fixes part 1 (more coming up)
      ALSA: cs46xx: Add PCI IDs for TerraTec and Hercules cards
      ALSA: hda: add more board-specific information for Realtek ALC662 rev=
1

Vladimir Barinov (1):
      ALSA: Correct Vladimir Barinov's e-mail address

Wei Ni (2):
      ALSA: Support NVIDIA MCP78/7A HDMI audio
      ALSA: Fix for reading RIRB buffer on NVIDIA aza controller with AMD P=
henom cpu

Wu Fengguang (2):
      ALSA: hda: comment typo fix
      ALSA: hda: comment typo fix

roel kluin (1):
      ALSA: au88x0: clipping ceiling loop wrong in comment

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.
--8323584-1770839881-1223640738=:14793--
