Return-Path: <linux-kernel-owner+w=401wt.eu-S934467AbXJPPcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467AbXJPPcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933439AbXJPPbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:31:51 -0400
Received: from mail1.perex.cz ([212.20.107.53]:35042 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbXJPPbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:31:48 -0400
X-Greylist: delayed 1371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 11:31:47 EDT
Date: Tue, 16 Oct 2007 17:08:54 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0710161659173.11118@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-10-16.patch.gz

The following files will be updated:

 CREDITS                                            |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt    |  115 ++-
 Documentation/sound/alsa/CMIPCI.txt                |   17 +-
 .../sound/alsa/DocBook/writing-an-alsa-driver.tmpl |  184 ++-
 Documentation/sound/alsa/OSS-Emulation.txt         |    7 -
 Documentation/sound/alsa/hda_codec.txt             |   49 +-
 Documentation/sound/alsa/powersave.txt             |   41 +
 MAINTAINERS                                        |    6 +-
 drivers/media/video/cx88/cx88-alsa.c               |    2 +-
 drivers/net/hp100.c                                |    4 +-
 drivers/pnp/interface.c                            |    2 +-
 drivers/pnp/isapnp/core.c                          |    4 +-
 drivers/pnp/isapnp/proc.c                          |    2 +-
 drivers/pnp/manager.c                              |    2 +-
 drivers/pnp/resource.c                             |    2 +-
 include/linux/i2c-id.h                             |    1 +
 include/linux/spi/at73c213.h                       |   25 +
 include/sound/ac97_codec.h                         |    8 +-
 include/sound/ad1848.h                             |    5 +-
 include/sound/ainstr_gf1.h                         |    2 +-
 include/sound/ainstr_iw.h                          |    2 +-
 include/sound/ainstr_simple.h                      |    2 +-
 include/sound/ak4114.h                             |    2 +-
 include/sound/ak4117.h                             |    2 +-
 include/sound/ak4531_codec.h                       |    2 +-
 include/sound/ak4xxx-adda.h                        |    2 +-
 include/sound/asequencer.h                         |    2 +-
 include/sound/asound.h                             |    3 +-
 include/sound/asound_fm.h                          |    2 +-
 include/sound/asoundef.h                           |    2 +-
 include/sound/control.h                            |   10 +-
 include/sound/core.h                               |    2 +-
 include/sound/cs4231-regs.h                        |  180 ++
 include/sound/cs4231.h                             |  159 +--
 include/sound/cs46xx.h                             |    2 +-
 include/sound/cs46xx_dsp_scb_types.h               |    2 +-
 include/sound/cs46xx_dsp_spos.h                    |    2 +-
 include/sound/cs46xx_dsp_task_types.h              |    2 +-
 include/sound/cs8403.h                             |    2 +-
 include/sound/cs8427.h                             |    2 +-
 include/sound/driver.h                             |    2 +-
 include/sound/emu10k1.h                            |   15 +-
 include/sound/es1688.h                             |    2 +-
 include/sound/gus.h                                |    2 +-
 include/sound/hda_hwdep.h                          |   44 +
 include/sound/hdspm.h                              |   16 +-
 include/sound/hwdep.h                              |    2 +-
 include/sound/info.h                               |    2 +-
 include/sound/initval.h                            |    2 +-
 include/sound/memalloc.h                           |    2 +-
 include/sound/mixer_oss.h                          |    2 +-
 include/sound/mpu401.h                             |    3 +-
 include/sound/opl3.h                               |    2 +-
 include/sound/pcm-indirect.h                       |    2 +-
 include/sound/pcm.h                                |   13 +-
 include/sound/pcm_oss.h                            |    2 +-
 include/sound/rawmidi.h                            |    2 +-
 include/sound/sb.h                                 |    2 +-
 include/sound/seq_instr.h                          |    2 +-
 include/sound/seq_midi_event.h                     |    2 +-
 include/sound/seq_virmidi.h                        |    2 +-
 include/sound/soc.h                                |    3 +-
 include/sound/tea575x-tuner.h                      |    2 +-
 include/sound/timer.h                              |    2 +-
 include/sound/tlv.h                                |    2 +-
 include/sound/version.h                            |    4 +-
 include/sound/ymfpci.h                             |    2 +-
 sound/Kconfig                                      |    4 +
 sound/Makefile                                     |    3 +-
 sound/aoa/codecs/snd-aoa-codec-onyx.c              |   20 +-
 sound/aoa/codecs/snd-aoa-codec-tas.c               |   29 +-
 sound/aoa/fabrics/snd-aoa-fabric-layout.c          |   10 +-
 sound/arm/sa11xx-uda1341.c                         |   35 +-
 sound/core/Makefile                                |   15 +-
 sound/core/control.c                               |   33 +-
 sound/core/device.c                                |    2 +-
 sound/core/hwdep.c                                 |    4 +-
 sound/core/info.c                                  |    2 +-
 sound/core/info_oss.c                              |    2 +-
 sound/core/init.c                                  |    2 +-
 sound/core/isadma.c                                |    2 +-
 sound/core/memalloc.c                              |   10 +-
 sound/core/memory.c                                |    2 +-
 sound/core/misc.c                                  |    2 +-
 sound/core/oss/Makefile                            |    7 +-
 sound/core/oss/copy.c                              |    5 -
 sound/core/oss/io.c                                |    7 +-
 sound/core/oss/linear.c                            |   91 +-
 sound/core/oss/mixer_oss.c                         |    4 +-
 sound/core/oss/mulaw.c                             |   90 +-
 sound/core/oss/pcm_oss.c                           |   39 +-
 sound/core/oss/pcm_plugin.c                        |   63 +-
 sound/core/oss/pcm_plugin.h                        |    2 +-
 sound/core/oss/plugin_ops.h                        |  370 ----
 sound/core/oss/rate.c                              |    7 +-
 sound/core/oss/route.c                             |    5 -
 sound/core/pcm.c                                   |    4 +-
 sound/core/pcm_lib.c                               |    2 +-
 sound/core/pcm_memory.c                            |    2 +-
 sound/core/pcm_misc.c                              |   65 +-
 sound/core/pcm_native.c                            |   10 +-
 sound/core/pcm_timer.c                             |    2 +-
 sound/core/rawmidi.c                               |    5 +-
 sound/core/seq/Makefile                            |    2 +-
 sound/core/seq/instr/Makefile                      |    2 +-
 sound/core/seq/instr/ainstr_gf1.c                  |    4 +-
 sound/core/seq/instr/ainstr_iw.c                   |    4 +-
 sound/core/seq/instr/ainstr_simple.c               |    4 +-
 sound/core/seq/oss/Makefile                        |    2 +-
 sound/core/seq/oss/seq_oss_init.c                  |   40 +-
 sound/core/seq/oss/seq_oss_writeq.c                |    6 +-
 sound/core/seq/seq.c                               |    2 +-
 sound/core/seq/seq_clientmgr.c                     |    2 +-
 sound/core/seq/seq_instr.c                         |   14 +-
 sound/core/seq/seq_memory.c                        |    2 +-
 sound/core/seq/seq_midi.c                          |    4 +-
 sound/core/seq/seq_midi_event.c                    |  101 +-
 sound/core/seq/seq_ports.c                         |    2 +-
 sound/core/seq/seq_timer.c                         |    2 +-
 sound/core/sound.c                                 |   12 +-
 sound/core/sound_oss.c                             |    2 +-
 sound/core/timer.c                                 |    4 +-
 sound/drivers/Makefile                             |    2 +-
 sound/drivers/dummy.c                              |   14 +-
 sound/drivers/mpu401/Makefile                      |    2 +-
 sound/drivers/mpu401/mpu401.c                      |   10 +-
 sound/drivers/mpu401/mpu401_uart.c                 |    7 +-
 sound/drivers/mts64.c                              |   10 +-
 sound/drivers/opl3/Makefile                        |    8 +-
 sound/drivers/opl3/opl3_lib.c                      |    4 +-
 sound/drivers/opl4/Makefile                        |    2 +-
 sound/drivers/serial-u16550.c                      |    2 +-
 sound/drivers/vx/Makefile                          |    2 +-
 sound/drivers/vx/vx_mixer.c                        |   18 +-
 sound/i2c/Makefile                                 |    6 +-
 sound/i2c/cs8427.c                                 |   10 +-
 sound/i2c/i2c.c                                    |    4 +-
 sound/i2c/other/Makefile                           |    2 +-
 sound/i2c/other/ak4114.c                           |   14 +-
 sound/i2c/other/ak4117.c                           |   14 +-
 sound/i2c/other/ak4xxx-adda.c                      |   14 +-
 sound/i2c/other/pt2258.c                           |   10 +-
 sound/i2c/other/tea575x-tuner.c                    |    4 +-
 sound/i2c/tea6330t.c                               |   14 +-
 sound/isa/Kconfig                                  |   22 +-
 sound/isa/Makefile                                 |    4 +-
 sound/isa/ad1816a/Makefile                         |    2 +-
 sound/isa/ad1816a/ad1816a_lib.c                    |    2 -
 sound/isa/ad1848/Makefile                          |    9 +-
 sound/isa/ad1848/ad1848.c                          |    6 +-
 sound/isa/ad1848/ad1848_lib.c                      |  140 +-
 sound/isa/cs423x/Makefile                          |   19 +-
 sound/isa/cs423x/cs4231.c                          |    4 +-
 sound/isa/cs423x/cs4231_lib.c                      |  115 +-
 sound/isa/cs423x/cs4236.c                          |    4 +-
 sound/isa/cs423x/cs4236_lib.c                      |    4 +-
 sound/isa/es1688/Makefile                          |    2 +-
 sound/isa/es1688/es1688.c                          |    4 +-
 sound/isa/es1688/es1688_lib.c                      |    4 +-
 sound/isa/es18xx.c                                 |   19 +-
 sound/isa/gus/Makefile                             |    2 +-
 sound/isa/gus/gus_dma.c                            |    2 +-
 sound/isa/gus/gus_dram.c                           |    2 +-
 sound/isa/gus/gus_instr.c                          |    2 +-
 sound/isa/gus/gus_io.c                             |    2 +-
 sound/isa/gus/gus_irq.c                            |   20 +-
 sound/isa/gus/gus_main.c                           |   22 +-
 sound/isa/gus/gus_mem.c                            |    2 +-
 sound/isa/gus/gus_mem_proc.c                       |    2 +-
 sound/isa/gus/gus_mixer.c                          |   11 +-
 sound/isa/gus/gus_pcm.c                            |    2 +-
 sound/isa/gus/gus_reset.c                          |    2 +-
 sound/isa/gus/gus_sample.c                         |    2 +-
 sound/isa/gus/gus_simple.c                         |    2 +-
 sound/isa/gus/gus_synth.c                          |    4 +-
 sound/isa/gus/gus_tables.h                         |    2 +-
 sound/isa/gus/gus_timer.c                          |    2 +-
 sound/isa/gus/gus_uart.c                           |    2 +-
 sound/isa/gus/gus_volume.c                         |    2 +-
 sound/isa/gus/gusclassic.c                         |    4 +-
 sound/isa/gus/gusextreme.c                         |    4 +-
 sound/isa/gus/gusmax.c                             |    4 +-
 sound/isa/gus/interwave.c                          |    4 +-
 sound/isa/opl3sa2.c                                |    5 +-
 sound/isa/opti9xx/Makefile                         |    2 +-
 sound/isa/opti9xx/miro.c                           |   18 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |   14 +-
 sound/isa/sb/Makefile                              |    2 +-
 sound/isa/sb/emu8000.c                             |    2 +-
 sound/isa/sb/emu8000_synth.c                       |    2 +-
 sound/isa/sb/sb16.c                                |    4 +-
 sound/isa/sb/sb16_csp.c                            |    9 +-
 sound/isa/sb/sb16_main.c                           |    4 +-
 sound/isa/sb/sb8.c                                 |    4 +-
 sound/isa/sb/sb8_main.c                            |    4 +-
 sound/isa/sb/sb8_midi.c                            |    2 +-
 sound/isa/sb/sb_common.c                           |    8 +-
 sound/isa/sb/sb_mixer.c                            |    2 +-
 sound/isa/sc6000.c                                 |  656 +++++++
 sound/isa/sscape.c                                 |  354 +++--
 sound/isa/wavefront/Makefile                       |    2 +-
 sound/isa/wavefront/wavefront_synth.c              |  130 +-
 sound/last.c                                       |    2 +-
 sound/pci/Kconfig                                  |  111 ++-
 sound/pci/Makefile                                 |    2 +-
 sound/pci/ac97/Makefile                            |    2 +-
 sound/pci/ac97/ac97_codec.c                        |   40 +-
 sound/pci/ac97/ac97_id.h                           |    3 +-
 sound/pci/ac97/ac97_local.h                        |    2 +-
 sound/pci/ac97/ac97_patch.c                        |  162 ++-
 sound/pci/ac97/ac97_patch.h                        |    2 +-
 sound/pci/ac97/ac97_pcm.c                          |    2 +-
 sound/pci/ac97/ac97_proc.c                         |   10 +-
 sound/pci/ac97/ak4531_codec.c                      |    4 +-
 sound/pci/ali5451/Makefile                         |    2 +-
 sound/pci/ali5451/ali5451.c                        |   10 +-
 sound/pci/als4000.c                                |    2 +-
 sound/pci/au88x0/au88x0.c                          |    1 +
 sound/pci/au88x0/au88x0_eq.c                       |   10 +-
 sound/pci/au88x0/au88x0_mpu401.c                   |    2 +-
 sound/pci/au88x0/au88x0_synth.c                    |    4 +-
 sound/pci/bt87x.c                                  |  217 ++-
 sound/pci/ca0106/ca0106.h                          |   98 +-
 sound/pci/ca0106/ca0106_main.c                     |  103 +-
 sound/pci/ca0106/ca0106_mixer.c                    |   98 +-
 sound/pci/ca0106/ca_midi.c                         |    2 +-
 sound/pci/ca0106/ca_midi.h                         |    6 +-
 sound/pci/cmipci.c                                 |  537 ++++--
 sound/pci/cs4281.c                                 |   28 +-
 sound/pci/cs46xx/Makefile                          |    8 +-
 sound/pci/cs46xx/cs46xx.c                          |    4 +-
 sound/pci/cs46xx/cs46xx_lib.c                      |   12 +-
 sound/pci/cs46xx/cs46xx_lib.h                      |    2 +-
 sound/pci/cs46xx/dsp_spos.h                        |    2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |    2 +-
 sound/pci/cs5535audio/Makefile                     |    7 +-
 sound/pci/cs5535audio/cs5535audio.c                |   24 +-
 sound/pci/cs5535audio/cs5535audio.h                |   42 +-
 sound/pci/cs5535audio/cs5535audio_pcm.c            |   10 +-
 sound/pci/cs5535audio/cs5535audio_pm.c             |   26 +-
 sound/pci/echoaudio/echoaudio.c                    |   33 +-
 sound/pci/echoaudio/echoaudio_dsp.c                |    4 +-
 sound/pci/echoaudio/echoaudio_dsp.h                |   15 +-
 sound/pci/emu10k1/Makefile                         |    2 +-
 sound/pci/emu10k1/emu10k1.c                        |    4 +-
 sound/pci/emu10k1/emu10k1_main.c                   |  130 +-
 sound/pci/emu10k1/emu10k1x.c                       |    9 +-
 sound/pci/emu10k1/emufx.c                          |  251 ++--
 sound/pci/emu10k1/emumixer.c                       |   86 +-
 sound/pci/emu10k1/emumpu401.c                      |    2 +-
 sound/pci/emu10k1/emupcm.c                         |    2 +-
 sound/pci/emu10k1/emuproc.c                        |   58 +-
 sound/pci/emu10k1/io.c                             |   12 +-
 sound/pci/emu10k1/irq.c                            |    2 +-
 sound/pci/emu10k1/memory.c                         |    2 +-
 sound/pci/emu10k1/p16v.c                           |   19 +-
 sound/pci/emu10k1/voice.c                          |    2 +-
 sound/pci/ens1370.c                                |   44 +-
 sound/pci/es1938.c                                 |   22 +-
 sound/pci/es1968.c                                 |   28 +-
 sound/pci/fm801.c                                  |    4 +-
 sound/pci/hda/Makefile                             |   27 +-
 sound/pci/hda/hda_codec.c                          |  735 ++++++--
 sound/pci/hda/hda_codec.h                          |  113 +-
 sound/pci/hda/hda_generic.c                        |  100 +-
 sound/pci/hda/hda_hwdep.c                          |  122 ++
 sound/pci/hda/hda_intel.c                          |  382 +++--
 sound/pci/hda/hda_local.h                          |  193 ++-
 sound/pci/hda/hda_patch.h                          |   16 +
 sound/pci/hda/hda_proc.c                           |   30 +-
 sound/pci/hda/patch_analog.c                       |  524 ++++---
 sound/pci/hda/patch_atihdmi.c                      |   16 -
 sound/pci/hda/patch_cmedia.c                       |   24 -
 sound/pci/hda/patch_conexant.c                     |  156 +--
 sound/pci/hda/patch_realtek.c                      | 1840 +++++++++++++++-----
 sound/pci/hda/patch_si3054.c                       |   20 +-
 sound/pci/hda/patch_sigmatel.c                     | 1000 ++++++++---
 sound/pci/hda/patch_via.c                          |   80 +-
 sound/pci/ice1712/Makefile                         |    2 +-
 sound/pci/ice1712/ak4xxx.c                         |    4 +-
 sound/pci/ice1712/amp.c                            |    2 +-
 sound/pci/ice1712/amp.h                            |    2 +-
 sound/pci/ice1712/aureon.c                         |   45 +-
 sound/pci/ice1712/delta.c                          |   13 +-
 sound/pci/ice1712/delta.h                          |    2 +-
 sound/pci/ice1712/envy24ht.h                       |    2 +-
 sound/pci/ice1712/ews.c                            |   20 +-
 sound/pci/ice1712/ews.h                            |    2 +-
 sound/pci/ice1712/hoontech.c                       |    2 +-
 sound/pci/ice1712/hoontech.h                       |    2 +-
 sound/pci/ice1712/ice1712.c                        |   52 +-
 sound/pci/ice1712/ice1712.h                        |    5 +-
 sound/pci/ice1712/ice1724.c                        |   54 +-
 sound/pci/ice1712/juli.c                           |    2 +-
 sound/pci/ice1712/phase.c                          |   23 +-
 sound/pci/ice1712/pontis.c                         |   27 +-
 sound/pci/ice1712/prodigy192.c                     |   27 +-
 sound/pci/ice1712/wtm.c                            |   29 +-
 sound/pci/intel8x0.c                               |    4 +-
 sound/pci/intel8x0m.c                              |    4 +-
 sound/pci/korg1212/Makefile                        |    2 +-
 sound/pci/korg1212/korg1212.c                      |    4 -
 sound/pci/maestro3.c                               |    2 -
 sound/pci/mixart/Makefile                          |    2 +-
 sound/pci/mixart/mixart.c                          |   10 +-
 sound/pci/mixart/mixart_mixer.c                    |    9 +-
 sound/pci/nm256/Makefile                           |    2 +-
 sound/pci/nm256/nm256.c                            |    1 -
 sound/pci/pcxhr/pcxhr.c                            |    5 +
 sound/pci/pcxhr/pcxhr_mixer.c                      |   15 +-
 sound/pci/rme32.c                                  |   33 +-
 sound/pci/rme96.c                                  |   41 +-
 sound/pci/rme9652/Makefile                         |    2 +-
 sound/pci/rme9652/hdsp.c                           |   90 +-
 sound/pci/rme9652/hdspm.c                          |  723 ++++----
 sound/pci/rme9652/rme9652.c                        |   27 +-
 sound/pci/sonicvibes.c                             |    4 +-
 sound/pci/trident/Makefile                         |    2 +-
 sound/pci/trident/trident.c                        |    2 +-
 sound/pci/trident/trident_main.c                   |   22 +-
 sound/pci/trident/trident_memory.c                 |    2 +-
 sound/pci/via82xx.c                                |   19 +-
 sound/pci/via82xx_modem.c                          |    8 +-
 sound/pci/vx222/Makefile                           |    2 +-
 sound/pci/ymfpci/Makefile                          |    2 +-
 sound/pci/ymfpci/ymfpci.c                          |    4 +-
 sound/pci/ymfpci/ymfpci_main.c                     |  108 +-
 sound/pcmcia/Makefile                              |    2 +-
 sound/pcmcia/pdaudiocf/Makefile                    |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c                 |    4 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.h                 |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_core.c            |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_irq.c             |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c             |    2 +-
 sound/pcmcia/vx/Makefile                           |    2 +-
 sound/pcmcia/vx/vxp_mixer.c                        |    9 +-
 sound/ppc/Makefile                                 |    2 +-
 sound/ppc/daca.c                                   |   10 +-
 sound/ppc/pmac.c                                   |   57 +-
 sound/ppc/pmac.h                                   |    4 +-
 sound/ppc/snd_ps3.c                                |    1 -
 sound/sh/aica.c                                    |   10 +-
 sound/soc/codecs/Kconfig                           |   20 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/cs4270.c                          |  805 +++++++++
 sound/soc/codecs/cs4270.h                          |   28 +
 sound/soc/pxa/spitz.c                              |    1 -
 sound/soc/s3c24xx/Kconfig                          |    2 +-
 sound/soc/s3c24xx/s3c24xx-i2s.c                    |    1 +
 sound/soc/s3c24xx/s3c24xx-pcm.c                    |   22 +-
 sound/soc/soc-core.c                               |   20 -
 sound/soc/soc-dapm.c                               |    2 +-
 sound/sparc/cs4231.c                               |  805 ++++-----
 sound/sparc/dbri.c                                 |  581 ++++---
 sound/spi/Kconfig                                  |   31 +
 sound/spi/Makefile                                 |    5 +
 sound/spi/at73c213.c                               | 1129 ++++++++++++
 sound/spi/at73c213.h                               |  119 ++
 sound/synth/Makefile                               |    2 +-
 sound/synth/emux/Makefile                          |    2 +-
 sound/synth/util_mem.c                             |    2 +-
 sound/usb/Kconfig                                  |    2 +
 sound/usb/caiaq/caiaq-audio.c                      |    1 +
 sound/usb/caiaq/caiaq-device.c                     |   18 +-
 sound/usb/caiaq/caiaq-device.h                     |    1 +
 sound/usb/caiaq/caiaq-input.c                      |   28 +-
 sound/usb/usbaudio.c                               |   46 +-
 sound/usb/usbmidi.c                                |   46 +-
 sound/usb/usbmixer.c                               |   11 +-
 sound/usb/usbquirks.h                              |  100 ++-
 370 files changed, 11183 insertions(+), 5968 deletions(-)


The following things were done:

Adrian Bunk (4):
      [ALSA] sound/pci/cs46xx/: fix an off-by-one
      [ALSA] sound/synth/util_mem.c: remove pointless check
      [ALSA] unexport snd_ctl_elem_{read,write}
      [ALSA] au88x0_synth.c bugfix

Andres Salomon (5):
      [ALSA] cs5535audio: correctly set dma->substream
      [ALSA] cs5535audio: fix PRD register save/restore power management race
      [ALSA] cs5535audio: update PCI device handling in suspend/resume
      [ALSA] cs5535audio: fix ACC_BM[x]_CMD register handling
      [ALSA] cs5535audio: drop unused bus master stuff

Andrew Morton (2):
      [ALSA] sc6000 build fix
      [ALSA] git-alsa kconfig fix

Arnaud Patard (1):
      [ALSA] Fix Kconfig entry for SND_S3C24XX_SOC_NEO1973_WM8753

Clemens Ladisch (42):
      [ALSA] ymfpci: fix volume handling of the 44.1 kHz slot
      [ALSA] check for linked substreams of different cards
      [ALSA] seq_midi_event: fix encoding of data bytes after end of sysex
      [ALSA] seq_midi_event: prevent running status after system messages
      [ALSA] seq_midi_event: fix parsing of missing data bytes
      [ALSA] seq_midi_event: fix parsing of F9/FD bytes
      [ALSA] remove incorrect usage of SNDRV_PCM_INFO_SYNC_START and snd_pcm_set_sync()
      [ALSA] pcm: merge rates[] from pcm_misc.c and pcm_native.c
      [ALSA] pcm: add snd_pcm_rate_to_rate_bit() helper
      [ALSA] usb-audio: fix parsing of SysEx messages from CME keyboards
      [ALSA] usb-audio: allow output interrupt transfers for MIDI
      [ALSA] usb-audio: allow low speed MIDI devices
      [ALSA] usb-audio: add workaround for ESI MIDI Mate/RomIO II
      [ALSA] cmipci: fix MIDI device name
      [ALSA] cmipci: fix handling of FM/MIDI port addresses
      [ALSA] cmipci: make the test for integrated MIDI port address more robust
      [ALSA] cmipci: reorganize chip version detection
      [ALSA] cmipci: remove has_dual_dac
      [ALSA] cmipci: show actual chip name in card longname
      [ALSA] usb-audio: add quirk for Serato Scratch Live DJ Box
      [ALSA] cmipci: remove invalid channels constraint
      [ALSA] cmipci: add 96 kHz support
      [ALSA] cmipci: do not check for integrated FM/MIDI ports with chip version 37
      [ALSA] cmipci: check that the legacy MIDI port works
      [ALSA] cmipci: show real chip name in card name
      [ALSA] cmipci: add msbits constraint for 24-bit format
      [ALSA] document basic TLV stuff
      [ALSA] usb-audio: add Ozone Academic support
      [ALSA] bt87x: fix detection of generic boards
      [ALSA] cmipci: fix version 37 detection
      [ALSA] cmipci: update register definitions
      [ALSA] cmipci: show more registers in proc file
      [ALSA] cmipci: reset the chip when initializing
      [ALSA] cmipci: initialize 0x90 registers
      [ALSA] cmipci: allow 96 kHz playback on non-multichannel rear
      [ALSA] cmipci: remove 5.0 format
      [ALSA] cmipci: reorganize set_dac_channels()
      [ALSA] cmipci: fix lookup of double rates
      [ALSA] cmipci: clean up struct cmipci_pcm
      [ALSA] cmipci: fix distortion on rear channels
      [ALSA] mpu-401: do not require an ACK byte for the ENTER_UART command
      [ALSA] mpu-401: remove MPU401_INFO_UART_ONLY flag

Daniel Mack (1):
      [ALSA] caiaq - support for Native Instrument's RigKontrol3

Danny Tholen (1):
      [ALSA] hda-intel - Improve HD-audio codec probing robustness

Eugene Teo (1):
      [ALSA] seq: resource leak fix and various code cleanups

Giuliano Pochini (1):
      [ALSA] echoaudio - Add barrier() to prevent compiler optimization

Hans-Christian Egtvedt (2):
      [ALSA] Add SPI devices to ALSA Kconfig and Makefile
      [ALSA] ALSA sound driver for the AT73C213 DAC using Atmel SSC driver

Harald Welte (1):
      [ALSA] s3c24xx-pcm: fix hw_params dma handling

Ingo Molnar (1):
      [ALSA] fix bootup crash in snd_gus_interrupt()

James Courtier-Dutton (7):
      [ALSA] snd-emu10k1: Add support for E-Mu 1616 PCI, 1616M PCI, 0404 PCI, E-Mu
      [ALSA] snd-emu10k1:Improves firmware loading for E-Mu cards.
      [ALSA] snd-ca0106:Add recognition for new variant. Fixes ALSA bug#3251
      [ALSA] snd-emu10k1:Support for ADAT and S/PDIF.
      [ALSA] snd-emu10k1:Implement SPDIF/ADAT status.
      [ALSA] snd-emu10k1:Unmute the Audio/Micro Dock after firmware load.
      [ALSA] snd-usb-audio: Add basic support for E-Mu USB devices.

Jaroslav Kysela (3):
      [ALSA] SC6000 driver - add HAS_IOPORT dependency
      [ALSA] Changed Jaroslav Kysela's e-mail from perex@suse.cz to perex@perex.cz
      [ALSA] version 1.0.15

Jesper Juhl (5):
      [ALSA] Clean up duplicate includes in sound/ppc/
      [ALSA] Clean up duplicate includes in sound/soc/
      [ALSA] Clean up duplicate includes in sound/core/
      [ALSA] au88x0: mem leak fix in snd_vortex_create()
      [ALSA] emu10k1: There's no need to cast vmalloc() return value in snd_emu10k1_create()

Kailang Yang (6):
      [ALSA] hda-codec - Update realtek codec support
      [ALSA] hda-codec - Add support for Haier W66
      [ALSA] hda-codec - Fix ALC662 codec support
      [ALSA] hda-codec - Missing support ASUS A7J
      [ALSA] Support  ASUS P701 eeepc [0x1043 0x82a1] support
      [ALSA] hda-codec - Fix SKU ID function for realtek codecs

Karsten Wiese (1):
      [ALSA] snd_usb_caiaq_input_free() fix

Keita Maehara (2):
      [ALSA] ac97: YMF743 missing controls support (1/2)
      [ALSA] ac97: YMF743 missing controls support (2/2)

Krzysztof Helt (23):
      [ALSA] isa libs Makefiles cleanup
      [ALSA] dbri: driver cleanup
      [ALSA] sun-cs4231: code improvements
      [ALSA] dbri: more cleanups
      [ALSA] cs4231 header split
      [ALSA] dbri: conversion to OpenFirmware framework
      [ALSA] sun-cs4231: memory management fix
      [ALSA] dbri - Use linux/of.h instead of asm/prom.h
      [ALSA] ad1848_lib: replace common delay loop by function
      [ALSA] cs4231-lib: replace common delay loop by function
      [ALSA] sun-cs4231: checkpatch fixes
      [ALSA] cs4231-lib: improved waiting after mce_down
      [ALSA] Gallant SC-6000 driver
      [ALSA] ad1848_lib: waiting loops done after cs4231_lib
      [ALSA] sc6000: documentation fix
      [ALSA] sc6000: 2 minor fixes
      [ALSA] sscape: driver extension to 2nd DMA and WSS port
      [ALSA] sscape: support for audio part of VIVO cards
      [ALSA] This patch removes open_mutex from the ad1848-lib as
      [ALSA] This patch adds support for a wavetable chip on
      [ALSA] This simplifies and fixes waiting loops of the mce_down()
      [ALSA] sun-cs4231: use cs4231-regs.h
      [ALSA] sun-cs4231: improved waiting after MCE down

Mariusz Kozlowski (2):
      [ALSA] This patch removes memset() from snd_emu10k1_fx8010_info() which apparently
      [ALSA] sound: snd_register_device_for_dev fix

Mark Hills (2):
      [ALSA] This patch is a USB quirk to ensure the Stanton Scratchamp v1 is detected
      [ALSA] usb-audio: update quirk for Rane SL 1 (aka. Serato Scratch Live)

Matthew Ranostay (2):
      [ALSA] hda: BIOS changing subsystem id
      [ALSA] hda: More subsystem id BIOS changes

Matthias Kaehlcke (3):
      [ALSA] ESS Maestro 1/2/2E Sound Card: Use list_for_each_entry
      [ALSA] Intel HD Audio: Use list_for_each_entry(_safe)
      [ALSA] Routines for effect processor FX8010: Use list_for_each_entry

Maxim Levitsky (7):
      [ALSA] hda-codec - code cleanups in patch_sigmatel.c
      [ALSA] hda-intel - fix a race in dynamic power managment
      [ALSA] hda-intel - Fix resume logic, when dynamic power managment is on
      [ALSA] hda-codec - add support for swapping center/LFE channels to STAC codecs
      [ALSA] hda-codec - add support for analog loopback to STAC9204/9205/922x/927x
      [ALSA] hda-codec - make volume knob, the master volume for sigmatel codecs
      [ALSA] hda-codec - Fix support for sigmatel codecs that have 2 or more ADCs

Michal Piotrowski (2):
      [ALSA] Coding style fix sound/pci/ca0106/ca_midi.h
      [ALSA] Get rid of dead code in sound/arm/sa11xx-uda1341.c

Oliver Neukum (1):
      [ALSA] missing error check in usb sound driver

Paul Vojta (1):
      [ALSA] Fix bugs in mode change/recalibration for opl3sa2 driver

Peer Chen (1):
      [ALSA] alsa: Add the MCP79 support to hda_intel driver

Randy Dunlap (1):
      [ALSA] sound/hda: fix help text

Remy Bruno (2):
      [ALSA] hdspm - Fix autosync bug
      [ALSA] hdsp - Add support for latset RME9632 revisions

Rene Herman (7):
      [ALSA] add the ESS1879 pnpbios ID to the es18xx driver
      [ALSA] ad1848: fix AD1848P macro
      [ALSA] ad1838/cs4231 - fix MCE timeout upon initial load
      [ALSA] ad1848: replace HZ calculus with msecs_to_jiffies()
      [ALSA] ad1848/cs4231: replace commented out debug code with snd-printd{,d}
      [ALSA] alsa-kernel: schedule_timeout() fixes
      [ALSA] schedule_timeout() fix for core/seq/seq_instr.c

Russ Cox (1):
      [ALSA] fix selector unit bug affecting some USB speakerphones

Scott Thompson (1):
      [ALSA] sound/soc ioremap/iounmap balancing

Stephen Rothwell (1):
      [ALSA] Fix tas_suspend/resume build warning

Takashi Iwai (101):
      [ALSA] Add helper functions for frequently used callbacks
      [ALSA] Clean up with common snd_ctl_boolean_*_info callbacks
      [ALSA] ice1712 - Fix missing replacement to snd_ctl_boolean_mono_info
      [ALSA] hda-codec - Fix AD1988 SPDIF output
      [ALSA] hda-codec - Fix the initial mixer state of ALC262 sony-assamd model
      [ALSA] Fixes to follow the standard coding style
      [ALSA] Fix build error without CONFIG_HAS_DMA
      [ALSA] Clean up Makefile
      [ALSA] hda-intel - Coding style fixes
      [ALSA] hdspm - Coding style fixes
      [ALSA] hda-intel - Add hwdep interface
      [ALSA] hda-codec - Add a generic bind-control helper
      [ALSA] hda-codec - kernel config for each codec
      [ALSA] Add missing static in ac97_codec.c
      [ALSA] hda-intel - Fix compile warning in snd_hwdep_ioctl_compat()
      [ALSA] hda-intel - Fix a typo in Makefile
      [ALSA] hda-codec - Fix GPIO in resume
      [ALSA] hda-intel - Fix a typo in Kconfig
      [ALSA] hda-intel - Remove invalid __devinit
      [ALSA] doc - Remove IRQF_DISABLED from the example description
      [ALSA] Remove ifdefs from OSS PCM emulation codes
      [ALSA] Simplify the format conversion in PCM OSS emulation
      [ALSA] Support 3-bytes 24bit format in PCM OSS emulation
      [ALSA] Fix OSS documentation about 3bytes format
      [ALSA] Add new AFMT_* formats for OSS emulation
      [ALSA] usb-audio - Add advanced mode support for Edirol UA-1EX
      [ALSA] Use msecs_to_jiffies() in ac97_codec.c
      [ALSA] hda-codec - rewrite amp cache more generic
      [ALSA] hda-codec - introduce command register cache
      [ALSA] hda-codec - optimize resume using caches
      [ALSA] hda-codec - add snd_hda_codec_stereo() function
      [ALSA] hda-codec - Clean up bind-controls
      [ALSA] hda-intel - Add POWER_SAVE option
      [ALSA] hda-codec - update of documentation
      [ALSA] hda-intel - Fix resume with power save
      [ALSA] hda-intel - Add power_save_controller module option
      [ALSA] mixart - Check ioremap error
      [ALSA] hda-intel - Fix NULL dereference in resume
      [ALSA] hda-intel - Don't do suspend if already powered down
      [ALSA] hda-codec - Remove conflicting capture mixers for ALC861VD
      [ALSA] hda-codec - Add support for Biostar NF61S SE mobo
      [ALSA] hda-codec - Add option texts and descriptions for new Realtek models
      [ALSA] hda-intel - Add flush_scheduled_work() in snd_hda_codec_free()
      [ALSA] hda-codec - Fix Master volume with AD1986A laptop model
      [ALSA] hda-intel - Add position_fix quirk for Dell Precision 390
      [ALSA] hda-codec - Add ALC268 acer model
      [ALSA] hda-codec - Fix PM on ALC885 Intel Macs
      [ALSA] hda-codec - Remove superfluous code
      [ALSA] hda-codec - Add unsol_event to ALC883 Acer Aspire
      [ALSA] hda-intel - Avoid unnecessary work scheduling
      [ALSA] hda-codec - Add model for MSI m673x
      [ALSA] hda-codec - Add auto-mute function to Sony VAIO with STAC9872
      [ALSA] hda-codec - Fix Toshiba A135 model selection
      [ALSA] hda-codec - Add support for Macbook Pro rev3
      [ALSA] hda-codec - Add support for Toshiba Satellite P205
      [ALSA] emu10k1 - Fix memory corruption
      [ALSA] hda-codec - Fix ALC268 acer model
      [ALSA] hda-intel - Add probe_mask blacklist
      [ALSA] hda-codec - Add SPDIF support on ALC880 fujitsu model
      [ALSA] hda-codec - Add missing capture boost for ALC268
      [ALSA] wavefront - Use standard firmware loader
      [ALSA] bt87x - Add known PCI ID entries
      [ALSA] hda-intel - Fix compile with gcc-3.x
      [ALSA] hda-codec - Fix mater mixer switch of ALC262 sony-amd model
      [ALSA] hda-codec - Fix ALC268 unsol event
      [ALSA] hda-codec - Fix Dell laptops support with STAC codecs
      [ALSA] Allow shared IRQ for CS5530 device
      [ALSA] hda-codec - Add Mic Boost control with auto-configuration
      [ALSA] ac97 - Suppress the reset of audio-codec from modem-codec at resume
      [ALSA] hda-codec - Fix wrong pin-setup at resume of STAC codecs
      [ALSA] hda-codec - Avoid zero NID in line_out_pins[] of STAC codecs
      [ALSA] hda-codec - Add support for Acer Aspire 9303
      [ALSA] hda-codec - Fix wrong pin config order in STAC92xx dell models
      [ALSA] Add missing models for Dell with STAC9200 codec
      [ALSA] hda-codec - Add laptop-automute model for AD1986A
      [ALSA] hda-codec - Add support for ASUS A7M
      [ALSA] hda-codec - Add missing model names for ALC882 codecs
      [ALSA] hda-codec - Add quirk entry for Casper CPR2000
      [ALSA] hda-codec - Add missing Mic Boost for some ALC882 models
      [ALSA] hda-codec - Add support for Toshiba A305
      [ALSA] Fix 'discards qualifiers' compile warnings in pcm.h
      [ALSA] Kill useless volatile in pcm.h
      [ALSA] pcxhr - Fix trigger start with non-linked streams
      [ALSA] Add description of sc6000 driver
      [ALSA] echoaudio - Remove superfluous volatile prefix
      [ALSA] Add descriptions for new module options of snd-sscape driver
      [ALSA] opti9xx: adjust OPL3 FM resource value
      [ALSA] Add default values for power-saving as Kconfig options
      [ALSA] Add description about power-saving mode
      [ALSA] Workaround for invalid signature read of CS8427
      [ALSA] hda-codec - Add zero checks in input-mux helper functions
      [ALSA] hda-codec - Fix Gateway laptops with STAC9200
      [ALSA] pcxhr - Fix dB level information
      [ALSA] hda-codec - Fix input_mux numbers for vaio stac92xx
      [ALSA] via82xx - Add DXS quirk for Shuttle AK31v2
      [ALSA] hda-codec - Fix for Fujitsu Lifebook C1410
      [ALSA] hda-codec - Fix STAC922x volume knob control
      [ALSA] usb-audio - Fix double comment
      [ALSA] hdsp - Fix zero division
      [ALSA] hda-codec - Add array terminator for dmic in STAC codec
      [ALSA] Fix thinko in cs4231 mce down check

Tim Gardner (1):
      [ALSA] hda-codec - Re-add quirk support for Dell XPS 1330 and Inspiron 1420

Timur Tabi (3):
      [ALSA] ASoC CS4270 codec device driver
      [ALSA] CS4270 driver does not compile with I2C disabled
      [ALSA] Fix CS4270 volume control and optimize I2C operations

Tobin Davis (6):
      [ALSA] hda-codec -  Add support for the ASRock K8NF6G-VSTA motherboard
      [ALSA] hda-codec - Add more Dell systems
      [ALSA] hda-codec - Add support for Acer Aspire laptops
      [ALSA] This patch adds more support for Dell systems with Stac9205 codecs.
      [ALSA] hda-codec: Add 4 channel support for Realtek ALC883
      [ALSA] hda-codec: Add two new systems to ALC883

Trent Piepho (9):
      [ALSA] ca0106: Add analog mute controls for cards with SPI DAC
      [ALSA] ca0106: replaced control add sequences with macro
      [ALSA] ca0106: power down SPI DAC channels when not in use
      [ALSA] ca0106: Add more symbol SPI register names and use them
      [ALSA] ca0106: remove extra commands in SPI DAC init sequence
      [ALSA] snd-bt87x: Improve support for different board types
      [ALSA] snd-bt87x: Power down audio ADC when not in use
      [ALSA] ad1848: Fix msleep while atomic
      [ALSA] ad1848: simplify MCE down code

zhejiang (1):
      [ALSA] hda-codec - Fix capture on ALC262 HP machines

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project
