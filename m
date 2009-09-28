Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZI1PEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZI1PEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZI1PEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:04:38 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48129 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZI1PEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:04:37 -0400
Date: Mon, 28 Sep 2009 11:04:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: cleanup:  inclusions of <linux/header> files that don't exist
Message-ID: <alpine.LFD.2.00.0909281102080.7535@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  a very specific scan looking for inclusions of the form

  #include <linux/whatever.h>

where that header file doesn't exist (for whatever reason).  available
here:

  http://www.crashcourse.ca/wiki/index.php/Badref_linux_header_files

but a sufficiently short list that i'll just clutter up the place with
it:

=== Missing: include/linux/android_pmem.h ===
drivers/staging/dream/camera/msm_vfe7x.c:8:#include <linux/android_pmem.h>
drivers/staging/dream/camera/msm_camera.c:21:#include <linux/android_pmem.h>
drivers/staging/dream/qdsp5/adsp_driver.c:27:#include <linux/android_pmem.h>
drivers/video/msm/mdp_ppp.c:19:#include <linux/android_pmem.h>
drivers/video/msm/mdp.c:26:#include <linux/android_pmem.h>
=== Missing: include/linux/config.h ===
drivers/staging/cowloop/cowloop.c:242:#include <linux/config.h>
=== Missing: include/linux/earlysuspend.h ===
drivers/staging/dream/gpio_event.c:16:#include <linux/earlysuspend.h>
drivers/staging/dream/synaptics_i2c_rmi.c:22:#include <linux/earlysuspend.h>
=== Missing: include/linux/gpio_event.h ===
drivers/staging/dream/gpio_output.c:18:#include <linux/gpio_event.h>
drivers/staging/dream/gpio_input.c:18:#include <linux/gpio_event.h>
drivers/staging/dream/gpio_matrix.c:18:#include <linux/gpio_event.h>
drivers/staging/dream/gpio_axis.c:18:#include <linux/gpio_event.h>
drivers/staging/dream/gpio_event.c:19:#include <linux/gpio_event.h>
=== Missing: include/linux/i2c-pnx0105.h ===
arch/mips/nxp/pnx833x/common/platform.c:38:#include <linux/i2c-pnx0105.h>
=== Missing: include/linux/input/ad714x.h ===
arch/blackfin/mach-bf537/boards/stamp.c:554:#include <linux/input/ad714x.h>
arch/blackfin/mach-bf537/boards/stamp.c:620:#include <linux/input/ad714x.h>
=== Missing: include/linux/ipipe_base.h ===
arch/blackfin/include/asm/irqflags.h:36:#include <linux/ipipe_base.h>
=== Missing: include/linux/ipipe.h ===
arch/blackfin/mach-common/ints-priority.c:38:#include <linux/ipipe.h>
=== Missing: include/linux/ipipe_percpu.h ===
arch/blackfin/include/asm/ipipe.h:31:#include <linux/ipipe_percpu.h>
=== Missing: include/linux/ipipe_trace.h ===
arch/blackfin/include/asm/irqflags.h:37:#include <linux/ipipe_trace.h>
=== Missing: include/linux/jffs.h ===
drivers/staging/rtl8192e/ieee80211/ieee80211.h:33:#include <linux/jffs.h>
=== Missing: include/linux/kdb.h ===
drivers/acpi/osl.c:69:#include <linux/kdb.h>
=== Missing: include/linux/mfd/adp5520.h ===
arch/blackfin/mach-bf537/boards/stamp.c:1306:#include <linux/mfd/adp5520.h>
drivers/gpio/adp5520-gpio.c:13:#include <linux/mfd/adp5520.h>
drivers/video/backlight/adp5520_bl.c:14:#include <linux/mfd/adp5520.h>
=== Missing: include/linux/msm_adsp.h ===
drivers/staging/dream/camera/msm_vfe7x.c:5:#include <linux/msm_adsp.h>
drivers/staging/dream/qdsp5/adsp.h:22:#include <linux/msm_adsp.h>
drivers/staging/dream/qdsp5/adsp_driver.c:26:#include <linux/msm_adsp.h>
=== Missing: include/linux/msm_audio.h ===
drivers/staging/dream/qdsp5/audio_amrnb.c:41:#include <linux/msm_audio.h>
drivers/staging/dream/qdsp5/audio_in.c:29:#include <linux/msm_audio.h>
drivers/staging/dream/qdsp5/audio_evrc.c:34:#include <linux/msm_audio.h>
drivers/staging/dream/qdsp5/audio_qcelp.c:35:#include <linux/msm_audio.h>
drivers/staging/dream/qdsp5/audio_out.c:30:#include <linux/msm_audio.h>
drivers/staging/dream/qdsp5/audio_mp3.c:33:#include <linux/msm_audio.h>
drivers/staging/dream/qdsp5/snd.c:24:#include <linux/msm_audio.h>
=== Missing: include/linux/msm_mdp.h ===
drivers/video/msm/mdp_ppp.c:18:#include <linux/msm_mdp.h>
drivers/video/msm/msm_fb.c:24:#include <linux/msm_mdp.h>
drivers/video/msm/mdp.c:20:#include <linux/msm_mdp.h>
=== Missing: include/linux/msm_rpcrouter.h ===
drivers/staging/dream/smd/smd_rpcrouter_device.c:31:#include <linux/msm_rpcrouter.h>
drivers/staging/dream/smd/smd_rpcrouter_servers.c:31:#include <linux/msm_rpcrouter.h>
=== Missing: include/linux/spi/adxl34x.h ===
arch/blackfin/mach-bf537/boards/stamp.c:735:#include <linux/spi/adxl34x.h>
arch/blackfin/mach-bf548/boards/ezkit.c:212:#include <linux/spi/adxl34x.h>
=== Missing: include/linux/tqueue.h ===
drivers/staging/rtl8192e/ieee80211/ieee80211.h:34:#include <linux/tqueue.h>
=== Missing: include/linux/usb/langwell_otg.h ===
drivers/usb/gadget/langwell_udc.h:23:#include <linux/usb/langwell_otg.h>
=== Missing: include/linux/wakelock.h ===
drivers/staging/dream/smd/smd_rpcrouter.h:25:#include <linux/wakelock.h>
drivers/staging/dream/smd/smd_tty.c:22:#include <linux/wakelock.h>
drivers/staging/dream/smd/smd_rpcrouter.c:36:#include <linux/wakelock.h>
drivers/staging/dream/smd/smd_qmi.c:27:#include <linux/wakelock.h>
drivers/staging/dream/smd/smd_rpcrouter_servers.c:29:#include <linux/wakelock.h>
drivers/staging/dream/gpio_input.c:22:#include <linux/wakelock.h>
drivers/staging/dream/gpio_matrix.c:21:#include <linux/wakelock.h>
drivers/staging/dream/qdsp5/adsp.c:35:#include <linux/wakelock.h>
drivers/staging/dream/qdsp5/audio_out.c:28:#include <linux/wakelock.h>


rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
