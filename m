Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbYAaREu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbYAaREu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbYAaREl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:04:41 -0500
Received: from mail1.perex.cz ([212.20.107.53]:36792 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758631AbYAaREh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:04:37 -0500
Date: Thu, 31 Jan 2008 18:04:32 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0801311800290.6131@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1980695349-1201799072=:6131"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1980695349-1201799072=:6131
Content-Type: TEXT/PLAIN; charset=iso8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=3Dlinux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2008-01-31.patch.g=
z

The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt    |  210 ++-
 .../sound/alsa/DocBook/writing-an-alsa-driver.tmpl |  923 +++++-----
 Documentation/sound/alsa/soc/DAI.txt               |    6 +-
 Documentation/sound/alsa/soc/clocking.txt          |   10 +-
 Documentation/sound/alsa/soc/codec.txt             |   53 +-
 Documentation/sound/alsa/soc/dapm.txt              |   51 +-
 Documentation/sound/alsa/soc/machine.txt           |   12 +-
 Documentation/sound/alsa/soc/overview.txt          |   42 +-
 Documentation/sound/alsa/soc/platform.txt          |    6 +-
 Documentation/sound/alsa/soc/pops_clicks.txt       |   10 +-
 MAINTAINERS                                        |    3 +
 drivers/input/touchscreen/ucb1400_ts.c             |    1 -
 drivers/media/video/cx88/cx88-alsa.c               |    1 -
 drivers/media/video/saa7134/saa7134-alsa.c         |    1 -
 drivers/media/video/saa7134/saa7134.h              |    1 -
 drivers/usb/gadget/gmidi.c                         |    1 -
 include/asm-arm/arch-omap/eac.h                    |    1 -
 include/asm-arm/arch-omap/omap-alsa.h              |    1 -
 include/asm-arm/arch-pxa/audio.h                   |    1 -
 include/sound/ad1848.h                             |    2 +-
 include/sound/ainstr_fm.h                          |  134 --
 include/sound/ainstr_gf1.h                         |  229 ---
 include/sound/ainstr_iw.h                          |  384 ----
 include/sound/ainstr_simple.h                      |  159 --
 include/sound/ak4xxx-adda.h                        |    2 +-
 include/sound/asequencer.h                         |  242 +---
 include/sound/asound.h                             |   34 +-
 include/sound/asound_fm.h                          |   19 +
 include/sound/core.h                               |   10 +
 include/sound/cs4231-regs.h                        |    2 +-
 include/sound/cs46xx.h                             |    3 -
 include/sound/driver.h                             |   52 +-
 include/sound/emu10k1.h                            |  231 +++-
 include/sound/gus.h                                |   63 -
 include/sound/info.h                               |    2 +
 include/sound/opl3.h                               |   78 +-
 include/sound/pcm.h                                |   18 +-
 include/sound/seq_instr.h                          |  110 --
 include/sound/soc-dapm.h                           |   29 +-
 include/sound/soc.h                                |   67 +-
 include/sound/tea575x-tuner.h                      |    1 +
 include/sound/trident.h                            |   22 -
 include/sound/version.h                            |    4 +-
 sound/aoa/aoa.h                                    |    2 -
 sound/aoa/codecs/snd-aoa-codec-onyx.c              |   12 +
 sound/aoa/codecs/snd-aoa-codec-tas.c               |   21 +-
 sound/aoa/fabrics/snd-aoa-fabric-layout.c          |    2 +-
 sound/aoa/soundbus/i2sbus/i2sbus-core.c            |    1 -
 sound/aoa/soundbus/i2sbus/i2sbus-pcm.c             |   10 +-
 sound/arm/aaci.c                                   |    1 -
 sound/arm/devdma.c                                 |    1 -
 sound/arm/pxa2xx-ac97.c                            |    2 +-
 sound/arm/pxa2xx-pcm.c                             |    1 -
 sound/arm/sa11xx-uda1341.c                         |    1 -
 sound/core/control.c                               |   52 +-
 sound/core/control_compat.c                        |    3 +-
 sound/core/device.c                                |    1 -
 sound/core/hwdep.c                                 |    1 -
 sound/core/info.c                                  |    1 -
 sound/core/info_oss.c                              |    3 -
 sound/core/init.c                                  |   39 +-
 sound/core/isadma.c                                |    1 -
 sound/core/memalloc.c                              |    1 +
 sound/core/memory.c                                |    2 +-
 sound/core/misc.c                                  |    1 -
 sound/core/oss/copy.c                              |    1 -
 sound/core/oss/io.c                                |    1 -
 sound/core/oss/linear.c                            |    1 -
 sound/core/oss/mixer_oss.c                         |    1 -
 sound/core/oss/mulaw.c                             |    1 -
 sound/core/oss/pcm_oss.c                           |    4 +-
 sound/core/oss/pcm_plugin.c                        |    1 -
 sound/core/oss/rate.c                              |    1 -
 sound/core/oss/route.c                             |    1 -
 sound/core/pcm.c                                   |   15 +-
 sound/core/pcm_compat.c                            |    1 +
 sound/core/pcm_lib.c                               |  339 +---
 sound/core/pcm_memory.c                            |    1 -
 sound/core/pcm_misc.c                              |    3 +-
 sound/core/pcm_native.c                            |  141 +-
 sound/core/pcm_timer.c                             |    1 -
 sound/core/rawmidi.c                               |   41 +-
 sound/core/rtctimer.c                              |    1 -
 sound/core/seq/Makefile                            |    8 +-
 sound/core/seq/instr/Makefile                      |   23 -
 sound/core/seq/instr/ainstr_fm.c                   |  155 --
 sound/core/seq/instr/ainstr_gf1.c                  |  359 ----
 sound/core/seq/instr/ainstr_iw.c                   |  623 -------
 sound/core/seq/instr/ainstr_simple.c               |  215 ---
 sound/core/seq/oss/seq_oss.c                       |    1 -
 sound/core/seq/oss/seq_oss_device.h                |    1 -
 sound/core/seq/seq.c                               |    1 -
 sound/core/seq/seq_clientmgr.c                     |    6 +-
 sound/core/seq/seq_clientmgr.h                     |    2 +
 sound/core/seq/seq_device.c                        |    1 -
 sound/core/seq/seq_dummy.c                         |    1 -
 sound/core/seq/seq_fifo.c                          |    1 -
 sound/core/seq/seq_info.c                          |    1 -
 sound/core/seq/seq_instr.c                         |  655 -------
 sound/core/seq/seq_lock.c                          |    1 -
 sound/core/seq/seq_memory.c                        |    1 -
 sound/core/seq/seq_midi.c                          |    1 -
 sound/core/seq/seq_midi_emul.c                     |    8 -
 sound/core/seq/seq_midi_event.c                    |    1 -
 sound/core/seq/seq_ports.c                         |    1 -
 sound/core/seq/seq_prioq.c                         |    1 -
 sound/core/seq/seq_queue.c                         |    1 -
 sound/core/seq/seq_system.c                        |    1 -
 sound/core/seq/seq_timer.c                         |    8 -
 sound/core/seq/seq_timer.h                         |    7 +
 sound/core/seq/seq_virmidi.c                       |    1 -
 sound/core/sound.c                                 |    1 -
 sound/core/sound_oss.c                             |    2 -
 sound/core/timer.c                                 |   17 +-
 sound/drivers/Kconfig                              |   12 +
 sound/drivers/Makefile                             |    2 +
 sound/drivers/dummy.c                              |    1 -
 sound/drivers/ml403-ac97cr.c                       | 1352 +++++++++++++++
 sound/drivers/mpu401/mpu401.c                      |    1 -
 sound/drivers/mpu401/mpu401_uart.c                 |    1 -
 sound/drivers/mtpav.c                              |    1 -
 sound/drivers/mts64.c                              |   17 +-
 sound/drivers/opl3/opl3_lib.c                      |    5 +-
 sound/drivers/opl3/opl3_midi.c                     |   41 +-
 sound/drivers/opl3/opl3_oss.c                      |  135 +--
 sound/drivers/opl3/opl3_seq.c                      |   42 +-
 sound/drivers/opl3/opl3_synth.c                    |  180 ++-
 sound/drivers/pcm-indirect2.c                      |  573 ++++++
 sound/drivers/pcm-indirect2.h                      |  140 ++
 sound/drivers/portman2x4.c                         |    3 +-
 sound/drivers/serial-u16550.c                      |   10 +-
 sound/drivers/virmidi.c                            |    1 -
 sound/drivers/vx/vx_cmd.c                          |    1 -
 sound/drivers/vx/vx_core.c                         |    1 -
 sound/drivers/vx/vx_hwdep.c                        |    1 -
 sound/drivers/vx/vx_mixer.c                        |   68 +-
 sound/drivers/vx/vx_pcm.c                          |    1 -
 sound/drivers/vx/vx_uer.c                          |    1 -
 sound/i2c/cs8427.c                                 |    1 -
 sound/i2c/i2c.c                                    |    1 -
 sound/i2c/l3/uda1341.c                             |    1 -
 sound/i2c/other/ak4114.c                           |    1 -
 sound/i2c/other/ak4117.c                           |    1 -
 sound/i2c/other/ak4xxx-adda.c                      |   51 +-
 sound/i2c/other/pt2258.c                           |    3 +-
 sound/i2c/other/tea575x-tuner.c                    |    9 +-
 sound/i2c/tea6330t.c                               |    1 -
 sound/isa/ad1816a/ad1816a.c                        |   54 +-
 sound/isa/ad1816a/ad1816a_lib.c                    |    1 -
 sound/isa/ad1848/ad1848.c                          |    1 -
 sound/isa/ad1848/ad1848_lib.c                      |    3 +-
 sound/isa/adlib.c                                  |    1 -
 sound/isa/als100.c                                 |   50 +-
 sound/isa/azt2320.c                                |   51 +-
 sound/isa/cmi8330.c                                |   43 +-
 sound/isa/cs423x/cs4231.c                          |    1 -
 sound/isa/cs423x/cs4231_lib.c                      |    2 -
 sound/isa/cs423x/cs4236.c                          |   92 +-
 sound/isa/cs423x/cs4236_lib.c                      |    1 -
 sound/isa/dt019x.c                                 |   47 +-
 sound/isa/es1688/es1688.c                          |    1 -
 sound/isa/es1688/es1688_lib.c                      |    1 -
 sound/isa/es18xx.c                                 |   61 +-
 sound/isa/gus/Makefile                             |   12 -
 sound/isa/gus/gus_dma.c                            |    1 -
 sound/isa/gus/gus_dram.c                           |    1 -
 sound/isa/gus/gus_instr.c                          |    1 -
 sound/isa/gus/gus_io.c                             |    1 -
 sound/isa/gus/gus_irq.c                            |    1 -
 sound/isa/gus/gus_main.c                           |   24 -
 sound/isa/gus/gus_mem.c                            |    1 -
 sound/isa/gus/gus_mem_proc.c                       |    1 -
 sound/isa/gus/gus_mixer.c                          |    1 -
 sound/isa/gus/gus_pcm.c                            |    1 -
 sound/isa/gus/gus_reset.c                          |    1 -
 sound/isa/gus/gus_sample.c                         |  165 --
 sound/isa/gus/gus_simple.c                         |  634 -------
 sound/isa/gus/gus_synth.c                          |  314 ----
 sound/isa/gus/gus_timer.c                          |    1 -
 sound/isa/gus/gus_uart.c                           |    1 -
 sound/isa/gus/gus_volume.c                         |    1 -
 sound/isa/gus/gusclassic.c                         |    1 -
 sound/isa/gus/gusextreme.c                         |    1 -
 sound/isa/gus/gusmax.c                             |    1 -
 sound/isa/gus/interwave.c                          |   40 +-
 sound/isa/opl3sa2.c                                |   37 +-
 sound/isa/opti9xx/miro.c                           |   11 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |   51 +-
 sound/isa/sb/emu8000.c                             |    1 -
 sound/isa/sb/emu8000_local.h                       |    1 -
 sound/isa/sb/es968.c                               |   28 +-
 sound/isa/sb/sb16.c                                |   40 +-
 sound/isa/sb/sb16_csp.c                            |    4 +-
 sound/isa/sb/sb16_main.c                           |    1 -
 sound/isa/sb/sb8.c                                 |    1 -
 sound/isa/sb/sb8_main.c                            |    1 -
 sound/isa/sb/sb8_midi.c                            |    1 -
 sound/isa/sb/sb_common.c                           |    1 -
 sound/isa/sb/sb_mixer.c                            |    1 -
 sound/isa/sc6000.c                                 |    3 +-
 sound/isa/sgalaxy.c                                |    1 -
 sound/isa/sscape.c                                 |    1 -
 sound/isa/wavefront/wavefront.c                    |   56 +-
 sound/isa/wavefront/wavefront_fx.c                 |    1 -
 sound/isa/wavefront/wavefront_midi.c               |    1 -
 sound/isa/wavefront/wavefront_synth.c              |    1 -
 sound/last.c                                       |    1 -
 sound/mips/au1x00.c                                |    1 -
 sound/parisc/harmony.c                             |    1 -
 sound/pci/Kconfig                                  |   56 +
 sound/pci/Makefile                                 |    3 +
 sound/pci/ac97/ac97_codec.c                        |    1 -
 sound/pci/ac97/ac97_patch.c                        |   11 +-
 sound/pci/ac97/ac97_patch.h                        |    2 +
 sound/pci/ac97/ac97_pcm.c                          |    1 -
 sound/pci/ac97/ac97_proc.c                         |    1 -
 sound/pci/ac97/ak4531_codec.c                      |    1 -
 sound/pci/ad1889.c                                 |    7 +-
 sound/pci/ali5451/ali5451.c                        |    1 -
 sound/pci/als300.c                                 |    1 -
 sound/pci/als4000.c                                |    1 -
 sound/pci/atiixp.c                                 |    5 +-
 sound/pci/atiixp_modem.c                           |    1 -
 sound/pci/au88x0/au88x0.h                          |    1 -
 sound/pci/au88x0/au88x0_core.c                     |    2 +-
 sound/pci/au88x0/au88x0_game.c                     |    1 -
 sound/pci/au88x0/au88x0_mixer.c                    |    1 -
 sound/pci/au88x0/au88x0_mpu401.c                   |    1 -
 sound/pci/au88x0/au88x0_pcm.c                      |    1 -
 sound/pci/azt3328.c                                |    1 -
 sound/pci/bt87x.c                                  |    1 -
 sound/pci/ca0106/ca0106.h                          |    1 -
 sound/pci/ca0106/ca0106_main.c                     |    1 -
 sound/pci/ca0106/ca0106_mixer.c                    |    1 -
 sound/pci/ca0106/ca0106_proc.c                     |    1 -
 sound/pci/ca0106/ca_midi.c                         |    1 -
 sound/pci/cmipci.c                                 |  116 +-
 sound/pci/cs4281.c                                 |    1 -
 sound/pci/cs46xx/cs46xx.c                          |    1 -
 sound/pci/cs46xx/cs46xx_lib.c                      |  102 +--
 sound/pci/cs46xx/dsp_spos.c                        |    1 -
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |    1 -
 sound/pci/cs5530.c                                 |    1 -
 sound/pci/cs5535audio/cs5535audio.c                |    3 +-
 sound/pci/cs5535audio/cs5535audio_pcm.c            |    5 +-
 sound/pci/cs5535audio/cs5535audio_pm.c             |    1 -
 sound/pci/echoaudio/darla20.c                      |    1 -
 sound/pci/echoaudio/darla24.c                      |    1 -
 sound/pci/echoaudio/echo3g.c                       |    1 -
 sound/pci/echoaudio/echoaudio.c                    |   18 +-
 sound/pci/echoaudio/echoaudio.h                    |    2 +-
 sound/pci/echoaudio/gina20.c                       |    1 -
 sound/pci/echoaudio/gina24.c                       |    1 -
 sound/pci/echoaudio/indigo.c                       |    1 -
 sound/pci/echoaudio/indigodj.c                     |    1 -
 sound/pci/echoaudio/indigoio.c                     |    1 -
 sound/pci/echoaudio/layla20.c                      |    1 -
 sound/pci/echoaudio/layla24.c                      |    1 -
 sound/pci/echoaudio/mia.c                          |    1 -
 sound/pci/echoaudio/mona.c                         |    1 -
 sound/pci/emu10k1/emu10k1.c                        |    1 -
 sound/pci/emu10k1/emu10k1_callback.c               |   15 +-
 sound/pci/emu10k1/emu10k1_main.c                   |  342 +++--
 sound/pci/emu10k1/emu10k1_synth.c                  |   45 +-
 sound/pci/emu10k1/emu10k1_synth_local.h            |    1 -
 sound/pci/emu10k1/emu10k1x.c                       |    3 +-
 sound/pci/emu10k1/emufx.c                          |    9 +-
 sound/pci/emu10k1/emumixer.c                       |  276 +++-
 sound/pci/emu10k1/emumpu401.c                      |    1 -
 sound/pci/emu10k1/emupcm.c                         |    9 +-
 sound/pci/emu10k1/emuproc.c                        |    5 +-
 sound/pci/emu10k1/io.c                             |   60 +-
 sound/pci/emu10k1/irq.c                            |    9 +-
 sound/pci/emu10k1/memory.c                         |    1 -
 sound/pci/emu10k1/p16v.c                           |    1 -
 sound/pci/emu10k1/timer.c                          |    1 -
 sound/pci/emu10k1/voice.c                          |    1 -
 sound/pci/ens1370.c                                |    1 -
 sound/pci/es1938.c                                 |   28 +-
 sound/pci/es1968.c                                 |    1 -
 sound/pci/fm801.c                                  |   23 +-
 sound/pci/hda/Makefile                             |    2 +-
 sound/pci/hda/hda_codec.c                          |  117 ++-
 sound/pci/hda/hda_codec.h                          |   60 +-
 sound/pci/hda/hda_generic.c                        |    1 -
 sound/pci/hda/hda_hwdep.c                          |    1 -
 sound/pci/hda/hda_intel.c                          |  164 ++-
 sound/pci/hda/hda_local.h                          |   18 +-
 sound/pci/hda/hda_proc.c                           |  361 ++++-
 sound/pci/hda/patch_analog.c                       |  190 ++-
 sound/pci/hda/patch_atihdmi.c                      |    3 +-
 sound/pci/hda/patch_cmedia.c                       |    2 -
 sound/pci/hda/patch_conexant.c                     |  445 +++++-
 sound/pci/hda/patch_realtek.c                      | 1830 ++++++++++++++++=
+---
 sound/pci/hda/patch_si3054.c                       |    2 -
 sound/pci/hda/patch_sigmatel.c                     | 1217 ++++++++++++--
 sound/pci/hda/patch_via.c                          |  679 +++++++-
 sound/pci/hda/vmaster.c                            |  364 ++++
 sound/pci/ice1712/Makefile                         |    2 +-
 sound/pci/ice1712/ak4xxx.c                         |    1 -
 sound/pci/ice1712/amp.c                            |    1 -
 sound/pci/ice1712/aureon.c                         |  133 +-
 sound/pci/ice1712/delta.c                          |    3 +-
 sound/pci/ice1712/ews.c                            |   92 +-
 sound/pci/ice1712/hoontech.c                       |  188 ++-
 sound/pci/ice1712/ice1712.c                        |    2 +-
 sound/pci/ice1712/ice1712.h                        |   37 +-
 sound/pci/ice1712/ice1724.c                        |    9 +-
 sound/pci/ice1712/juli.c                           |   23 +-
 sound/pci/ice1712/phase.c                          |   96 +-
 sound/pci/ice1712/pontis.c                         |    1 -
 sound/pci/ice1712/prodigy192.c                     |  297 ++--
 sound/pci/ice1712/prodigy_hifi.c                   | 1210 +++++++++++++
 sound/pci/ice1712/prodigy_hifi.h                   |   38 +
 sound/pci/ice1712/revo.c                           |   24 +-
 sound/pci/ice1712/se.c                             |  774 +++++++++
 sound/pci/ice1712/se.h                             |   15 +
 sound/pci/ice1712/vt1720_mobo.c                    |    1 -
 sound/pci/ice1712/wtm.c                            |    9 +-
 sound/pci/intel8x0.c                               |    2 -
 sound/pci/intel8x0m.c                              |    1 -
 sound/pci/korg1212/korg1212.c                      |   38 +-
 sound/pci/maestro3.c                               |    2 -
 sound/pci/mixart/mixart.c                          |    1 -
 sound/pci/mixart/mixart_core.c                     |    1 -
 sound/pci/mixart/mixart_hwdep.c                    |    1 -
 sound/pci/mixart/mixart_mixer.c                    |  125 +-
 sound/pci/nm256/nm256.c                            |    1 -
 sound/pci/oxygen/Makefile                          |    9 +
 sound/pci/oxygen/ak4396.h                          |   44 +
 sound/pci/oxygen/cm9780.h                          |   63 +
 sound/pci/oxygen/hifier.c                          |  207 +++
 sound/pci/oxygen/oxygen.c                          |  385 ++++
 sound/pci/oxygen/oxygen.h                          |  190 ++
 sound/pci/oxygen/oxygen_io.c                       |  201 +++
 sound/pci/oxygen/oxygen_lib.c                      |  515 ++++++
 sound/pci/oxygen/oxygen_mixer.c                    |  794 +++++++++
 sound/pci/oxygen/oxygen_pcm.c                      |  718 ++++++++
 sound/pci/oxygen/oxygen_regs.h                     |  453 +++++
 sound/pci/oxygen/virtuoso.c                        |  449 +++++
 sound/pci/pcxhr/pcxhr.c                            |    1 -
 sound/pci/pcxhr/pcxhr_core.c                       |    1 -
 sound/pci/pcxhr/pcxhr_hwdep.c                      |    1 -
 sound/pci/pcxhr/pcxhr_mixer.c                      |   72 +-
 sound/pci/riptide/riptide.c                        |    1 -
 sound/pci/rme32.c                                  |    1 -
 sound/pci/rme96.c                                  |   28 +-
 sound/pci/rme9652/hdsp.c                           |   19 +-
 sound/pci/rme9652/hdspm.c                          |    5 +-
 sound/pci/rme9652/rme9652.c                        |    5 +-
 sound/pci/sis7019.c                                | 1460 ++++++++++++++++
 sound/pci/sis7019.h                                |  342 ++++
 sound/pci/sonicvibes.c                             |    1 -
 sound/pci/trident/Makefile                         |   10 -
 sound/pci/trident/trident.c                        |    8 -
 sound/pci/trident/trident_main.c                   |   71 +-
 sound/pci/trident/trident_memory.c                 |    1 -
 sound/pci/trident/trident_synth.c                  | 1024 -----------
 sound/pci/via82xx.c                                |   13 +-
 sound/pci/via82xx_modem.c                          |    1 -
 sound/pci/vx222/vx222.c                            |    1 -
 sound/pci/vx222/vx222_ops.c                        |   10 +-
 sound/pci/ymfpci/ymfpci.c                          |    1 -
 sound/pci/ymfpci/ymfpci_main.c                     |    5 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c                 |    3 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_core.c            |    1 -
 sound/pcmcia/pdaudiocf/pdaudiocf_irq.c             |    1 -
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c             |    1 -
 sound/pcmcia/vx/vxp_mixer.c                        |   12 +-
 sound/pcmcia/vx/vxp_ops.c                          |    1 -
 sound/pcmcia/vx/vxpocket.c                         |    1 -
 sound/ppc/awacs.c                                  |   21 +-
 sound/ppc/beep.c                                   |    8 +-
 sound/ppc/burgundy.c                               |   12 +-
 sound/ppc/daca.c                                   |   18 +-
 sound/ppc/keywest.c                                |    1 -
 sound/ppc/pmac.c                                   |  110 ++-
 sound/ppc/powermac.c                               |    1 -
 sound/ppc/snd_ps3.c                                |    2 +-
 sound/ppc/tumbler.c                                |   56 +-
 sound/sh/aica.c                                    |    9 +-
 sound/soc/Kconfig                                  |    1 +
 sound/soc/Makefile                                 |    2 +-
 sound/soc/at91/at91-pcm.c                          |    1 -
 sound/soc/at91/at91-ssc.c                          |    1 -
 sound/soc/at91/eti_b1_wm8731.c                     |    1 -
 sound/soc/codecs/Kconfig                           |    3 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/ac97.c                            |    1 -
 sound/soc/codecs/cs4270.c                          |  262 ++--
 sound/soc/codecs/tlv320aic3x.c                     | 1274 ++++++++++++++
 sound/soc/codecs/tlv320aic3x.h                     |  181 ++
 sound/soc/codecs/wm8731.c                          |    9 +-
 sound/soc/codecs/wm8750.c                          |    3 +-
 sound/soc/codecs/wm8753.c                          |    8 +-
 sound/soc/codecs/wm9712.c                          |   10 +-
 sound/soc/fsl/Kconfig                              |   20 +
 sound/soc/fsl/Makefile                             |    6 +
 sound/soc/fsl/fsl_dma.c                            |  841 +++++++++
 sound/soc/fsl/fsl_dma.h                            |  149 ++
 sound/soc/fsl/fsl_ssi.c                            |  644 +++++++
 sound/soc/fsl/fsl_ssi.h                            |  224 +++
 sound/soc/fsl/mpc8610_hpcd.c                       |  631 +++++++
 sound/soc/pxa/Kconfig                              |    9 +
 sound/soc/pxa/Makefile                             |    2 +
 sound/soc/pxa/corgi.c                              |    1 -
 sound/soc/pxa/e800_wm9712.c                        |   89 +
 sound/soc/pxa/poodle.c                             |    1 -
 sound/soc/pxa/pxa2xx-ac97.c                        |    1 -
 sound/soc/pxa/pxa2xx-i2s.c                         |    1 -
 sound/soc/pxa/pxa2xx-pcm.c                         |    1 -
 sound/soc/pxa/spitz.c                              |    1 -
 sound/soc/pxa/tosa.c                               |    1 -
 sound/soc/s3c24xx/Kconfig                          |   11 +
 sound/soc/s3c24xx/Makefile                         |    4 +
 sound/soc/s3c24xx/ln2440sbc_alc650.c               |   85 +
 sound/soc/s3c24xx/neo1973_wm8753.c                 |    5 +-
 sound/soc/s3c24xx/s3c2412-i2s.c                    |  744 ++++++++
 sound/soc/s3c24xx/s3c2412-i2s.h                    |   38 +
 sound/soc/s3c24xx/s3c2443-ac97.c                   |    5 +-
 sound/soc/s3c24xx/s3c24xx-ac97.h                   |    6 +
 sound/soc/s3c24xx/s3c24xx-i2s.c                    |   45 +-
 sound/soc/s3c24xx/s3c24xx-pcm.c                    |   49 +-
 sound/soc/s3c24xx/smdk2443_wm9710.c                |    1 -
 sound/soc/sh/dma-sh7760.c                          |    1 -
 sound/soc/sh/hac.c                                 |   14 +-
 sound/soc/sh/sh7760-ac97.c                         |    1 -
 sound/soc/sh/ssi.c                                 |    1 -
 sound/soc/soc-core.c                               |  110 +-
 sound/soc/soc-dapm.c                               |   85 +-
 sound/sparc/amd7930.c                              |    3 +-
 sound/sparc/cs4231.c                               |    1 -
 sound/sparc/dbri.c                                 |   20 +-
 sound/spi/at73c213.c                               |   46 +-
 sound/synth/emux/emux.c                            |    1 -
 sound/synth/emux/emux_hwdep.c                      |    1 -
 sound/synth/emux/emux_oss.c                        |    1 -
 sound/synth/emux/emux_proc.c                       |    1 -
 sound/synth/emux/emux_voice.h                      |    1 -
 sound/synth/emux/soundfont.c                       |    1 -
 sound/synth/util_mem.c                             |    1 -
 sound/usb/Kconfig                                  |   14 +-
 sound/usb/caiaq/Makefile                           |    3 +-
 sound/usb/caiaq/caiaq-audio.c                      |    7 +-
 sound/usb/caiaq/caiaq-control.c                    |  315 ++++
 sound/usb/caiaq/caiaq-control.h                    |    6 +
 sound/usb/caiaq/caiaq-device.c                     |   92 +-
 sound/usb/caiaq/caiaq-device.h                     |   20 +-
 sound/usb/caiaq/caiaq-input.c                      |  238 ++-
 sound/usb/caiaq/caiaq-midi.c                       |    3 +-
 sound/usb/usbaudio.c                               |   50 +-
 sound/usb/usbaudio.h                               |    1 +
 sound/usb/usbmidi.c                                |    1 -
 sound/usb/usbmixer.c                               |   34 +-
 sound/usb/usbmixer_maps.c                          |   11 +
 sound/usb/usbquirks.h                              |   28 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |   24 +-
 sound/usb/usx2y/usbusx2y.c                         |    1 -
 sound/usb/usx2y/usbusx2yaudio.c                    |    1 -
 sound/usb/usx2y/usx2yhwdeppcm.c                    |   20 +-
 460 files changed, 24404 insertions(+), 9853 deletions(-)

Andreas Degert (1):
      [ALSA] hdsp: make Multiface II work again

Andrew Morton (2):
      [ALSA] copy_ctl_value_from_user() warning fix
      [ALSA] sound/usb/usbaudio.c: fix build with CONFIG_PM=3Dn

Andrew Paprocki (4):
      [ALSA] hda-codec - Fix definition of AC_KNBCAP_DELTA to match spec
      [ALSA] hda-codec - Add missing #defines (and 1 rename) in hda_codec.h
      [ALSA] hda_intel: Fix multiple device support by incrementing device =
count
      [ALSA] hda_proc - Add a number of new settings to proc codec output

Andy Shevchenko (5):
      [ALSA] hda-codec - Fix typo in the ALC883 initial code
      [ALSA] hda-codec - Initial support of the Mitac 8252D (based on ALC88=
3)
      [ALSA] hda-codec - Add model for Acer Aspire 5315
      [ALSA] fm801 - Add mute support for FM-only card with FM801 PCI to tu=
ner bridge
      [ALSA] hda-codec - Add model for Acer Aspire 5310

Ben Dooks (2):
      [ALSA] ASoC: S3C2412 IIS driver
      [ALSA] S3C2412: suspend and resume support

Claudio Matsuoka (1):
      [ALSA] hda: Fix 5.1 sound in Dell 6stack ALC888 HDA

Clemens Ladisch (44):
      [ALSA] cmipci: disable 'Modem' control on version 39 or newer chips
      [ALSA] cmipci: document 'Modem' control version check
      [ALSA] usb-audio: add UR-80 PCM quirk
      [ALSA] add CMI8788 driver
      [ALSA] add Asus Xonar driver
      [ALSA] oxygen: use uintptr_t in pointer casts
      [ALSA] oxygen: fix channel routing
      [ALSA] oxygen: use an array of snd_kcontrol pointers
      [ALSA] oxygen: make line-in switch exclusive
      [ALSA] oxygen: rename PCM to Master
      [ALSA] oxygen: make AC97 codec optional
      [ALSA] oxygen: make SPI configuration configurable
      [ALSA] oxygen: make all DMA channels configurable
      [ALSA] oxygen: add control filter to model struct
      [ALSA] oxygen: make PCM limits configurable
      [ALSA] oxygen: make the I2S format configurable
      [ALSA] oxygen: add register definitions
      [ALSA] oxygen: fix playback routing
      [ALSA] oxygen: update ALSA-Configuration.txt
      [ALSA] oxygen: remove magic numbers
      [ALSA] oxygen: fix pause handling
      [ALSA] oxygen: remove MIDI autodetection
      [ALSA] oxygen: add more symbols
      [ALSA] oxygen: allow more sample rates with WM8785
      [ALSA] oxygen: reduce SPI clock frequency for AK4396/WM8785
      [ALSA] oxygen: move model-specific data out of common header
      [ALSA] oxygen: fix control filter
      [ALSA] oxygen: fix DAC source register fields
      [ALSA] oxygen: add 192 kHz SPDIF input support
      [ALSA] oxygen: optimize snd_pcm_hardware structures
      [ALSA] oxygen: TempoTec HiFier is probably not supported
      [ALSA] oxygen: add SPDIF loopback control
      [ALSA] oxygen: fix SPDIF input rates
      [ALSA] oxygen: remove MIDI for generic cards
      [ALSA] oxygen: make the number of analog output configurable
      [ALSA] oxygen: more initialization
      [ALSA] add TempoTec HiFier driver
      [ALSA] oxygen: fix AK4396 double rate upper limit
      [ALSA] oxygen: make line-in exclusive only on Xonar
      [ALSA] oxygen: use AC97 interrupt
      [ALSA] oxygen: add front panel controls
      [ALSA] oxygen: add front panel capture
      [ALSA] virtuoso: monitor external power on D2X
      [ALSA] oxygen: revert SPI clock frequency change for AK4396/WM8785

Ctirad Fertr (1):
      [ALSA] emu10k1 - 1616(M) cardbus improvements

Daniel Mack (3):
      [ALSA] caiaq - add control API and more input features
      [ALSA] usb-caiaq - add support for Kore controller 2
      [ALSA] usb/caiaq: decrease period_bytes_min

David Dillow (1):
      [ALSA] sis7019: support the SiS 7019 Audio Accelerator

Dmitry Torokhov (2):
      [ALSA] caiaq - misc input handling fixes
      [ALSA] caiaq - input device support must depend on CONFIG_INPUT

Douglas Kosovic (1):
      [ALSA] hda-codec - Add Dell T3400 support

Graeme Gregory (2):
      [ALSA] soc - Reinitialise DMA on every resume
      [ALSA] soc - Support suspend and resume of the I2S interface on s3c24=
xx

Hans-Christian Egtvedt (1):
      [ALSA] at73c213: replace spinlock in mixer functions with a mutex

Harald Welte (1):
      [ALSA] neo1973: ASoC include pathname fix

Heikki Lindholm (1):
      [ALSA] add number of periods constraint to snd-aoa

Hermann Lauer (1):
      [ALSA] es1938 - improve capture hw pointer reads

Herton Ronaldo Krzesinski (2):
      [ALSA] HDA-Intel - Add support for RV610/RV630 HDMI audio
      [ALSA] hda-codec - Fix capture mixers of ALC662 models

Ian Molton (1):
      [ALSA] soc - Preliminary ac97 drivers for Toshiba e800 PDAs

Ingo Molnar (1):
      [ALSA] snd hda suspend latency: shorten codec read

Ivan Kuten (1):
      [ALSA] soc - ln2440sbc ac97 support

James Courtier-Dutton (4):
      [ALSA] emu10k1: Add mixer controls parameter checking.
      [ALSA] emu10k1: Add comments regarding E-Mu ins and outs.
      [ALSA] snd:emu10k1: E-Mu updates. Fixes to firmware loading and suppo=
rt for 0404.
      [ALSA] emu10k1: General cleanup, add new locks, fix alsa bug#3501, ke=
rnel bug#9304.

Jaroslav Kysela (7):
      [ALSA] Use posix clock monotonic for PCM and timer timestamps
      [ALSA] PCM - fixed SNDRV_PCM_FORMAT_U24_BE silence constant
      [ALSA] PCM - added back TSTAMP ioctl for PCM (for old alsa-lib binari=
es)
      [ALSA] PCM core - remove SNDRV_PCM_TSTAMP_MMAP condition in snd_pcm_s=
tatus()
      [ALSA] PCM interface - rename SNDRV_PCM_TSTAMP_MMAP to SNDRV_PCM_TSTA=
MP_ENABLE
      [ALSA] ice1712 - fixed midi input for Hoontech C-Ports
      [ALSA] version 1.0.16rc2

Jason Gaston (1):
      [ALSA] hda_intel: ALSA HD Audio patch for Intel ICH10 DeviceID's

Jerone Young (1):
      [ALSA] hda-codec - Add IEC958 digital out support for Lenovo Thinkpad=
s T61/X61

Jiang Zhe (6):
      [ALSA] hda-codec - Update dell-m82 model pin config
      [ALSA] hda-codec - Add workaround for multiple HPs
      [ALSA] hda-codec - Avoid wrong speaker-auto mute via mic jack
      [ALSA] hda-codec - Device ID for Toshiba laptop which uses AD1986A
      [ALSA] hda-codec - alc268 input_mux should be a selector instead of m=
ixer
      [ALSA] hda-codec - New model for conexant 5045 codec to support benq =
r55e

Jiang zhe (3):
      [ALSA] hda-codec - Device ID for Macbook sound card
      [ALSA] hda-codec - Fix capture source for Cx5045 codec
      [ALSA] hda-codec - Add model for Gigabyte P35 DS3R

Jiri Olsa (1):
      [ALSA] sound: remove dead config symbol from sound code

Joachim Foerster (2):
      [ALSA] Xilinx ML403 AC97 Controller Reference device driver
      [ALSA] [ML403-AC97CR] Fix capture/periodic overrun bug

Joe Perches (3):
      [ALSA] sound/isa: Add missing 'space'
      [ALSA] sound/: Spelling fixes
      [ALSA] include/sound/: Spelling fixes

Joe Sauer (1):
      [ALSA] Fix inverted Phone volume WM9712 mixer control

Johannes Stezenbach (1):
      [ALSA] hda-intel: Enable Analog CD Input from internal ATAPI connecto=
r on Asus M2N-SLI

Jonathan Woithe (2):
      [ALSA] hda-codec - Add EAPD controls for ALC260 test model
      [ALSA] hda-codec - Add test model for ALC268

Josepch Chan (1):
      [ALSA] hda-codec - Add  support for VIA VT1708B HD audio codec

Julia Lawall (3):
      [ALSA] sound/pci: Drop unnecessary continue
      [ALSA] sound/core/memalloc.c: Add missing pci_dev_put
      [ALSA] sound: Use time_before, time_before_eq, etc.

Julian Scheel (2):
      [ALSA] ICE1724: Added support for Audiotrak Prodigy 7.1 HiFi & HD2, H=
ercules Fortissimo IV
      [ALSA] ice1724 - Add missing prodigy_hifi.h

Kailang Yang (3):
      [ALSA] hda-codec - Add support of HP Thin Client T5735
      [ALSA] hda-codec - Add ALC889/ALC267/ALC269 support
      [ALSA] hda-codec - Update realtek codec support

Kamalesh Babulal (1):
      [ALSA] powermac - Fix typos

Krzysztof Helt (3):
      [ALSA] ac97_patch: compilation warning fix
      [ALSA] es18xx: Enable wavetable input from ESS chips
      [ALSA] cs4231: remove one busy wait

Laim Girdwood (1):
      [ALSA] soc - Add support for passing kcontrols with events

Liam Girdwood (5):
      [ALSA] soc - Add device level DAPM event
      [ALSA] soc - Add D1 power event to power down event sequence
      [ALSA] soc - Ensure PCMs are suspended
      [ALSA] soc - Clean up tabs
      [ALSA] soc - Initial WM8753 TLV support for capture mixer

Manuel Lauss (1):
      [ALSA] ASoC: sh: improve generated code for HAC module (AC97)

Marc Boucher (5):
      [ALSA] hda-codec - Fix laptop models for Cxt5045
      [ALSA] hda-codec - Add missing input controls for Cxt5047 test model
      [ALSA] hda-codec - Add a delay after power state change
      [ALSA] hda-intel - Add ratelimit to timeout messages
      [ALSA] hda-codec - Add afg and mfg preset mask

Marcin =C5=9Alusarz (7):
      [ALSA] pcm_native: fix sparse warning about shadowing 'state' symbol
      [ALSA] via82xx: minor optimization in snd_via82xx_free
      [ALSA] pcm_lib: fix sparse warning about shadowing 'n' symbol
      [ALSA] pcm_lib: fix sparse warning about different signedness
      [ALSA] info_oss: move prototype of snd_card_info_read_oss to info.h
      [ALSA] sound/core/seq: move declarations of globally visible variable=
s to proper headers
      [ALSA] rawmidi: let sparse know what is going on _for real_

Mark Brown (5):
      [ALSA] Update MAINTAINERS for ALSA SoC
      [ALSA] soc - Don't lock the codec list in snd_soc_dapm_new_widgets()
      [ALSA] Bump ASoC core version number
      [ALSA] Fix lockdep warning in ASoC machine probe
      [ALSA] ASoC documentation updates

Matthew Ranostay (24):
      [ALSA] hda-codec - Add STAC9228 DMIC support
      [ALSA] hda: Add dmux to STAC 9228
      [ALSA] hda: STAC9228 updated DMUX nid
      [ALSA] hda: STAC9228 DMIC
      [ALSA] hda: Added new IDT codec family
      [ALSA] hda: STAC92HD71 codec mixer
      [ALSA] hda: STAC9228 Subsystem update
      [ALSA] hda: Added STAC92HD73 support
      [ALSA] hda: 92HD73 DMIC Amps
      [ALSA] hda: Added more 92HD71 codecs
      [ALSA] hda: STAC927x DMIC Cleanup
      [ALSA] hda: STAC927x VREF fix
      [ALSA] hda: Dynamically create digital gain mixers
      [ALSA] hda: 92HD71BXX Mono Mute Support
      [ALSA] hda: STAC9228 VT fixes
      [ALSA] hda: 92HD7XXX power management support
      [ALSA] hda: Add new STAC9205 PCI_QUIRK
      [ALSA] hda: Mono mux mixer support
      [ALSA] hda: Added mono_out_pin to autoconfig
      [ALSA] hda: Add dynamic mono mixer support for STAC92xx codecs
      [ALSA] hda: STAC9205 GPIO line fix
      [ALSA] hda: STAC92xx Line In/Mic as output check
      [ALSA] hda: Add GPIO mute support to STAC9205
      [ALSA] hda: fix Mic in as output

Michael Opdenacker (1):
      [ALSA] writing-an-alsa-driver.tmpl: English style improvements

Miguel Boton (1):
      [ALSA] fix compilation warning in GCC

Mike Rapoport (1):
      [ALSA] soc - Add 'Mono Playback Switch' to WM9712 codec driver

Milan plzik (1):
      [ALSA] soc - Fix power switching support for DAPM_SWITCH widgets

Nick Piggin (2):
      [ALSA] alsa: nopage
      [ALSA] alsa: usx2y nopage

Nicolas Kaiser (2):
      [ALSA] sound/pci: remove line duplications in defines
      [ALSA] sound/pci: remove duplicated defines

Oliver Neukum (1):
      [ALSA] usb audio suspend support

Pavel Hofman (2):
      [ALSA] I2C fix for ice1724
      [ALSA] switching rate in STAC9460 codec of Prodigy192

Philipp Zabel (1):
      [ALSA] ASoC TLV support

Randy Dunlap (7):
      [ALSA] sound: fix mts64 section mismatches
      [ALSA] sound: fix ad1889 section mismatch
      [ALSA] sound: fix atiixp section mismatch
      [ALSA] sound: fix rme9652 section mismatch
      [ALSA] sound: fix caiaq section mismatches
      [ALSA] fix cs5535 section mismatch
      [ALSA] fix opti9xx/miro section mismatch

Rene Herman (2):
      [ALSA] sound/isa: kill pnp_resource_change
      [ALSA] Update descriptions of isapnp-specific module options

Shin-ya Okada (1):
      [ALSA] ice1724 - Add support of Onkyo SE-90PCI and SE-200PCI

Stanislav Brabec (1):
      [ALSA] use convenient treble scale on WM8750

T. H. Huth (1):
      [ALSA] snd-powermac: handle dead DMA transfers

Takashi Iwai (88):
      [ALSA] hda-codec - Add missing eeepc-p701 model for ALC662
      [ALSA] hda-codec - Add model for Fujitsu V5505
      [ALSA] ad1848 - Fix print format
      [ALSA] via82xx - Fix quirk for Shuttle AK32VN
      [ALSA] hda-codec - Show more information in proc file
      [ALSA] Introduce slots option to snd module
      [ALSA] Dreamcast AICA sound - Get rid of annoying compiler warning
      [ALSA] opl3 - Use hwdep for patch loading
      [ALSA] opl3 - simplify exclusive access lock
      [ALSA] Remove sequencer instrument layer
      [ALSA] opl3 - Fix build errors
      [ALSA] hda-codec - Improve the auto-configuration
      [ALSA] hda-codec - new PCI SSID for HP machines
      [ALSA] Update SNDRV_HWDEP_IFACE_LAST
      [ALSA] hda-codec - Add model=3Dhp-tc-t5735 for ALC262
      [ALSA] emu10k1 - Check value ranges in ctl callbacks
      [ALSA] hda-codec - Check value range in ctl callbacks
      [ALSA] ice1724 - Check value ranges in ctl callbacks
      [ALSA] mixart - Check value range in ctl callbacks
      [ALSA] pci - check value range in ctl callbacks
      [ALSA] ice1724 - Clean up ctl callbacks in se.c
      [ALSA] vxpocket - Check value range in ctl callbacks
      [ALSA] powermac - Check value range in ctl callbacks
      [ALSA] ak4xxx - Check value ranges in ctl callbacks
      [ALSA] aoa - Check value range in ctl callbacks
      [ALSA] Check value range in ctl callbacks
      [ALSA] at73c213 - Use common callback
      [ALSA] hda-intel - Show more volume-knob attributes
      [ALSA] hda-codec - Revert volume knob controls in STAC codecs
      [ALSA] dbri - Fix broken change for value range checks
      [ALSA] caiaq - Fix indent in Kconfig
      [ALSA] caiaq - remove ifdef
      [ALSA] Fix PCM MMAP time-stamp mode
      [ALSA] aoa - fix compile warning
      [ALSA] emu10k1x - Add missing snd_card_set_dev call
      [ALSA] drivers - Add missing snd_card_set_dev()
      [ALSA] ice1712 - Fix word clock status control on Delta 1010LT
      [ALSA] echoaudio - convert from semaphore to mutex
      [ALSA] hda-codec - Device ID for MSI L745
      [ALSA] Fix old tstamp ioctl for compat_ioctl
      [ALSA] sb16 - Suppress compile warning
      [ALSA] Add SNDRV_PCM_IOCTL_TSTAMP back to compat ioctl
      [ALSA] hda-codec - Avoid overload of PCM volume on Cx5045 codec
      [ALSA] Add missing device link
      [ALSA] hda-codec - sort pci quirk list
      [ALSA] hda-codec - Fix invalid access to non-existing dmux on STAC
      [ALSA] hda-codec - Sort ad1986a cfg table
      [ALSA] hda-intel - Support multiple devices
      [ALSA] hda-codec - Add model=3Dlaptop for HP 350 laptop
      [ALSA] Remove indirect control access
      [ALSA] Fix PCM write blocking
      [ALSA] Remove PCM xfer_align sw params
      [ALSA] PCM - clean up snd_pcm_lib_read/write
      [ALSA] Remove PCM sleep_min and tick
      [ALSA] Remove sound/driver.h
      [ALSA] Add virtual master control helpers
      [ALSA] hda-codec - Add virtual master controls
      [ALSA] hda-codec - print control name in error messages
      [ALSA] hda-codec - Don't build boost controls for digital mics
      [ALSA] hda-codec - Remove obsolete FIXME's
      [ALSA] hda-code - Clean up STAC GPIO enablement code
      [ALSA] hda-codec - Disable PCBEEP mixer element in test model
      [ALSA] hda-codec - Add the support of Dell OEM laptops with ALC268
      [ALSA] hda-codec - Enable VIA SPDIF input pin
      [ALSA] hda-intel - Add workarounds for STAC codecs
      [ALSA] Add missing model for HD-audio Cx5045 codec
      [ALSA] ice1712, ice1724 - Code clean up
      [ALSA] hda-intel - Make azx_get_response() a bit more robust
      [ALSA] emu10k1 - Fix over-sized kmalloc for TLV
      [ALSA] cs5535audio - Fix available sample rates
      [ALSA] hda-codec - Optimize snd_hda_pser_pin_def_config()
      [ALSA] hda-codec - Don't query widget parameter for invalid NID
      [ALSA] hda-codec - Fix handling of multiple capture streams
      [ALSA] hda-codec - Add Conexant 5051 codec support
      [ALSA] hda-codec - Add missing slave for AD1884 master switch
      [ALSA] hda-codec - Add SPDIF controls as slave on AD codecs
      [ALSA] hda-codec - Add SPDIF output support to AD1986a laptop-eapd mo=
del
      [ALSA] hda-codec - Rename non-standard 'iSpeaker'
      [ALSA] hda-codec - Fix mixer controls with ALC262 HP T5735 model
      [ALSA] hda-codec - Fix ALC262 HP-RP5700 model
      [ALSA] hda-codec - Add speaker automute to ALC260 HP models
      [ALSA] hda-codec - Add speaker automute to ALC262 HP models
      [ALSA] Fix Oops with PCM OSS sync
      [ALSA] hda-codec - Control SPDIF as slave
      [ALSA] hda-codec - Add model for HP DV9553EG laptop
      [ALSA] emu10k1 - Don't create emu1010 controls for non-emu boards
      [ALSA] emu10k1 - Use enum for emu_model types
      [ALSA] emu10k1 - Fix kthread handling at resume

Timofei Bondarenko (4):
      [ALSA] usb-audio - SB Live24-External better handling
      [ALSA] cmipci at 96kHz
      [ALSA] cmipci - utilize ADC48K44K bit
      [ALSA] cmipci - allow capture of raw spdif subframes

Timur Tabi (3):
      [ALSA] cs4270: wrong sample rate when CONFIG_SND_SOC_CS4270_VD33_ERRA=
TA is set
      [ALSA] Add ASoC drivers for the Freescale MPC8610 SoC
      [ALSA] mpc8610: Add mmap support

Tobin Davis (4):
      [ALSA] HDA: Add support for Samsung Q1 Ultra Vista edition
      [ALSA] HDA: Add Asus VX1 support
      [ALSA] HDA: Enable chipset gcap usage
      [ALSA] HDA-Intel - Add support for Intel SCH

Vasily Khoruzhick (1):
      [ALSA] hda-codec - remove 11c1:1040 from patch_si3054.c id list

Veli-Matti Valtonen (1):
      [ALSA] emu10k1 - Another EMU0404 Board ID

Ville Syrjala (1):
      [ALSA] soc/wm8731: Fix stereo mixer controls

Vladimir Barinov (1):
      [ALSA] ASoC TLV320AIC3X codec driver

Wolke Liu (1):
      [ALSA] HDA-Intel - Add support for RV6xx HDMI audio

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.
--8323584-1980695349-1201799072=:6131--
