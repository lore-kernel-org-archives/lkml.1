Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbXBOG02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbXBOG02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXBOG02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:26:28 -0500
Received: from 20151255138.user.veloxzone.com.br ([201.51.255.138]:4468 "EHLO
	areia.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbXBOG01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:26:27 -0500
X-Greylist: delayed 1590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 01:26:26 EST
Subject: [PATCH 000/196] V4L/DVB updates
From: Mauro Carvalho Chehab <mchehab@linuxtv.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Feb 2007 03:59:55 -0200
Message-Id: <1171519195.6703.25.camel@areia>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull 'master' from:
        git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

Basically, this series adds support for a bunch of newer cards and newer
drivers, do some relevant cleanups on cx88 (improving source code 
readability and reducing binary code size), adds FM radio support on
pvrusb2 and do several other fixes and improvements.

A more detailed log:

   - Add support for the ASUS P7131 remote control
   - Add the Composite over S-Video input on the Asus P7131 Dual
   - Update cx2341x documentation.
   - Update cx2341x documentation.
   - Removed unimplemented cx2341x API commands
   - Improve cx2341x documentation
   - Saa7134: add support for the Encore ENL-TV
   - Updated cardlist to reflect the newly added saa7134 board
   - DIB3000MC and NOVA T USB2 #2
   - Cablestar2 support
   - DVB: Remove unneeded void * casts in ttpci/av7110
   - Remove some unused code from kernel mainstream
   - Add support for more Encore TV cards
   - DVB: fix compile error
   - Make usbvision_rvfree() static
   - MAINTAINERS: tag pvrusb2 list as subscribers-only
   - Pvrusb2-hdw kfree cleanup
   - Cpia module_put cleanup
   - Tvmixer module_put cleanup
   - Cleanup: switch to using msecs_to_jiffies() on bttv
   - Improves some USBVision info messages
   - Bt8xx: add support for Ultraview DVB-T Lite
   - SN9C102 driver updates
   - ZC0301 driver updates.
   - ET61X251 driver updates.
   - Fix authorship references
   - Budget-ci: add support for the Technotrend 1500 bundled remote
   - Fix OOPS on some waitqueue conditions
   - Some fixes at stream waitqueue on vivi
   - Pvrusb2: Enable radio mode round #1
   - Pvrusb2: Enable radio mode round #2
   - Pvrusb2: Fix for min/max control value checking
   - Pvrusb2: Implement multiple minor device number handling
   - Pvrusb2: Implement stream claim checking function
   - Pvrusb2: Implement /dev/radioX
   - Pvrusb2: Use enumeration for minor number get / store code
   - Pvrusb2: Use separate enumeration for get/store of minor number
   - Pvrusb2: Make units uniform when tracking tuning frequency
   - Pvrusb2: video standard broadcast fix for radio mode
   - Pvrusb2: Allow overriding vbi and radio device minor numbers
   - Pvrusb2: Fix heap corruption introduced by radio mods
   - Pvrusb2: Fix tuner frequency calculation
   - Pvrusb2: Fix tuning calculation when in radio mode
   - Pvrusb2: v4l2 API implementation frequency tweaks
   - Pvrusb2: Enable radio mode for 24xxx devices
   - Pvrusb2: Newer frequency range checking
   - Pvrusb2: Better radio versus tv frequency handling
   - Pvrusb2: Remove stream claiming hack from /dev/radio
   - Pvrusb2: Change default volume to something sane
   - Pvrusb2: cosmetic comment tweak
   - Pvrusb2: Fix cut/paste bug in auto_mode_switch control
   - Pvrusb2: Stream configuration cleanups
   - Pvrusb2: bug fix involving switch into radio mode
   - Pvrusb2: Be smarter about mode restoration
   - Cpia.c: buffer overflow
   - Bttv cropping support
   - Pvrusb2: It's safe to kfree() a null pointer
   - Pvrusb2: Use kzalloc instead of kmalloc+memset pairs
   - Pvrusb2: Allow streaming from /dev/radioX
   - Pvrusb2: VIDIOC_G_TUNER cleanup
   - Pvrusb2: Slight debug printing efficiency fixup
   - Pvrusb2: Remove automodeswitch control
   - Pvrusb2: Stop hardcoding frequency ranges
   - Pvrusb2: trace print added
   - Pvrusb2: Fix missing break statement on VIDIOC_S_TUNER
   - Pvrusb2: Fix sizeof() calculation foul-up
   - Pvrusb2: Minor dead code / comment cleanups
   - Pvrusb2: V4L EXT_CTRLS fixup
   - Pvrusb2: A patch to use ARRAY_SIZE macro when appropriate
   - Pvrusb2: Use kzalloc in place of kmalloc/memset pairs
   - Pvrusb2: Use ARRAY_SIZE wherever possible
   - Pvrusb2: Emit VIDIOC_S_TUNER correctly
   - Pvrusb2: Introduce fake audio input selection
   - Pvrusb2: Allow VIDIOC_S_FMT with -1 for resolution values
   - Convert cx8800 driver to video_ioctl2 handler
   - Added support for V4L2_STD_NTSC_443
   - Uncommented NTSC/443 video standard
   - Make cx88-blackbird to work again
   - Renamed video_mux to cx88_video_mux
   - make videodev to auto-generate standards
   - Fix vidioc_g_tuner handling
   - Moved several stuff that were at cx88-video to cx88-blackbird.c
   - Reorder some ioctl handlers
   - Do some cleanups at cx88-blackbird
   - Use cx88_set_freq() on cx88-blackbird.c
   - Remove_cx88_ioctl
   - Convert cx88-blackbird to use video_ioctl2
   - Keep the previous tvnorm default for cx88 and cx88-blackbird
   - Saa7134: add support for Terratec Cinergy HT PCI
   - Adds video output routing
   - Cx88: Add support for svideo/composite input of the Terratec
Cinergy 1400 DVB-T
   - Remove some warnings when compiling on x86_64
   - Fix: VIDIOC_G_TUNER were returning an endless number of tuners
   - Various cx2341x documentation updates/fixes.
   - Proper vendor/device ID for the CinergyT2 input device
   - Dvb-usb: Initial support for MSI Mega Sky 580 based on Uli m9206
   - Dvb-usb: rename megasky.[ch] to m920x.[ch]
   - M920x: cleanups after rename from megasky.[ch]
   - M920x: update megasky driver for recent changes in the dvb tree
   - M920x: trivial cleanups
   - M920x: break out qt1010 tuner code into a separate file
   - M920x: misc updates and fixes
   - M920x: more cleanups
   - M920x: more trivial cleanups
   - M920x: move qt1010_tuner_attach function into qt1010.h
   - M920x: fix build in hg tree / other trivial fixes
   - Qt1010: correct hardlockup when an app access the DVB dongle
   - M920x: correct oops when loading module
   - Dvb: add new qt1010 tuner module
   - Kconfig: qt1010 should be selected by m920x
   - M920x: Fix tuner identification bug with qt1010 module
   - Whitespace / 80-column cleanups
   - M920x: group tuner / demod callback functions together
   - M920x: move filter caps from device caps to adapter caps
   - Restore VIDIOC_INT_[SG]_REGISTER calls
   - Make VIDIOC_INT_[SG]_REGISTER ioctls no longer internal only
   - Make vivi driver to use vmalloced pointers
   - Convert radio-aztech to use video_ioctl2
   - Convert radio-maxiradio to use video_ioctl2
   - Implement VIDIOC_[GS]_AUDIO on maxiradio
   - Implement VIDIOC_[GS]_AUDIO on aztech
   - Implements VIDIOC_[S|G]_INPUT on radio-aztech/radio-maxiradio
   - Make it coherent with vidioc_g_tuner
   - Add some debug info, depending on debug level
   - Properly initialize mute and radio frequency
   - Fix: dma free is being called with wrong arguments
   - Set phys, bustype, version, vendor and product for input device
   - Dvb-ttpci: Fixed unregistering the vbi device
   - Saa7146_vv: pass correct memory size to pci_free_consistent
   - Dvb-ttpci: call saa7146_vv_release() on exit
   - Change VIDIOC_DBG_[SG]_REGISTER ioctls' reg address to 64 bits
   - Add checks for CAP_SYS_ADMIN to VIDIOC_DBG_G_REGISTER
   - Compat: Handle input_register_device() change and some others
   - Remove obsolete alias defines of CONFIG_* settings
   - Pvrusb2: Use macro names for FX2 commands
   - Pvrusb2: Add boilerplate to new header file
   - Pvrusb2: Control protocol cleanup
   - Pvrusb2: encoder comm protocol cleanup
   - Pvrusb2: video corruption fixes
   - Pvrusb2: VIDIOC_DBG_[S|G]_REGISTER fixups
   - Cx2341x encoder documentation update.
   - Fix cx2584x revision reporting.
   - Sliced VBI API no longer marked experimental.
   - Remove #if 0 section from videodev2.h
   - Fix CC handling in VIDIOC_INT_G_VBI_DATA
   - Add cx23415 decoder register documentation
   - Add separate configuration data for subsystem 0x13c2:0x1012
   - Budget-av: Call saa7146_vv_release on exit
   - Remove the unused kernel config option VIDEO_VIDEOBUF
   - Frontends: make 4 functions static
   - VIDEO_BUF depends on PCI
   - Convert to generic boolean-values
   - Cafe_ccic.c fix warning
   - Cx88-video.c: remove struct radionorms
   - Radio/: Convert to generic boolean-values
   - DVB: Use ARRAY_SIZE macro when appropriate
   - Change videodev2.h licence to dual GPL/BSD
   - V4l_printk_ioctl_arg() is no longer used.
   - Usbvision: dynamic allocation for frames
   - Usbvision: set alternate interface modification
   - Kthread API conversion for dvb_frontend and av7110
   - Kthread api conversion for dvb_frontend and av7110 fix
   - Pvrusb2: Fix printk format typo
   - Pvrusb2: Be more forgiving about encoder firmware size
   - Experimental support for signal strength/BER/uncorrectable count
   - Zl10353: add i2c_gate_ctrl support
   - Zl10353: Implement TRL nominal rate calculation
   - Zl10353: register definitions update
   - Dvb-usb: initial support for MSI Mega Sky 580 DVB-T based on GL861
   - Rename USB_PID_MSI_MEGASKY55801 to USB_PID_MSI_MEGASKY580_55801
   - Gl861: select DVB_ZL10353 if !DVB_FE_CUSTOMISE
   - Gl861: fix MODULE_AUTHOR
   - Gl861: fix driver_name
   - Gl861: hide disabled code from upstream patch system
   - Gl861: remove unneeded "extern int" declaration
   - Gl861: use qt1010_tuner_attach function from qt1010.h
   - Gl861: remove NULL entry from gl861_properties
   - Gl861: whitespace cleanups
   - Gl861: correct oops when loading module
   - Gl861: correct address of the bulk endpoint
   - Gl861: remove unneeded declaration
   - Gl861: use parallel_ts
   - Initial support for Sigmatek DVB-110 DVB-T
   - Dvb: add new qt1010 tuner module
   - Kconfig: qt1010 should be selected by gl861 and au6610
   - Whitespace / 80-column cleanups
   - Qt1010: use i2c_gate_ctrl where appropriate
   - Avoid race when deregistering the IR control for dvb-usb
   - Dvbdev: fix illegal re-usage of fileoperations struct
   - Dvb-ttpci: use i2c gate ctrl from stv0297 frontend driver
   - Budget-ci: IR handling fixups
   - Stv0297: Enable BER/UNC counting
   - Fix compiler warning in vivi.c
   - Qt1010: fix compiler warning
   - Qt1010: use ARRAY_SIZE macro when appropriate
   - Qt1010: whitespace / 80 column cleanups

Cheers,
Mauro.

PS.: Due to the size of this series, I'm not mailbombing them into LKML.

V4L/DVB development is hosted at http://linuxtv.org
---

 Documentation/video4linux/CARDLIST.bttv            |    2 
 Documentation/video4linux/CARDLIST.saa7134         |    3 
 Documentation/video4linux/CQcam.txt                |    6 
 Documentation/video4linux/Zoran                    |    4 
 .../video4linux/cx2341x/fw-decoder-api.txt         |   58 -
 .../video4linux/cx2341x/fw-decoder-regs.txt        |  815 ++++++++++++++++
 Documentation/video4linux/cx2341x/fw-dma.txt       |   16 
 .../video4linux/cx2341x/fw-encoder-api.txt         |   52 +
 Documentation/video4linux/cx2341x/fw-memory.txt    |   10 
 Documentation/video4linux/et61x251.txt             |    7 
 Documentation/video4linux/sn9c102.txt              |  246 +++-
 Documentation/video4linux/zc0301.txt               |   10 
 MAINTAINERS                                        |    2 
 drivers/media/Kconfig                              |    1 
 drivers/media/common/Kconfig                       |    4 
 drivers/media/common/ir-functions.c                |  110 ++
 drivers/media/common/ir-keymaps.c                  |  171 +++
 drivers/media/common/saa7146_fops.c                |    2 
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |   90 +-
 drivers/media/dvb/bt8xx/bt878.c                    |    1 
 drivers/media/dvb/bt8xx/dst.c                      |    2 
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    3 
 drivers/media/dvb/cinergyT2/cinergyT2.c            |    5 
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   71 -
 drivers/media/dvb/dvb-core/dvbdev.c                |   17 
 drivers/media/dvb/dvb-usb/Kconfig                  |   28 
 drivers/media/dvb/dvb-usb/Makefile                 |    9 
 drivers/media/dvb/dvb-usb/au6610.c                 |  255 ++++
 drivers/media/dvb/dvb-usb/au6610.h                 |   19 
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    5 
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    2 
 drivers/media/dvb/dvb-usb/gl861.c                  |  231 ++++
 drivers/media/dvb/dvb-usb/gl861.h                  |   15 
 drivers/media/dvb/dvb-usb/m920x.c                  |  541 +++++++++
 drivers/media/dvb/dvb-usb/m920x.h                  |   35 +
 drivers/media/dvb/frontends/Kconfig                |    7 
 drivers/media/dvb/frontends/Makefile               |    1 
 drivers/media/dvb/frontends/cx24110.c              |    4 
 drivers/media/dvb/frontends/cx24123.c              |    6 
 drivers/media/dvb/frontends/dib3000mc.c            |    2 
 drivers/media/dvb/frontends/qt1010.c               |  485 ++++++++
 drivers/media/dvb/frontends/qt1010.h               |   53 +
 drivers/media/dvb/frontends/qt1010_priv.h          |  105 ++
 drivers/media/dvb/frontends/stv0297.c              |   19 
 drivers/media/dvb/frontends/stv0299.c              |    2 
 drivers/media/dvb/frontends/tda10021.c             |    2 
 drivers/media/dvb/frontends/tda1004x.c             |    2 
 drivers/media/dvb/frontends/zl10353.c              |  103 ++
 drivers/media/dvb/frontends/zl10353.h              |    3 
 drivers/media/dvb/frontends/zl10353_priv.h         |   36 -
 drivers/media/dvb/ttpci/av7110.c                   |   57 -
 drivers/media/dvb/ttpci/av7110.h                   |    2 
 drivers/media/dvb/ttpci/av7110_av.c                |   42 -
 drivers/media/dvb/ttpci/av7110_ca.c                |   22 
 drivers/media/dvb/ttpci/av7110_ir.c                |   18 
 drivers/media/dvb/ttpci/av7110_v4l.c               |   30 -
 drivers/media/dvb/ttpci/budget-av.c                |    3 
 drivers/media/dvb/ttpci/budget-ci.c                |   55 +
 drivers/media/dvb/ttusb-dec/ttusb_dec.c            |    4 
 drivers/media/radio/radio-aztech.c                 |  278 +++--
 drivers/media/radio/radio-gemtek-pci.c             |   18 
 drivers/media/radio/radio-maxiradio.c              |  354 ++++--
 drivers/media/video/Kconfig                        |    2 
 drivers/media/video/Makefile                       |    1 
 drivers/media/video/bt8xx/bttv-cards.c             |   23 
 drivers/media/video/bt8xx/bttv-driver.c            |  893 +++++++++++++--
 drivers/media/video/bt8xx/bttv-input.c             |  157 ---
 drivers/media/video/bt8xx/bttv-risc.c              |  171 ++-
 drivers/media/video/bt8xx/bttv-vbi.c               |  368 +++++-
 drivers/media/video/bt8xx/bttv.h                   |   27 
 drivers/media/video/bt8xx/bttvp.h                  |   90 +-
 drivers/media/video/cafe_ccic.c                    |    2 
 drivers/media/video/cpia.c                         |   11 
 drivers/media/video/cx2341x.c                      |   17 
 drivers/media/video/cx25840/cx25840-core.c         |   22 
 drivers/media/video/cx88/Makefile                  |    5 
 drivers/media/video/cx88/cx88-blackbird.c          |  567 ++++++----
 drivers/media/video/cx88/cx88-cards.c              |    6 
 drivers/media/video/cx88/cx88-core.c               |  102 +-
 drivers/media/video/cx88/cx88-dvb.c                |   10 
 drivers/media/video/cx88/cx88-i2c.c                |    2 
 drivers/media/video/cx88/cx88-tvaudio.c            |   49 -
 drivers/media/video/cx88/cx88-vbi.c                |   11 
 drivers/media/video/cx88/cx88-video.c              | 1166 +++++++++-----------
 drivers/media/video/cx88/cx88.h                    |   54 -
 drivers/media/video/et61x251/et61x251.h            |    5 
 drivers/media/video/et61x251/et61x251_core.c       |  129 +-
 drivers/media/video/et61x251/et61x251_sensor.h     |    4 
 drivers/media/video/et61x251/et61x251_tas5130d1b.c |    2 
 drivers/media/video/pvrusb2/pvrusb2-audio.c        |   46 -
 drivers/media/video/pvrusb2/pvrusb2-context.c      |    3 
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |   45 -
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c  |   27 
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |    4 
 drivers/media/video/pvrusb2/pvrusb2-eeprom.c       |    5 
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |  269 +++--
 drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h      |   62 +
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |   36 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |  501 ++++++---
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |   39 -
 .../media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c   |   16 
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c |   69 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h |    3 
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |   41 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.h     |    3 
 drivers/media/video/pvrusb2/pvrusb2-io.c           |    3 
 drivers/media/video/pvrusb2/pvrusb2-ioread.c       |    3 
 drivers/media/video/pvrusb2/pvrusb2-std.c          |   28 
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   52 +
 drivers/media/video/pvrusb2/pvrusb2-tuner.c        |    3 
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |  335 ++++--
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c    |   29 
 drivers/media/video/pvrusb2/pvrusb2-wm8775.c       |   28 
 drivers/media/video/pwc/Makefile                   |    8 
 drivers/media/video/pwc/pwc-if.c                   |    8 
 drivers/media/video/pwc/pwc-v4l.c                  |    2 
 drivers/media/video/pwc/pwc.h                      |    9 
 drivers/media/video/saa5246a.c                     |   10 
 drivers/media/video/saa5246a.h                     |    9 
 drivers/media/video/saa5249.c                      |   41 -
 drivers/media/video/saa7115.c                      |   57 +
 drivers/media/video/saa7127.c                      |   18 
 drivers/media/video/saa7134/Makefile               |    4 
 drivers/media/video/saa7134/saa7134-cards.c        |  140 ++
 drivers/media/video/saa7134/saa7134-dvb.c          |   12 
 drivers/media/video/saa7134/saa7134-i2c.c          |   24 
 drivers/media/video/saa7134/saa7134-input.c        |   93 +-
 drivers/media/video/saa7134/saa7134.h              |   30 -
 drivers/media/video/sn9c102/Kconfig                |    4 
 drivers/media/video/sn9c102/Makefile               |    2 
 drivers/media/video/sn9c102/sn9c102.h              |   57 -
 drivers/media/video/sn9c102/sn9c102_config.h       |   86 +
 drivers/media/video/sn9c102/sn9c102_core.c         |  719 ++++++++++--
 drivers/media/video/sn9c102/sn9c102_devtable.h     |  142 ++
 drivers/media/video/sn9c102/sn9c102_hv7131d.c      |    7 
 drivers/media/video/sn9c102/sn9c102_mi0343.c       |    7 
 drivers/media/video/sn9c102/sn9c102_ov7630.c       |  336 +++---
 drivers/media/video/sn9c102/sn9c102_ov7660.c       |  592 ++++++++++
 drivers/media/video/sn9c102/sn9c102_pas106b.c      |    7 
 drivers/media/video/sn9c102/sn9c102_pas202bca.c    |  238 ----
 drivers/media/video/sn9c102/sn9c102_pas202bcb.c    |   97 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h       |  168 +--
 drivers/media/video/sn9c102/sn9c102_tas5110c1b.c   |    8 
 drivers/media/video/sn9c102/sn9c102_tas5130d1b.c   |    8 
 drivers/media/video/tvmixer.c                      |    3 
 drivers/media/video/tvp5150.c                      |   18 
 drivers/media/video/upd64031a.c                    |   20 
 drivers/media/video/upd64083.c                     |   20 
 drivers/media/video/usbvision/Kconfig              |    2 
 drivers/media/video/usbvision/usbvision-core.c     |   70 +
 drivers/media/video/usbvision/usbvision-video.c    |  172 ++-
 drivers/media/video/usbvision/usbvision.h          |   11 
 drivers/media/video/v4l1-compat.c                  |    2 
 drivers/media/video/v4l2-common.c                  |  591 ----------
 drivers/media/video/video-buf.c                    |    3 
 drivers/media/video/videodev.c                     |   20 
 drivers/media/video/vivi.c                         |  102 +-
 drivers/media/video/zc0301/zc0301.h                |    4 
 drivers/media/video/zc0301/zc0301_core.c           |   55 +
 drivers/media/video/zc0301/zc0301_pas202bcb.c      |    4 
 drivers/media/video/zc0301/zc0301_pb0330.c         |    4 
 drivers/media/video/zc0301/zc0301_sensor.h         |   12 
 include/linux/videodev2.h                          |   71 +
 include/media/cx2341x.h                            |    4 
 include/media/ir-common.h                          |   46 +
 include/media/saa7115.h                            |    3 
 include/media/v4l2-common.h                        |   14 
 include/media/v4l2-dev.h                           |    9 
 include/media/video-buf.h                          |    3 
 sound/pci/bt87x.c                                  |    1 
 170 files changed, 9913 insertions(+), 4401 deletions(-)
 create mode 100644 Documentation/video4linux/cx2341x/fw-decoder-regs.txt
 create mode 100644 drivers/media/dvb/dvb-usb/au6610.c
 create mode 100644 drivers/media/dvb/dvb-usb/au6610.h
 create mode 100644 drivers/media/dvb/dvb-usb/gl861.c
 create mode 100644 drivers/media/dvb/dvb-usb/gl861.h
 create mode 100644 drivers/media/dvb/dvb-usb/m920x.c
 create mode 100644 drivers/media/dvb/dvb-usb/m920x.h
 create mode 100644 drivers/media/dvb/frontends/qt1010.c
 create mode 100644 drivers/media/dvb/frontends/qt1010.h
 create mode 100644 drivers/media/dvb/frontends/qt1010_priv.h
 create mode 100644 drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h
 create mode 100644 drivers/media/video/sn9c102/sn9c102_config.h
 create mode 100644 drivers/media/video/sn9c102/sn9c102_devtable.h
 create mode 100644 drivers/media/video/sn9c102/sn9c102_ov7660.c
 delete mode 100644 drivers/media/video/sn9c102/sn9c102_pas202bca.c

