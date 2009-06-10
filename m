Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZFJKbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZFJKbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZFJKbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:31:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59228 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZFJKbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:31:40 -0400
Date: Wed, 10 Jun 2009 12:31:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, swetland@google.com, san@android.com, rlove@google.com
Subject: HTC Dream aka. t-mobile g1 support
Message-ID: <20090610103131.GB13885@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is there patch for Dream support for 2.6.30 somewhere? The best I
could find is linux-msm tree, which is ... quite a big diff against
2.6.24:

Is all of it neccessary for dream or are parts such as board-halibut
parts of some other support? Do I have wrong tree entirely?
								Pavel

 arch/arm/Kconfig                              |   15 
 arch/arm/Makefile                             |    1 
 arch/arm/configs/msm_defconfig                | 1129 +++++++++++++++++++
 arch/arm/mach-msm/Kconfig                     |  238 ++++
 arch/arm/mach-msm/Makefile                    |   21 
 arch/arm/mach-msm/Makefile.boot               |    3 
 arch/arm/mach-msm/adsp.c                      |  870 ++++++++++++++
 arch/arm/mach-msm/adsp.h                      |  246 ++++
 arch/arm/mach-msm/adsp_6210.c                 |  282 ++++
 arch/arm/mach-msm/adsp_6220.c                 |  282 ++++
 arch/arm/mach-msm/adsp_driver.c               |  495 ++++++++
 arch/arm/mach-msm/board-halibut-keypad.c      |  180 +++
 arch/arm/mach-msm/board-halibut.c             |  358 ++++++
 arch/arm/mach-msm/clock-7x00a.c               |  127 ++
 arch/arm/mach-msm/clock.c                     |  573 +++++++++
 arch/arm/mach-msm/clock.h                     |  120 ++
 arch/arm/mach-msm/common.c                    |  227 +++
 arch/arm/mach-msm/dma.c                       |  246 ++++
 arch/arm/mach-msm/fiq_glue.S                  |   64 +
 arch/arm/mach-msm/generic_gpio.c              |  274 ++++
 arch/arm/mach-msm/gpio.c                      |  527 ++++++++
 arch/arm/mach-msm/gpio_chip.h                 |   38 
 arch/arm/mach-msm/gpio_hw.h                   |  100 +
 arch/arm/mach-msm/hw3d.c                      |  186 +++
 arch/arm/mach-msm/idle.S                      |   89 +
 arch/arm/mach-msm/io.c                        |   90 +
 arch/arm/mach-msm/irq.c                       |  514 ++++++++
 arch/arm/mach-msm/nand_partitions.c           |   87 +
 arch/arm/mach-msm/perf.c                      |  184 +++
 arch/arm/mach-msm/pm.c                        |  520 ++++++++
 arch/arm/mach-msm/pm.h                        |   31 
 arch/arm/mach-msm/proc_comm.h                 |  106 +
 arch/arm/mach-msm/rpc_server_dog_keepalive.c  |   62 +
 arch/arm/mach-msm/rpc_server_time_remote.c    |   75 +
 arch/arm/mach-msm/smd.c                       | 1326 ++++++++++++++++++++++
 arch/arm/mach-msm/smd_private.h               |  159 ++
 arch/arm/mach-msm/smd_qmi.c                   |  865 ++++++++++++++
 arch/arm/mach-msm/smd_rpcrouter.c             | 1165 +++++++++++++++++++
 arch/arm/mach-msm/smd_rpcrouter.h             |  190 +++
 arch/arm/mach-msm/smd_rpcrouter_device.c      |  339 +++++
 arch/arm/mach-msm/smd_rpcrouter_servers.c     |  214 +++
 arch/arm/mach-msm/smd_tty.c                   |  202 +++
 arch/arm/mach-msm/timer.c                     |  431 +++++++
 arch/arm/mach-msm/vreg.c                      |  143 ++
 arch/arm/mm/Kconfig                           |    3 
 arch/arm/mm/proc-v6.S                         |   27 
 arch/arm/tools/mach-types                     |  220 +++
 drivers/Makefile                              |    2 
 drivers/android/Kconfig                       |    9 
 drivers/android/Makefile                      |    1 
 drivers/android/pmem.c                        | 1314 ++++++++++++++++++++++
 drivers/char/Kconfig                          |    4 
 drivers/char/Makefile                         |    1 
 drivers/char/dcc_tty.c                        |  331 +++++
 drivers/i2c/busses/Kconfig                    |    7 
 drivers/i2c/busses/Makefile                   |    1 
 drivers/i2c/busses/i2c-msm.c                  |  514 ++++++++
 drivers/input/misc/Kconfig                    |    5 
 drivers/input/misc/Makefile                   |    1 
 drivers/input/misc/gpio_axis.c                |  190 +++
 drivers/input/misc/gpio_event.c               |  224 +++
 drivers/input/misc/gpio_input.c               |  303 +++++
 drivers/input/misc/gpio_matrix.c              |  397 ++++++
 drivers/input/misc/gpio_output.c              |   76 +
 drivers/input/touchscreen/Kconfig             |    6 
 drivers/input/touchscreen/Makefile            |    1 
 drivers/input/touchscreen/synaptics_i2c_rmi.c |  565 +++++++++
 drivers/misc/Kconfig                          |    7 
 drivers/misc/Makefile                         |    1 
 drivers/misc/kernel_debugger.c                |   80 +
 drivers/mmc/card/block.c                      |  216 +++
 drivers/mmc/card/queue.c                      |    6 
 drivers/mmc/core/Kconfig                      |    7 
 drivers/mmc/core/core.c                       |   16 
 drivers/mmc/core/sd.c                         |   38 
 drivers/mmc/core/sdio.c                       |   68 -
 drivers/mmc/host/Kconfig                      |    5 
 drivers/mmc/host/Makefile                     |    1 
 drivers/mmc/host/msm_sdcc.c                   | 1341 ++++++++++++++++++++++
 drivers/mmc/host/msm_sdcc.h                   |  253 ++++
 drivers/mtd/devices/Kconfig                   |    7 
 drivers/mtd/devices/Makefile                  |    1 
 drivers/mtd/devices/msm_nand.c                | 1272 +++++++++++++++++++++
 drivers/mtd/devices/msm_nand.h                |   74 +
 drivers/net/Kconfig                           |    6 
 drivers/net/Makefile                          |    2 
 drivers/net/msm_rmnet.c                       |  203 +++
 drivers/net/smc91x.h                          |   14 
 drivers/rtc/Kconfig                           |    6 
 drivers/rtc/Makefile                          |    1 
 drivers/rtc/rtc-msm7x00a.c                    |  251 ++++
 drivers/serial/Kconfig                        |   14 
 drivers/serial/Makefile                       |    2 
 drivers/serial/msm_serial.c                   |  760 ++++++++++++
 drivers/serial/msm_serial.h                   |  119 ++
 drivers/serial/msm_serial_debugger.c          |  359 ++++++
 drivers/usb/Kconfig                           |    2 
 drivers/usb/function/Kconfig                  |   49 
 drivers/usb/function/Makefile                 |    9 
 drivers/usb/function/adb.c                    |  463 +++++++
 drivers/usb/function/diag.c                   |  263 ++++
 drivers/usb/function/ether.c                  |  327 +++++
 drivers/usb/function/loopback.c               |  128 ++
 drivers/usb/function/msm_hsusb.c              | 1528 ++++++++++++++++++++++++++
 drivers/usb/function/msm_hsusb_hw.h           |  157 ++
 drivers/usb/function/null.c                   |  118 ++
 drivers/usb/function/ums.c                    |  469 +++++++
 drivers/usb/function/usb_function.h           |  117 +
 drivers/usb/function/zero.c                   |  120 ++
 drivers/video/Kconfig                         |    9 
 drivers/video/Makefile                        |    1 
 drivers/video/msm/Makefile                    |   18 
 drivers/video/msm/mddi.c                      |  872 ++++++++++++++
 drivers/video/msm/mddi_client_dummy.c         |   57 
 drivers/video/msm/mddi_client_toshiba.c       |  183 +++
 drivers/video/msm/mddi_hw.h                   |  303 +++++
 drivers/video/msm/mdp.c                       |  302 +++++
 drivers/video/msm/mdp_csc_table.h             |  582 +++++++++
 drivers/video/msm/mdp_hw.h                    |  598 ++++++++++
 drivers/video/msm/mdp_ppp.c                   |  825 ++++++++++++++
 drivers/video/msm/mdp_scale_tables.c          |  634 ++++++++++
 drivers/video/msm/mdp_scale_tables.h          |   37 
 drivers/video/msm/msm_fb.c                    |  560 +++++++++
 drivers/video/msm/msm_fb.txt                  |   53 
 include/asm-arm/arch-msm/board.h              |   87 +
 include/asm-arm/arch-msm/clock.h              |   35 
 include/asm-arm/arch-msm/debug-macro.S        |   46 
 include/asm-arm/arch-msm/dma.h                |  165 ++
 include/asm-arm/arch-msm/entry-macro.S        |   38 
 include/asm-arm/arch-msm/fiq.h                |   32 
 include/asm-arm/arch-msm/gpio.h               |   48 
 include/asm-arm/arch-msm/hardware.h           |   18 
 include/asm-arm/arch-msm/io.h                 |   33 
 include/asm-arm/arch-msm/irqs.h               |   89 +
 include/asm-arm/arch-msm/memory.h             |   27 
 include/asm-arm/arch-msm/msm_adsp.h           |   48 
 include/asm-arm/arch-msm/msm_fb.h             |   65 +
 include/asm-arm/arch-msm/msm_iomap.h          |  140 ++
 include/asm-arm/arch-msm/msm_rpcrouter.h      |  145 ++
 include/asm-arm/arch-msm/msm_smd.h            |  107 +
 include/asm-arm/arch-msm/rpc_clkctl.h         |   36 
 include/asm-arm/arch-msm/rpc_pm.h             |  100 +
 include/asm-arm/arch-msm/system.h             |   26 
 include/asm-arm/arch-msm/timex.h              |   20 
 include/asm-arm/arch-msm/uncompress.h         |   44 
 include/asm-arm/arch-msm/vmalloc.h            |   22 
 include/asm-arm/arch-msm/vreg.h               |   29 
 include/asm-arm/mach/mmc.h                    |   12 
 include/linux/android_pmem.h                  |   64 +
 include/linux/gpio_event.h                    |  143 ++
 include/linux/kernel_debugger.h               |   41 
 include/linux/mmc/core.h                      |    8 
 include/linux/mmc/host.h                      |   17 
 include/linux/mmc/sdio_func.h                 |    7 
 include/linux/msm_adsp.h                      |   74 +
 include/linux/msm_mdp.h                       |   84 +
 include/linux/msm_perf.h                      |   89 +
 include/linux/msm_rpcrouter.h                 |   44 
 include/linux/serial_core.h                   |    3 
 include/linux/synaptics_i2c_rmi.h             |   42 
 160 files changed, 33494 insertions(+), 44 deletions(-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
