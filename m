Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965912Ab0BZTno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:43:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965843Ab0BZTnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:43:39 -0500
Message-ID: <4B882449.8050705@redhat.com>
Date: Fri, 26 Feb 2010 16:43:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.33-rc1] V4L/DVB updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 60b341b778cc2929df16c0a504c91621b3c6a4ad:
  Linus Torvalds (1):
        Linux 2.6.33

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Abylay Ospan (3):
      V4L/DVB (13936): 22-kHz set_tone fix for NetUP Dual DVB-S2-CI card
      V4L/DVB: 22-kHz set_tone fix for NetUP Dual DVB-S2-CI card. 22kHz logic controlled by demod
      V4L/DVB: STV0900 Cut 3.0 AGC2 fix for NetUP Dual DVB-S2-CI card

Adams Xu (1):
      V4L/DVB: AZ6027: Initial import of the driver

Alexander Beregalov (1):
      V4L/DVB: ir: fix memory leak

Alexander Strakh (1):
      V4L/DVB: cafe_ccic: Fix lock imbalances

Alexey Dobriyan (1):
      V4L/DVB (13946): proc_fops: convert av7110

Andrea.Amorosi76@gmail.com (1):
      V4L/DVB: em28xx: add Dikom DK300 hybrid USB tuner

Andreas Regel (12):
      V4L/DVB (13974): [STV090x] Fix locking reliabilty issues in automatic mode.
      V4L/DVB (13975): [STV090x] Added internal structure with shared settings and data.
      V4L/DVB (13976): [STV090x] Added mutex protection around tuner I2C access.
      V4L/DVB (13977): [STV090x] Test for valid frequency before starting to tune
      V4L/DVB (13978): [STV090x] set FE_HAS_SIGNAL flag in stv090x_read_status when locked.
      V4L/DVB (13979): [STV090x] Added possibility to set a fixed TS output clock.
      V4L/DVB (13980): [STV6110x] Added function stv6110x_write_regs
      V4L/DVB (13981): [STV6110x] Add a local register map for each instance of the driver.
      V4L/DVB (13982): [STV090x] setup master clock in stv090x_init instead of stv090x_setup.
      V4L/DVB (13983): [STV6110x] add clk_div member to stv6110x_config structure
      V4L/DVB (13984): [BUDGET] Use a tuner clock output divider of 2 for TT S2-1600.
      V4L/DVB (13985): [STV090x] reset mclk and dev_ver of internal structure after allocating

Andrew Morton (3):
      V4L/DVB: drivers/media/video/cx18/cx18-alsa-pcm.c: fix printk warning
      V4L/DVB: drivers/media/dvb/frontends/stv090x.c: fix use-uninitialised
      V4L/DVB: drivers/media/dvb/frontends/stv090x.c: fix use-uninitlalised

Andy Walls (22):
      V4L/DVB (13902): cx18: Update MPEG Index stream buffers module option processing
      V4L/DVB (13903): cx18: Encapsulate check for a stream being enabled into an inline function
      V4L/DVB (13904): cx18: Fix TS and IDX stream buffer memory leak on module unload
      V4L/DVB (13905): cx18: Allow MPEG index streams to be started and stopped internally
      V4L/DVB (13906): cx18: Start IDX streams automatically as an internal associated stream
      V4L/DVB (13907): cx18: Perform automatic rotation of very old, unread IDX buffers
      V4L/DVB (13908): cx18: Add initial working VIDIOC_G_ENC_INDEX ioctl() support
      V4L/DVB (13909): cx18: Clean up dead code from ivtv once used for IDX processing
      V4L/DVB (13910): cx18: Fix set indextable command to properly select I/P/B index entries
      V4L/DVB (13913): saa7127: Add support for generating SECAM output for the SAA712[89] chips
      V4L/DVB: cx25840, v4l2-subdev, ivtv, pvrusb2: Fix ivtv/cx25840 tinny audio
      V4L/DVB: ivtv: Adjust msleep() delays used to prevent tinny audio and PCI bus hang
      V4L/DVB: cx18-alsa: Initial non-working cx18-alsa files
      V4L/DVB: cx18-alsa: Add non-working cx18-alsa-pcm.[ch] files to avoid data loss
      V4L/DVB: cx18: Rename snd_cx18_mixer_lock to snd_cx18_lock and increase visibility
      V4L/DVB: cx18: Add missing serialization locking to cx18-alsa
      V4L/DVB: cx18: Fix memory leak in cx18-alsa starting of PCM captures
      V4L/DVB: cx18: Increment driver version for the addition of cx18-alsa and fixes
      V4L/DVB: cx18: Add missing serialization locks to cx18-dvb
      V4L/DVB: ivtv: Fix ivtv_api_get_data() to avoid unneeded IO during IRQ handling
      V4L/DVB: tuner-types: Add Sony BTF-Pxn01Z tuner type used on GigaPocket cards
      V4L/DVB: ivtv: Tweak Sony GigaPocket Kikyou card entry based on experiments

Antoine Jacquet (1):
      V4L/DVB (13885): zr364xx: fix support for Aiptek DV T300

Antonio Ospite (3):
      V4L/DVB: gspca - ov534: Allow enumerating supported framerates
      V4L/DVB: gspca - ov534: Fix end of frame handling
      pxa_camera: remove init() callback

Antti Palosaari (5):
      V4L/DVB: af9015: support for DigitalNow TinyTwin v2
      V4L/DVB: af9015: support for Leadtek WinFast DTV2000DS
      V4L/DVB: af9015: A-Link DTU(m) remote autodetection
      V4L/DVB: af9015: MYGICTV U718 remote autodetection
      V4L/DVB: af901x: inform NXP TDA18218 tuner as know but not supported

Arnaud Patard (1):
      V4L/DVB: Fix VIDIOC_QBUF compat ioctl32

Arvo Järve (1):
      V4L/DVB (13989): [TDA8261] Fix TDA8261 I2C read bug

Baruch Siach (1):
      V4L/DVB: v4l: soc_camera: fix bound checking of mbus_fmt[] index

Ben Hutchings (1):
      V4L/DVB: dabusb: declare MODULE_FIRMWARE

Catimimi (1):
      V4L/DVB: em28xx : Terratec Cinergy Hybrid T USB XS FR is working

Clemens Ladisch (1):
      V4L/DVB: cx88-alsa: prevent out-of-range volume setting

Dan Carpenter (1):
      V4L/DVB (13956): fix weird array index in zl10036.c

Daniel Ritz (1):
      V4L/DVB (13830): uvcvideo: add another YUYV format GUID for iSight cameras

Darren Jenkins (1):
      V4L/DVB: drivers/media/radio/si470x/radio-si470x-usb.c fix use after free

David Wong (1):
      V4L/DVB (13838): atbm8830: use AGC setting from config

Devin Heitmueller (21):
      V4L/DVB (13930): dib0700: rework IR logic for firmware 1.20
      V4L/DVB (13932): em28xx: add PAL support for VBI
      V4L/DVB: cx18: rename cx18-alsa.c
      V4L/DVB: cx18: make it so cx18-alsa-main.c compiles
      V4L/DVB: cx18: export a couple of symbols so they can be shared with cx18-alsa
      V4L/DVB: cx18: overhaul ALSA PCM device handling so it works
      V4L/DVB: cx18: add cx18-alsa module to Makefile
      V4L/DVB: cx18: export more symbols required by cx18-alsa
      V4L/DVB: cx18-alsa: remove unneeded debug line
      V4L/DVB: cx18: rework cx18-alsa module loading to support automatic loading
      V4L/DVB: cx18: cleanup cx18-alsa debug logging
      V4L/DVB: cx18-alsa: name alsa device after the actual card
      V4L/DVB: cx18-alsa: remove a couple of warnings
      V4L/DVB: cx18-alsa: fix memory leak in error condition
      V4L/DVB: cx18-alsa: fix codingstyle issue
      V4L/DVB: cx18-alsa: codingstyle fixes
      V4L/DVB: cx18: codingstyle fixes
      V4L/DVB: cx18-alsa: codingstyle cleanup
      V4L/DVB: cx18-alsa: codingstyle cleanup
      V4L/DVB: cx18: address possible passing of NULL to snd_card_free
      V4L/DVB: cx18-alsa: Fix the rates definition and move some buffer freeing code.

Dirk Herrendoerfer (1):
      V4L/DVB: Add support for SMT7020 to cx88

Dmitri Belimov (1):
      V4L/DVB (13945): Add lost config and PCI ID for card of Beholder

Douglas Schilling Landgraf (1):
      V4L/DVB: Fix logic for Leadtek winfast tv usbii deluxe

Eric Anderson (1):
      V4L/DVB: ivtv: Add initial entry for Sony VAIO Giga Pocket (Kikyou) cards

Erik Andrén (2):
      V4L/DVB (13881): gspca - stv06xx: Clean up the dump bridge function
      V4L/DVB (13883): gspca - m5602: Be less verbose during sensor probe

Francesco Lavra (2):
      V4L/DVB (13957): IR: Fix sysfs attributes declaration
      V4L/DVB (13961): em28xx-dvb: fix memleak in dvb_fini()

Franklin Meng (2):
      V4L/DVB: Kworld 315U remote support
      V4L/DVB: Add an entry for Kworld 315U remote

Guennadi Liakhovetski (5):
      soc-camera: update mt9v022 to take into account board signal routing
      tw9910: use TABs for indentation
      soc-camera: adjust coding style to match V4L preferences
      soc-camera: add support for VIDIOC_S_PARM and VIDIOC_G_PARM ioctls
      sh_mobile_ceu_camera: pass .set_parm and .get_parm down to subdevices

Hans Verkuil (4):
      V4L/DVB: tvp7002: fix compilation breakage when advanced debug is enabled
      V4L/DVB: saa7146_vv: fix regression where v4l2_device was registered too late
      V4L/DVB: saa7115: fix saa7111a support
      V4L/DVB: media-spec: Fix documentation mistakes regarding I/O streaming

Hans de Goede (35):
      V4L/DVB (13994): gscpa_stv0680: Fix camera initialization on hotplug
      V4L/DVB (13995): gspca_ov519: mark led on eyetoy II as inverted
      V4L/DVB (13996): gspca_stv0680: Fix streaming on vga cameras
      V4L/DVB (13997): gspca_ov519: differentiate ov7620 and ov7620ae and fix 640x480 on the 7620
      V4L/DVB (13998): gscpa_ov519: Fix 320x240 on ov519 + ov7648
      V4L/DVB (13999): gspca_ov519: remove non functioning contrast control for ov764x sensor
      V4L/DVB (14000): gspca_ov519: ov764x remove setting of AEC limits
      V4L/DVB (14001): gscpa_sonixb: Differentiate between tas5110c and tas5110d and fix d hstart
      V4L/DVB (14002): gspca_sonixb / sn9c102: Make gspca handle 0c45:6007
      V4L/DVB (14003): gspca_cpai1: New gspca subdriver for CPIA CPiA version 1 cams
      V4L/DVB (14004): drivers/media/video/Kconfig: Turn deprecated drivers off by default
      V4L/DVB (14005): media/video Kconfig: Mark gspca superceeded drivers as deprecated
      V4L/DVB: gspca - zc3xx: Change the resolutions of some sensors
      V4L/DVB: gspca_sq905c: Add an additional USB-ID
      V4L/DVB: gscpa Documentation: add cpia1 cameras
      V4L/DVB: gscpa_pac207: Add support for camera button
      V4L/DVB: gscpa_pac7311: Add support for camera button
      V4L/DVB: gscpa_zc3xx: Add support for camera button
      V4L/DVB: gspca_sonixb: Add support for camera button
      V4L/DVB: gspca_sonixj: Add camera button support
      V4L/DVB: gspca_sonixb: leave bridge gain at 1.0 when we have a sensor gain
      V4L/DVB: gscpa_sonixb: Differentiate between sensors with a coarse and fine expo ctrl
      V4L/DVB: gspca_sonixb: pas202: fixup brightness ctrl and add gain and exposure ctrls
      V4L/DVB: gscpa_sonixb: limit ov7630 max framerate at 640x480
      V4L/DVB: Documentation: gspca.txt: update known mr97310a cams
      V4L/DVB: gspca_sonixb: pas106: fixup bright ctrl and add gain and exposure ctrls
      V4L/DVB: gspca_sonixb: Make sonixb driver handle pas106 and pas202 cameras
      V4L/DVB: gspca_pac7302: much improved exposure control
      V4L/DVB: gspca_main: Allow use of input device creation code for non int. inputs
      V4L/DVB: gspca_main: some input error handling fixes
      V4L/DVB: gspca_main: Fix a compile error when CONFIG_INPUT is not set
      V4L/DVB: gspca_ov519: add support for the button on ov519 based cams
      V4L/DVB: gspca_ov519: Add support for the button on ov518 based cams
      V4L/DVB: gspca_ov519: add support for the button on ov511 based cams
      V4L/DVB: gspca_stv06xx: Add support for camera button

Huang Shijie (2):
      V4L/DVB: Add driver for Telegent tlg2300
      V4L/DVB: tlg2300: remove the country code for analog tv and radio

Huang Weiyi (1):
      V4L/DVB: [Mantis] remove duplicated #include

Ian Armstrong (1):
      V4L/DVB: ivtv: Fix race condition for queued udma transfers

Igor M. Liplianin (5):
      V4L/DVB (13818): Add Prof 7500 DVB-S2 USB card
      V4L/DVB: Add Support for DVBWorld DVB-S2 PCI 2004D card
      V4L/DVB: dm1105: connect splitted else-if statements
      V4L/DVB: dm1105: use dm1105_dev & dev instead of dm1105dvb
      V4L/DVB: dm1105: use macro for read/write registers

JD Louw (1):
      V4L/DVB: Compro S350 GPIO change

Janne Grunau (1):
      V4L/DVB: hdpvr: add new USB product id

Jean Delvare (2):
      V4L/DVB: dvb/bt8xx: Clean-up init and exit functions
      V4L/DVB: bttv: Let the user disable IR support

Jean-Francois Moine (33):
      V4L/DVB (13815): gspca - sunplus: Add webcam 052b:1507.
      V4L/DVB (13865): gspca - main: Optimize code.
      V4L/DVB (13866): gspca - main: Add the cam flag 'no_urb_create'.
      V4L/DVB (13870): gspca - zc3xx: Bad detection of sensor HV7131R(c).
      V4L/DVB (13871): gspca - benq: New subdriver for camera 04a5:3035.
      V4L/DVB (13872): gspca - sonixj: Add sensor adcm1700 and webcam 0c45:614a.
      V4L/DVB (13891): gspca - vc032x: Fix bad probe of the sensor mi1320.
      V4L/DVB (13892): gspca - vc032x: Add the H and V flip controls for sensor mi1320.
      V4L/DVB (13893): gspca - vc032x: Change the sensor of 046d:0892 and 046d:0896.
      V4L/DVB (13894): gspca - sonixj: Add more controls.
      V4L/DVB (13895): gspca - zc3xx: Fix the contrast control.
      V4L/DVB (13896): gspca - zc3xx: Adjust the pas202b exchanges.
      V4L/DVB (13897): gspca - main: Check the interface class at probe time.
      V4L/DVB (13917): gspca - zc3xx: Cleanup code.
      V4L/DVB (13918): gspca - zc3xx: Rename the USB sequences.
      V4L/DVB (13919): gspca - zc3xx: Fix hdcs2020 probe.
      V4L/DVB (13920): gspca - zc3xx: Let default sharpness for sensor pas202b.
      V4L/DVB (13921): gspca - zc3xx: Remove unuseful register write.
      V4L/DVB (13922): gspca - zc3xx: Switch off the LED on resume.
      V4L/DVB (13923): gspca - zc3xx: Simplify code.
      V4L/DVB (13924): gspca - sunplus: Optimize and remove unused sequences.
      V4L/DVB (13925): gspca - main: Change the check of the USB video interface.
      V4L/DVB (13926): gspca - pac7302: Fix a random USB error.
      V4L/DVB (13927): gspca - sonixj: Fix bad video mode for all webcams.
      V4L/DVB (13869): gspca - sn9c20x: Cleanup code.
      V4L/DVB (13916): gspca - ov534/ov534_9: Split the ov534 subdriver.
      V4L/DVB: gspca - pac7302/pac7311: Remove the unused page loading
      V4L/DVB: gspca - pac7302: Use usb_err to propagate USB errors
      V4L/DVB: gspca - pac7311: Use usb_err to propagate USB errors
      V4L/DVB: gspca - main: Clear any previous USB error when starting the transfer
      V4L/DVB: gspca - ov534_9: Propagate USB errors to higher level
      V4L/DVB: gspca - sq905c: Fix a compilation warning
      V4L/DVB: gspca - pac7302: Change latin1 text to utf-8.

Jean-François Moine (4):
      V4L/DVB: gspca - main: Change version to 2.9.0.
      V4L/DVB: gspca - sonixj: Add vertical flip control for sensor hv7131r
      V4L/DVB: gspca - sonixj: Set the vertical flip at capture start for all sensors
      V4L/DVB: gspca - main: Fix a compile error when CONFIG_INPUT is not set

Jiri Slaby (10):
      V4L/DVB (13963): siano, fix memory leak
      V4L/DVB (13964): tuner-core, fix memory leak
      V4L/DVB (13965): zl10039, jump to error on error
      V4L/DVB (13968): cx18, fix potential null dereference
      V4L/DVB: media: dvb/af9015, implement eeprom hashing
      V4L/DVB: media: dvb/af9015, factor out remote setting
      V4L/DVB: media: dvb/af9015, refactor remote setting
      V4L/DVB: media: dvb/af9015, add hashes support
      V4L/DVB: DVB: ngene, fix memset parameters
      V4L/DVB: V4L: dvb-usb, add extra sync to down-up input events

Joe Perches (2):
      V4L/DVB (13969): frontends/si21xx.c: Remove #define TRUE/FALSE, use bool
      V4L/DVB: MAINTAINERS: Telegent tlg2300 section fix

Jonathan Corbet (1):
      V4L/DVB: V4L2: Add a document describing the videobuf layer

Julia Lawall (4):
      V4L/DVB (13948): radio: Correct use after free
      V4L/DVB (13949): Move a dereference below a NULL test
      V4L/DVB (13954): Correct NULL test
      V4L/DVB: drivers/media: Correct NULL test

Klaas de Waal (1):
      V4L/DVB: dst: fixes for DVB-C Twinhan VP2031

Kuninori Morimoto (1):
      soc-camera: ov772x: Modify buswidth control

Kusanagi Kouichi (2):
      V4L/DVB: cx25840: Fix composite detection
      V4L/DVB: cx23885: Add support for LEADTEK WinFast PxTV1200

Lars Hanisch (1):
      V4L/DVB: add missing 'p' at card name 'Hauppauge HD PVR'

Laurent Pinchart (9):
      V4L/DVB (13827): uvcvideo: Switch to a monotonic clock for V4L2 buffers timestamps
      V4L/DVB (13828): uvcvideo: Make the quirks module parameter override the built-in quirks
      V4L/DVB: uvcvideo: Increase the streaming control timeout to 5 seconds
      V4L/DVB: uvcvideo: Use %pUl printk format specifier to print GUIDs
      V4L/DVB: uvcvideo: Return -ERANGE when setting a control to an out-of-range menu index
      V4L/DVB: uvcvideo: Cache control min, max, res and def query results
      V4L/DVB: uvcvideo: Clamp control values to the minimum and maximum values
      V4L/DVB: uvcvideo: Blacklist gain control for Asus EeePC T91 integrated webcam
      V4L/DVB: uvcvideo: Check uvc_ctrl_begin return value in VIDIOC_S_CTRL

Luis Maia (1):
      V4L/DVB (13867): gspca - zc3xx: Add one more chipset ID of tas5130K.

Magnus Alm (1):
      V4L/DVB: em28xx: fix for "Leadtek winfast tv usbii deluxe"

Magnus Damm (1):
      soc-camera: return -ENODEV if sensor is missing

Manu Abraham (6):
      V4L/DVB: [nGene] Trivial I2C related fixes/cleanups
      V4L/DVB: AZ6027: Add driver supported ID's
      V4L/DVB: AZ6027: Update Build
      V4L/DVB: AZ6027: Add driver supported ID's
      V4L/DVB: AZ6027: Fix checkpatch violations
      V4L/DVB: AZ6027: Fix build warnings

Marton Nemeth (1):
      V4L/DVB (13899): gspca - all subdrivers: Make control descriptors constant.

Massimo Del Fedele (1):
      V4L/DVB: m920x: Add support for Pinnacle PCTV310e card

Matthias Benesch (6):
      V4L/DVB: ngene: Initial check-in
      V4L/DVB: ngene: Additional clean-up
      V4L/DVB: ngene: Added Media-Pointer MP-S2/CineS2 DVB-S2 Twin Tuner
      V4L/DVB: ngene: Remove firmware debugging
      V4L/DVB: ngene: Added module parameter "one_adapter"
      V4L/DVB: ngene: Mystique SaTiX-S2 Dual

Mauro Carvalho Chehab (33):
      V4L/DVB (13633): ir-core: create a new class for remote controllers
      V4L/DVB (13634): ir-core: allow passing IR device parameters to ir-core
      V4L/DVB (13635): ir-core: Implement protocol table type reading
      V4L/DVB (13636): ir-core: add method to change IR protocol
      V4L/DVB (13637): em28xx: allow changing keycode table protocol
      V4L/DVB (13638): ir-core: documment missed functions
      V4L/DVB (13639): ir-sysfs: Properly protect rc_tab changes with a lock
      V4L/DVB (13641): Properly update the driver representation for the protocol
      V4L/DVB (13680): ir: use unsigned long instead of enum
      V4L/DVB (13825): ir-core: Don't OOPS if IR device props is not defined
      V4L/DVB (13833): ir-core: some functions can be static
      V4L/DVB (13841): smsdvb: Make stats to work
      V4L/DVB (13842): smsdvb: Convert it to use DVB API v5 (S2API)
      V4L/DVB (13843): dib8000: Properly report Delivery System as SYS_ISDBT
      V4L/DVB (13844): smsdvb: Properly report the Delivery System
      V4L/DVB (13845): smsdvb: Fix the frequency switch that broke with v5 API conversion
      V4L/DVB (13846): smsdvb: Properly implement stats for both DVB and ISDB-T
      V4L/DVB (13847): smsdvb: Remove a wrong debug message
      V4L/DVB (13848): smsdvb: Add the proper status for IsRfLocked
      V4L/DVB (13856): ir-keytable: simplify and avoid a warning
      V4L/DVB (13878): dvb_frontend: Print dump on get after filling the data
      V4L/DVB (13879): dvb_frontend: report what ioctl were called on debug mode
      V4L/DVB (13915): em28xx: fix a typo on RC6 modes
      cx18: Fix compilation when CONFIG_MODULE is disabled
      Fix the __init/__exit annotations
      V4L/DVB: az6027: IR RC keys are using the old struct with 3 parameters, instead of 2
      V4L/DVB: az6027: az6027_read_mac_addr is currently unused
      Revert "V4L/DVB: az6027: IR RC keys are using the old struct with 3 parameters, instead of 2"
      Revert "V4L/DVB: az6027: az6027_read_mac_addr is currently unused"
      V4L/DVB: tuner-xc2028: fix tuning logic to solve a regression in Australia
      V4L/DVB: tuner-xc2028: Fix demod breakage for XC3028L
      V4L/DVB: V4L2 docs: replace spaces by tabs
      V4L-DVB: cx88-dvb: remove extra attribution for core

Michael Krufky (2):
      V4L/DVB (13839): smsdvb: add ISDB-T as DVB-T tuning support hack
      V4L/DVB (13840): smsusb: Add ISDB-T firmware for Hauppauge WinTV-Nova-T-MiniStick

Mike Isely (3):
      V4L/DVB: pvrusb2: Enforce a 300msec stabilization interval during stream strart
      V4L/DVB: pvrusb2: Reduce encoder quiet period
      V4L/DVB: pvrusb2: Adjust 300msec digitizer wait to be more selective

Murali Karicheri (5):
      V4L/DVB: DaVinci - Adding platform & board changes for vpfe capture on DM365
      V4L/DVB: V4L - vpfe capture - header files for ISIF driver
      V4L/DVB: V4L - vpfe capture - source for ISIF driver on DM365
      V4L/DVB: V4L - vpfe capture - vpss driver enhancements for DM365
      V4L/DVB: V4L - vpfe capture - build environment for isif driver

Muralidharan Karicheri (4):
      V4L/DVB: vpfe_capture: remove clock and platform code
      V4L/DVB: vpfe-capture - converting dm355 ccdc driver to a platform driver
      V4L/DVB: vpfe-capture: converting dm644x ccdc driver to a platform driver
      V4L/DVB: vpfe-capture: converting ccdc drivers to platform-drivers

Márton Németh (14):
      V4L/DVB (13898): gspca - some subdrivers: Make sd_desc const.
      V4L/DVB: zoran: cleanup pointer condition
      V4L/DVB: cx231xx: cleanup dvb_attach() return value handling
      V4L/DVB: stv0900: make local functions static
      V4L/DVB: stv0900: make more local functions static
      V4L/DVB: bt819: cleanup v4l2_subdev_notify() parameters
      V4L/DVB: dib0090: cleanup dib0090_dcc_freq()
      V4L/DVB: zoran: match parameter signedness of g_input_status
      V4L/DVB: zoran: remove variable shadowing
      V4L/DVB: gspca - main: Add input support for interrupt endpoints.
      V4L/DVB: gspca - pac7302: Add support for camera button.
      V4L/DVB: smsir: make local variables static
      V4L/DVB: hdpvr-core: make module parameters local
      V4L/DVB: hdpvr-video: cleanup signedness

Nicolau Werneck (1):
      V4L/DVB: gspca - t613: Support for LT168G sensor.

Oliver Endriss (19):
      V4L/DVB (13986): [STV090x] Disable I2C gate on error
      V4L/DVB (13987): [STV090x] Quit processing if the tuner did not lock
      V4L/DVB (13988): [STV090x] Configuration parameters adc1_range, adc2_range, tuner_bbgain
      V4L/DVB: ngene: Driver compiles now
      V4L/DVB: ngene: Always use firmware loader
      V4L/DVB: ngene: Speed-up tuning
      V4L/DVB: ngene: Change severity of some diagnostic messages
      V4L/DVB: ngene: Remove kernel version check for dvb_[un]register_adapter
      V4L/DVB: DVB: Export dvb_ringbuffer_flush() again
      V4L/DVB: ngene: Code cleanup
      V4L/DVB: ngene: Adapt to current frontend drivers
      V4L/DVB: ngene: Set ADC ranges to 1Vpp
      V4L/DVB: ngene: Workaround for command timeout
      V4L/DVB: ngene: Take care of late interrupts
      V4L/DVB: ngene: Use correct name for cineS2 cards
      V4L/DVB: ngene: Make checkpatch.pl happy
      V4L/DVB: ngene: Fix I2C initialisation
      V4L/DVB: get_dvb_firmware: Add function to retrieve nGene firmwares
      V4L/DVB: get_dvb_firmware: Fix typo, sort list of components

Pawel Osciak (1):
      V4L/DVB: videobuf: add missing checks for kzalloc returning NULL

Pete Eberlein (1):
      V4L/DVB: s2250: Fix write_reg i2c address

Peter Huewe (1):
      V4L/DVB (13947): add __init/__exit macros to drivers/media/dvb/bt8xx/bt878.c

Randy Dunlap (4):
      V4L/DVB: timberdale: fix mfd build
      V4L/DVB: media/video/tlg2300: fix build when CONFIG_PM=n
      V4L/DVB: radio_timberdale: depends on I2c
      V4L/DVB: dvb: fix sparse warnings

Richard Röjfors (4):
      V4L/DVB: radio: add support for SAA7706H Car Radio DSP
      V4L/DVB: radio: Add radio-timb
      V4L/DVB: mfd: Add support for the timberdale FPGA
      V4L/DVB: mfd: Add timb-radio to the timberdale MFD

Roel Kluin (7):
      V4L/DVB: use correct size in put_v4l2_window32()
      V4L/DVB (13944): vivi: Fix test of unsigned in vivi_create_instance()
      V4L/DVB (12930): Wrong variable tested
      V4L/DVB: cx23885: Wrong command printed in cmd_to_str()
      V4L/DVB: stv0900: dereference of state->internal in fe_stv0900_error stv0900_init_internal()
      V4L/DVB: dvb: return -ENOMEM if kzalloc failed in dvb_usb_device_init()
      V4L/DVB: dvb-usb/opera1: misplaced parenthesis

Roland Praml (1):
      V4L/DVB: ngene: Fix unloading of module

Santiago Nunez-Corrales (4):
      V4L/DVB: Support for TVP7002 in v4l2 definitions
      V4L/DVB: Definitions for TVP7002 in DM365
      V4L/DVB: TVP7002 driver for DM365
      V4L/DVB: Kbuild addition for TVP7002 driver

Sean Young (1):
      V4L/DVB: saa7134 can capture 720x480 when capturing NTSC

Sergey Bolshakov (1):
      V4L/DVB (13912): cx18: Fix tuner reset pin in card entry for the Leadtek PVR2100

Stefan Richter (4):
      V4L/DVB (13953): firedtv: add missing NULL pointer check
      V4L/DVB: firedtv: do not DMA-map stack addresses
      V4L/DVB: firedtv: remove check for interrupting signal
      V4L/DVB: firedtv: reduce memset()s

Stephen Rothwell (2):
      V4L/DVB: using vmalloc requires include of linux/vmalloc.h
      V4L/DVB: using vmalloc requires include linux/vmalloc.h

Theodore Kilgore (6):
      V4L/DVB (13991): gspca_mr973010a: Fix cif type 1 cameras not streaming on UHCI controllers
      V4L/DVB (13992): gspca_sn9c2028: New gspca subdriver
      V4L/DVB (13993): gspca.txt: add cams supported by mr97310a, sq905(c) and sn9c2028 drivers
      V4L/DVB (14006): gscpa_sq905c: Better detection of CIF resolution cameras
      V4L/DVB: gspca_mr97310a: Simplify sensor detection
      V4L/DVB: gspca_mr97310a: add support for the Sakar 1638x CyberPix

Thiago Farina (1):
      V4L/DVB: dvb-core: remove unnecessary casting of kmalloc

Tobias Klauser (3):
      V4L/DVB (13950): usb-friio: Storage class should be before const qualifier
      V4L/DVB (13951): rj54n1cb0: Storage class should be before const qualifier
      V4L/DVB (13952): gspca: Storage class should be before const qualifier

Tobias Lorenz (1):
      V4L/DVB: radio-si470x: Use UTF-8 encoding on a comment

hartleys (2):
      V4L/DVB (13958): tveeprom.c: use %pM to show MAC address
      V4L/DVB (13959): cx23885/cx23885-dvb.c: use %pM to show MAC address

 Documentation/DocBook/v4l/io.xml                   |    3 +-
 Documentation/DocBook/v4l/vidioc-qbuf.xml          |   40 +-
 Documentation/DocBook/v4l/vidioc-querybuf.xml      |    7 +-
 Documentation/DocBook/v4l/vidioc-reqbufs.xml       |   36 +-
 Documentation/dvb/get_dvb_firmware                 |   23 +-
 Documentation/video4linux/CARDLIST.cx23885         |    1 +
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/CARDLIST.tuner           |    1 +
 Documentation/video4linux/README.tlg2300           |   47 +
 Documentation/video4linux/gspca.txt                |   25 +-
 Documentation/video4linux/v4l2-framework.txt       |  106 +-
 Documentation/video4linux/videobuf                 |  360 ++++
 MAINTAINERS                                        |    7 +
 arch/arm/mach-davinci/board-dm365-evm.c            |   71 +
 arch/arm/mach-davinci/dm355.c                      |   43 +-
 arch/arm/mach-davinci/dm365.c                      |  102 +-
 arch/arm/mach-davinci/dm644x.c                     |   21 +-
 arch/arm/mach-davinci/include/mach/dm365.h         |    2 +
 arch/arm/mach-pxa/include/mach/camera.h            |    2 -
 arch/sh/boards/mach-ap325rxa/setup.c               |    4 +-
 arch/sh/boards/mach-migor/setup.c                  |    2 +-
 drivers/media/IR/Makefile                          |    2 +-
 drivers/media/IR/ir-functions.c                    |    2 +-
 drivers/media/IR/ir-keymaps.c                      |   99 +
 drivers/media/IR/ir-keytable.c                     |   61 +-
 drivers/media/IR/ir-sysfs.c                        |  211 ++
 drivers/media/common/saa7146_fops.c                |   11 +-
 drivers/media/common/tuners/tuner-types.c          |   21 +
 drivers/media/common/tuners/tuner-xc2028.c         |   79 +-
 drivers/media/dvb/Kconfig                          |    4 +
 drivers/media/dvb/Makefile                         |    3 +-
 drivers/media/dvb/bt8xx/bt878.c                    |   21 +-
 drivers/media/dvb/bt8xx/dst.c                      |   12 +-
 drivers/media/dvb/dm1105/Kconfig                   |    1 +
 drivers/media/dvb/dm1105/dm1105.c                  |  505 +++---
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   12 +-
 drivers/media/dvb/dvb-core/dvb_ringbuffer.c        |    1 +
 drivers/media/dvb/dvb-usb/Kconfig                  |    8 +
 drivers/media/dvb/dvb-usb/Makefile                 |    3 +
 drivers/media/dvb/dvb-usb/af9015.c                 |  351 ++--
 drivers/media/dvb/dvb-usb/af9015.h                 |    1 +
 drivers/media/dvb/dvb-usb/az6027.c                 | 1151 +++++++++++
 drivers/media/dvb/dvb-usb/az6027.h                 |   14 +
 drivers/media/dvb/dvb-usb/cxusb.c                  |    3 +
 drivers/media/dvb/dvb-usb/dib0700.h                |    1 -
 drivers/media/dvb/dvb-usb/dib0700_core.c           |  197 ++-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  160 +--
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    9 +-
 drivers/media/dvb/dvb-usb/dvb-usb-init.c           |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    1 +
 drivers/media/dvb/dvb-usb/dw2102.c                 |   95 +-
 drivers/media/dvb/dvb-usb/friio-fe.c               |    2 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |  141 ++
 drivers/media/dvb/dvb-usb/m920x.h                  |    2 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |    2 +-
 drivers/media/dvb/firewire/firedtv-1394.c          |   19 +-
 drivers/media/dvb/firewire/firedtv-avc.c           |  514 +++---
 drivers/media/dvb/firewire/firedtv-dvb.c           |    1 -
 drivers/media/dvb/firewire/firedtv-fw.c            |    2 +-
 drivers/media/dvb/firewire/firedtv.h               |    6 +-
 drivers/media/dvb/frontends/af9013.h               |    1 +
 drivers/media/dvb/frontends/atbm8830.c             |   16 +
 drivers/media/dvb/frontends/dib0090.c              |    2 +-
 drivers/media/dvb/frontends/dib8000.c              |    2 +
 drivers/media/dvb/frontends/dibx000_common.c       |    2 +-
 drivers/media/dvb/frontends/lnbp21.c               |    3 +-
 drivers/media/dvb/frontends/si21xx.c               |   38 +-
 drivers/media/dvb/frontends/stv0900.h              |    2 +
 drivers/media/dvb/frontends/stv0900_core.c         |  109 +-
 drivers/media/dvb/frontends/stv0900_priv.h         |   11 +
 drivers/media/dvb/frontends/stv0900_reg.h          |    6 +
 drivers/media/dvb/frontends/stv0900_sw.c           |   54 +-
 drivers/media/dvb/frontends/stv090x.c              |  486 ++++--
 drivers/media/dvb/frontends/stv090x.h              |   13 +-
 drivers/media/dvb/frontends/stv090x_priv.h         |   17 +-
 drivers/media/dvb/frontends/stv6110x.c             |  188 ++-
 drivers/media/dvb/frontends/stv6110x.h             |    1 +
 drivers/media/dvb/frontends/stv6110x_priv.h        |    1 +
 drivers/media/dvb/frontends/tda665x.c              |    2 +-
 drivers/media/dvb/frontends/tda8261.c              |    2 +-
 drivers/media/dvb/frontends/zl10036.c              |    2 +-
 drivers/media/dvb/frontends/zl10039.c              |    1 -
 drivers/media/dvb/mantis/mantis_hif.c              |    2 -
 drivers/media/dvb/mantis/mantis_input.c            |    2 +-
 drivers/media/dvb/mantis/mantis_pci.c              |    5 -
 drivers/media/dvb/ngene/Kconfig                    |    9 +
 drivers/media/dvb/ngene/Makefile                   |   11 +
 drivers/media/dvb/ngene/ngene-core.c               | 2024 ++++++++++++++++++++
 drivers/media/dvb/ngene/ngene.h                    |  859 +++++++++
 drivers/media/dvb/siano/sms-cards.c                |    1 +
 drivers/media/dvb/siano/smscoreapi.c               |    7 +-
 drivers/media/dvb/siano/smscoreapi.h               |   77 +-
 drivers/media/dvb/siano/smsdvb.c                   |  318 +++-
 drivers/media/dvb/siano/smsir.c                    |    6 +-
 drivers/media/dvb/ttpci/av7110_ir.c                |   14 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    2 +-
 drivers/media/dvb/ttpci/budget.c                   |    4 +-
 drivers/media/radio/Kconfig                        |   23 +
 drivers/media/radio/Makefile                       |    2 +
 drivers/media/radio/radio-timb.c                   |  244 +++
 drivers/media/radio/saa7706h.c                     |  451 +++++
 drivers/media/radio/si470x/radio-si470x-common.c   |    2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    8 +-
 drivers/media/video/Kconfig                        |   36 +-
 drivers/media/video/Makefile                       |    2 +
 drivers/media/video/bt819.c                        |   10 +-
 drivers/media/video/bt8xx/bttv-driver.c            |    9 +-
 drivers/media/video/bt8xx/bttv-input.c             |    4 +-
 drivers/media/video/cafe_ccic.c                    |    6 +-
 drivers/media/video/cpia.c                         |    3 -
 drivers/media/video/cx18/Kconfig                   |   11 +
 drivers/media/video/cx18/Makefile                  |    2 +
 drivers/media/video/cx18/cx18-alsa-main.c          |  293 +++
 drivers/media/video/cx18/cx18-alsa-mixer.c         |  175 ++
 drivers/media/video/cx18/cx18-alsa-mixer.h         |   23 +
 drivers/media/video/cx18/cx18-alsa-pcm.c           |  354 ++++
 drivers/media/video/cx18/cx18-alsa-pcm.h           |   27 +
 drivers/media/video/cx18/cx18-alsa.h               |   75 +
 drivers/media/video/cx18/cx18-cards.c              |    2 +-
 drivers/media/video/cx18/cx18-driver.c             |   70 +-
 drivers/media/video/cx18/cx18-driver.h             |   50 +-
 drivers/media/video/cx18/cx18-dvb.c                |   22 +-
 drivers/media/video/cx18/cx18-fileops.c            |  205 ++-
 drivers/media/video/cx18/cx18-fileops.h            |    3 +
 drivers/media/video/cx18/cx18-ioctl.c              |  135 ++-
 drivers/media/video/cx18/cx18-mailbox.c            |   45 +-
 drivers/media/video/cx18/cx18-queue.c              |    3 +
 drivers/media/video/cx18/cx18-streams.c            |   72 +-
 drivers/media/video/cx18/cx18-streams.h            |   10 +
 drivers/media/video/cx18/cx18-version.h            |    2 +-
 drivers/media/video/cx18/cx23418.h                 |    3 +-
 drivers/media/video/cx231xx/cx231xx-dvb.c          |    8 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |    2 +-
 drivers/media/video/cx23885/cx23885-417.c          |    4 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   32 +
 drivers/media/video/cx23885/cx23885-dvb.c          |   17 +-
 drivers/media/video/cx23885/cx23885-input.c        |    2 +-
 drivers/media/video/cx23885/cx23885-video.c        |   13 +
 drivers/media/video/cx23885/cx23885.h              |    1 +
 drivers/media/video/cx25840/cx25840-core.c         |   54 +-
 drivers/media/video/cx88/cx88-alsa.c               |   10 +-
 drivers/media/video/cx88/cx88-cards.c              |   23 +
 drivers/media/video/cx88/cx88-dvb.c                |  214 +++
 drivers/media/video/cx88/cx88-input.c              |    4 +-
 drivers/media/video/cx88/cx88-mpeg.c               |    3 +
 drivers/media/video/cx88/cx88.h                    |    1 +
 drivers/media/video/dabusb.c                       |    2 +
 drivers/media/video/davinci/Makefile               |    1 +
 drivers/media/video/davinci/dm355_ccdc.c           |  410 +++--
 drivers/media/video/davinci/dm644x_ccdc.c          |  361 +++--
 drivers/media/video/davinci/isif.c                 | 1172 +++++++++++
 drivers/media/video/davinci/isif_regs.h            |  269 +++
 drivers/media/video/davinci/vpfe_capture.c         |  131 +--
 drivers/media/video/davinci/vpss.c                 |  289 +++-
 drivers/media/video/em28xx/em28xx-cards.c          |   80 +-
 drivers/media/video/em28xx/em28xx-core.c           |   19 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |    3 +
 drivers/media/video/em28xx/em28xx-input.c          |  113 +-
 drivers/media/video/em28xx/em28xx-reg.h            |    4 +-
 drivers/media/video/em28xx/em28xx-vbi.c            |   17 +-
 drivers/media/video/em28xx/em28xx-video.c          |   58 +-
 drivers/media/video/em28xx/em28xx.h                |    6 +-
 drivers/media/video/et61x251/Kconfig               |    6 +-
 drivers/media/video/gspca/Kconfig                  |   46 +-
 drivers/media/video/gspca/Makefile                 |    8 +
 drivers/media/video/gspca/benq.c                   |  322 ++++
 drivers/media/video/gspca/coarse_expo_autogain.h   |  116 ++
 drivers/media/video/gspca/conex.c                  |    4 +-
 drivers/media/video/gspca/cpia1.c                  | 2022 +++++++++++++++++++
 drivers/media/video/gspca/etoms.c                  |    4 +-
 drivers/media/video/gspca/gl860/gl860.c            |   10 +-
 drivers/media/video/gspca/gspca.c                  |  259 +++-
 drivers/media/video/gspca/gspca.h                  |   30 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c    |    4 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.c     |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.h     |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |    2 +-
 drivers/media/video/gspca/m5602/m5602_po1030.c     |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c     |    2 +-
 drivers/media/video/gspca/mars.c                   |    2 +-
 drivers/media/video/gspca/mr97310a.c               |  226 ++-
 drivers/media/video/gspca/ov519.c                  |  151 ++-
 drivers/media/video/gspca/ov534.c                  | 1253 ++-----------
 drivers/media/video/gspca/ov534_9.c                | 1477 ++++++++++++++
 drivers/media/video/gspca/pac207.c                 |   25 +-
 drivers/media/video/gspca/pac7302.c                |  411 ++---
 drivers/media/video/gspca/pac7311.c                |  251 ++--
 drivers/media/video/gspca/pac_common.h             |    9 +-
 drivers/media/video/gspca/sn9c2028.c               |  757 ++++++++
 drivers/media/video/gspca/sn9c2028.h               |   51 +
 drivers/media/video/gspca/sn9c20x.c                |   33 +-
 drivers/media/video/gspca/sonixb.c                 |  451 ++++--
 drivers/media/video/gspca/sonixj.c                 |  341 +++-
 drivers/media/video/gspca/spca500.c                |    4 +-
 drivers/media/video/gspca/spca501.c                |    2 +-
 drivers/media/video/gspca/spca505.c                |    2 +-
 drivers/media/video/gspca/spca506.c                |    4 +-
 drivers/media/video/gspca/spca508.c                |    2 +-
 drivers/media/video/gspca/spca561.c                |    4 +-
 drivers/media/video/gspca/sq905c.c                 |   45 +-
 drivers/media/video/gspca/stk014.c                 |    2 +-
 drivers/media/video/gspca/stv0680.c                |   16 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   32 +-
 drivers/media/video/gspca/sunplus.c                |  186 +--
 drivers/media/video/gspca/t613.c                   |   51 +-
 drivers/media/video/gspca/tv8532.c                 |    2 +-
 drivers/media/video/gspca/vc032x.c                 |  694 ++++++-
 drivers/media/video/gspca/zc3xx.c                  |  679 ++++----
 drivers/media/video/hdpvr/hdpvr-core.c             |    5 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    5 +-
 drivers/media/video/hdpvr/hdpvr.h                  |    1 +
 drivers/media/video/hexium_gemini.c                |    9 +-
 drivers/media/video/hexium_orion.c                 |    4 +
 drivers/media/video/ir-kbd-i2c.c                   |    5 +-
 drivers/media/video/ivtv/ivtv-cards.c              |   48 +
 drivers/media/video/ivtv/ivtv-cards.h              |    4 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    1 +
 drivers/media/video/ivtv/ivtv-firmware.c           |    2 +-
 drivers/media/video/ivtv/ivtv-irq.c                |   14 +-
 drivers/media/video/ivtv/ivtv-mailbox.c            |    9 +-
 drivers/media/video/ivtv/ivtv-mailbox.h            |    3 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    6 +-
 drivers/media/video/ivtv/ivtv-udma.c               |    1 +
 drivers/media/video/mt9v022.c                      |   17 +-
 drivers/media/video/mxb.c                          |   10 +-
 drivers/media/video/ov772x.c                       |   22 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   53 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    1 +
 drivers/media/video/pxa_camera.c                   |   10 -
 drivers/media/video/rj54n1cb0c.c                   |   12 +-
 drivers/media/video/saa7115.c                      |   27 +-
 drivers/media/video/saa7127.c                      |   47 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   52 +-
 drivers/media/video/saa7134/saa7134-input.c        |    7 +-
 drivers/media/video/saa7134/saa7134-video.c        |    2 +-
 drivers/media/video/saa7134/saa7134.h              |    3 +-
 drivers/media/video/saa7164/saa7164-api.c          |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   18 +
 drivers/media/video/sn9c102/Kconfig                |    5 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    6 +-
 drivers/media/video/soc_camera.c                   |   36 +-
 drivers/media/video/soc_mediabus.c                 |   48 +-
 drivers/media/video/tlg2300/Kconfig                |   16 +
 drivers/media/video/tlg2300/Makefile               |    9 +
 drivers/media/video/tlg2300/pd-alsa.c              |  332 ++++
 drivers/media/video/tlg2300/pd-common.h            |  282 +++
 drivers/media/video/tlg2300/pd-dvb.c               |  593 ++++++
 drivers/media/video/tlg2300/pd-main.c              |  539 ++++++
 drivers/media/video/tlg2300/pd-radio.c             |  420 ++++
 drivers/media/video/tlg2300/pd-video.c             | 1667 ++++++++++++++++
 drivers/media/video/tlg2300/vendorcmds.h           |  243 +++
 drivers/media/video/tuner-core.c                   |    1 +
 drivers/media/video/tveeprom.c                     |    5 +-
 drivers/media/video/tvp7002.c                      | 1187 ++++++++++++
 drivers/media/video/tvp7002_reg.h                  |  150 ++
 drivers/media/video/tw9910.c                       |    8 +-
 drivers/media/video/usbvision/usbvision-video.c    |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |  242 ++-
 drivers/media/video/uvc/uvc_driver.c               |   74 +-
 drivers/media/video/uvc/uvc_queue.c                |    1 -
 drivers/media/video/uvc/uvc_v4l2.c                 |    4 +-
 drivers/media/video/uvc/uvc_video.c                |   10 +
 drivers/media/video/uvc/uvcvideo.h                 |   19 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    5 +-
 drivers/media/video/videobuf-dma-sg.c              |    2 +
 drivers/media/video/videobuf-vmalloc.c             |    2 +
 drivers/media/video/vivi.c                         |    2 +-
 drivers/media/video/zc0301/Kconfig                 |    6 +-
 drivers/media/video/zoran/zoran_device.c           |    6 +-
 drivers/media/video/zoran/zoran_driver.c           |    4 +-
 drivers/media/video/zr364xx.c                      |   37 +-
 drivers/mfd/Kconfig                                |   10 +
 drivers/mfd/Makefile                               |    3 +-
 drivers/mfd/timberdale.c                           |  727 +++++++
 drivers/mfd/timberdale.h                           |  130 ++
 drivers/staging/go7007/s2250-board.c               |    2 +-
 include/linux/videodev2.h                          |    2 +
 include/media/davinci/isif.h                       |  531 +++++
 include/media/davinci/vpss.h                       |   41 +-
 include/media/ir-common.h                          |    6 +-
 include/media/ir-core.h                            |   42 +-
 include/media/ir-kbd-i2c.h                         |    2 +-
 include/media/ov772x.h                             |   10 +-
 include/media/saa7146_vv.h                         |    1 +
 include/media/soc_camera.h                         |    2 +
 include/media/timb_radio.h                         |   36 +
 include/media/tuner.h                              |    1 +
 include/media/tvp7002.h                            |   56 +
 include/media/tw9910.h                             |    4 +-
 include/media/v4l2-chip-ident.h                    |    7 +
 include/media/v4l2-subdev.h                        |    1 +
 293 files changed, 27854 insertions(+), 4780 deletions(-)
 create mode 100644 Documentation/video4linux/README.tlg2300
 create mode 100644 Documentation/video4linux/videobuf
 create mode 100644 drivers/media/IR/ir-sysfs.c
 create mode 100644 drivers/media/dvb/dvb-usb/az6027.c
 create mode 100644 drivers/media/dvb/dvb-usb/az6027.h
 create mode 100644 drivers/media/dvb/ngene/Kconfig
 create mode 100644 drivers/media/dvb/ngene/Makefile
 create mode 100644 drivers/media/dvb/ngene/ngene-core.c
 create mode 100644 drivers/media/dvb/ngene/ngene.h
 create mode 100644 drivers/media/radio/radio-timb.c
 create mode 100644 drivers/media/radio/saa7706h.c
 create mode 100644 drivers/media/video/cx18/cx18-alsa-main.c
 create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.c
 create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.h
 create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.c
 create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.h
 create mode 100644 drivers/media/video/cx18/cx18-alsa.h
 create mode 100644 drivers/media/video/davinci/isif.c
 create mode 100644 drivers/media/video/davinci/isif_regs.h
 create mode 100644 drivers/media/video/gspca/benq.c
 create mode 100644 drivers/media/video/gspca/coarse_expo_autogain.h
 create mode 100644 drivers/media/video/gspca/cpia1.c
 create mode 100644 drivers/media/video/gspca/ov534_9.c
 create mode 100644 drivers/media/video/gspca/sn9c2028.c
 create mode 100644 drivers/media/video/gspca/sn9c2028.h
 create mode 100644 drivers/media/video/tlg2300/Kconfig
 create mode 100644 drivers/media/video/tlg2300/Makefile
 create mode 100644 drivers/media/video/tlg2300/pd-alsa.c
 create mode 100644 drivers/media/video/tlg2300/pd-common.h
 create mode 100644 drivers/media/video/tlg2300/pd-dvb.c
 create mode 100644 drivers/media/video/tlg2300/pd-main.c
 create mode 100644 drivers/media/video/tlg2300/pd-radio.c
 create mode 100644 drivers/media/video/tlg2300/pd-video.c
 create mode 100644 drivers/media/video/tlg2300/vendorcmds.h
 create mode 100644 drivers/media/video/tvp7002.c
 create mode 100644 drivers/media/video/tvp7002_reg.h
 create mode 100644 drivers/mfd/timberdale.c
 create mode 100644 drivers/mfd/timberdale.h
 create mode 100644 include/media/davinci/isif.h
 create mode 100644 include/media/timb_radio.h
 create mode 100644 include/media/tvp7002.h

