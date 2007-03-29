Return-Path: <linux-kernel-owner+w=401wt.eu-S1030412AbXC2QxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412AbXC2QxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030449AbXC2QxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:53:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54567 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030412AbXC2QxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:53:23 -0400
Subject: Re: 2.6.21-rc5-mm2
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070326211627.c681af3b.akpm@linux-foundation.org>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 29 Mar 2007 09:53:27 -0800
Message-Id: <1175190807.13420.1.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 21:16 -0800, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/
> 
> 
> - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
>   scheduler has been added.

make allyesconfig - didn't give me a clean build :(
(not crucial for me to get it right -- but FYI).

Thanks,
Badari

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  CC      drivers/net/e100.o
  LD      drivers/net/wireless/built-in.o
  CC      drivers/net/epic100.o
  CC      drivers/net/sis190.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_switch_radio_on'
  CC      drivers/net/sis900.o
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_dma_tx_suspend'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dma_tx_suspend' changed from 141 in drivers/net/wireless/bcm43xx/built-in.o to 108 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_tail'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_pio_tx_resume'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_tx_resume' changed from 101 in drivers/net/wireless/bcm43xx/built-in.o to 89 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_phy_xmitpower'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_phy_xmitpower' changed from 1312 in drivers/net/wireless/bcm43xx/built-in.o to 1126 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_disable_hwint'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_shm_write16'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_shm_write16' changed from 127 in drivers/net/wireless/bcm43xx/built-in.o to 218 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_usb_tx'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_raw_phy_unlock'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_raw_phy_unlock' changed from 238 in drivers/net/wireless/bcm43xx/built-in.o to 168 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_switch_radio_off'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_dmacontroller_base'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_control_leds'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_debugfs_add_device'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_debugfs_add_device' changed from 535 in drivers/net/wireless/bcm43xx/built-in.o to 460 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_usb_disable_int'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_unlock_phy_regs'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_generate_txhdr'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_generate_txhdr' changed from 900 in drivers/net/wireless/bcm43xx/built-in.o to 1217 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_init'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_turn_off'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_turn_off' changed from 428 in drivers/net/wireless/bcm43xx/built-in.o to 238 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rx_qual_percent'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_plcp_get_ratecode_ofdm'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_dma_tx'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dma_tx' changed from 2312 in drivers/net/wireless/bcm43xx/built-in.o to 1652 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_get_channel'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_power_saving_ctl_bits'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_power_saving_ctl_bits' changed from 119 in drivers/net/wireless/bcm43xx/built-in.o to 109 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rf_clear'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_clear'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_leds_update'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_leds_update' changed from 1040 in drivers/net/wireless/bcm43xx/built-in.o to 625 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rf_init_al7230b'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_read_mac_addr'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_ioread32v'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rfwritev_cr_locked'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_sysfs_register'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_sysfs_register' changed from 260 in drivers/net/wireless/bcm43xx/built-in.o to 144 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rf_init_rf2959'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_set_interference_mitigation'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_set_interference_mitigation' changed from 6014 in drivers/net/wireless/bcm43xx/built-in.o to 5452 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_enable_int'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_init2060'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_mac_clear'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
ld: Warning: size of symbol `zd_mac_clear' changed from 126 in drivers/net/wireless/zd1211rw/built-in.o to 102 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_enable_rx'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_printk_bitdump'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_printk_bitdump' changed from 242 in drivers/net/wireless/bcm43xx/built-in.o to 255 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_set_beacon_interval'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_calc_nrssi_slope'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_calc_nrssi_slope' changed from 5595 in drivers/net/wireless/bcm43xx/built-in.o to 5208 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_nrssi_hw_update'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_nrssi_hw_update' changed from 87 in drivers/net/wireless/bcm43xx/built-in.o to 86 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_aci_detect'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_aci_detect' changed from 318 in drivers/net/wireless/bcm43xx/built-in.o to 223 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_set_tx_iq'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_dma_rx'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dma_rx' changed from 2366 in drivers/net/wireless/bcm43xx/built-in.o to 1864 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_debugfs_log_txstat'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_debugfs_log_txstat' changed from 135 in drivers/net/wireless/bcm43xx/built-in.o to 173 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_leds_init'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_leds_init' changed from 345 in drivers/net/wireless/bcm43xx/built-in.o to 339 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_ioread16'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_usb_init'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_ioread32v_locked'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_disable_rx'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_dma_init'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dma_init' changed from 855 in drivers/net/wireless/bcm43xx/built-in.o to 635 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_leds_switch_all'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_leds_switch_all' changed from 175 in drivers/net/wireless/bcm43xx/built-in.o to 180 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_nrssi_mem_update'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_nrssi_mem_update' changed from 189 in drivers/net/wireless/bcm43xx/built-in.o to 98 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_set_txpower_a'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_set_txpower_a' changed from 667 in drivers/net/wireless/bcm43xx/built-in.o to 603 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_aci_scan'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_aci_scan' changed from 690 in drivers/net/wireless/bcm43xx/built-in.o to 531 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_init2050'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_init2050' changed from 2418 in drivers/net/wireless/bcm43xx/built-in.o to 2363 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_phy_write'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_phy_write' changed from 59 in drivers/net/wireless/bcm43xx/built-in.o to 111 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_read_regdomain'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_debugfs_init'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_calc_nrssi_threshold'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_calc_nrssi_threshold' changed from 833 in drivers/net/wireless/bcm43xx/built-in.o to 696 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rx_rate'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_raw_phy_lock'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_raw_phy_lock' changed from 263 in drivers/net/wireless/bcm43xx/built-in.o to 191 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_pio_tx'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_tx' changed from 519 in drivers/net/wireless/bcm43xx/built-in.o to 343 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_nrssi_hw_write'
  CC      drivers/net/yellowfin.o
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_controller_restart'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_controller_restart' changed from 102 in drivers/net/wireless/bcm43xx/built-in.o to 48 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_shm_write32'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_shm_write32' changed from 208 in drivers/net/wireless/bcm43xx/built-in.o to 275 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `_zd_iowrite32v_locked'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_write16'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_write16' changed from 59 in drivers/net/wireless/bcm43xx/built-in.o to 53 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_iowrite32a'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_nrssi_hw_read'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_nrssi_hw_read' changed from 44 in drivers/net/wireless/bcm43xx/built-in.o to 43 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_printk_dump'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_printk_dump' changed from 122 in drivers/net/wireless/bcm43xx/built-in.o to 125 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rfwrite_cr_locked'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_unlock'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_unlock' changed from 72 in drivers/net/wireless/bcm43xx/built-in.o to 64 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_switch_radio_off'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rx_strength_percent'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_usb_enable_rx'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_write_mac_addr'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_dummy_transmission'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dummy_transmission' changed from 758 in drivers/net/wireless/bcm43xx/built-in.o to 555 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rfwritev_locked'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_chip_set_channel'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_ioread32'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
ld: Warning: size of symbol `zd_ioread32' changed from 88 in drivers/net/wireless/zd1211rw/built-in.o to 89 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_radio_read16'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_read16' changed from 341 in drivers/net/wireless/bcm43xx/built-in.o to 162 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_phy_read'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_phy_read' changed from 56 in drivers/net/wireless/bcm43xx/built-in.o to 97 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_shm_read16'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_shm_read16' changed from 126 in drivers/net/wireless/bcm43xx/built-in.o to 200 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_pio_tx_suspend'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_tx_suspend' changed from 69 in drivers/net/wireless/bcm43xx/built-in.o to 68 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `bcm43xx_tsf_read'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_tsf_read' changed from 361 in drivers/net/wireless/bcm43xx/built-in.o to 326 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_conf_tx':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:398: multiple definition of `zd_rf_init'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
  CC      drivers/net/acenic.o
  CC      drivers/net/natsemi.o
drivers/net/wireless/mac80211/built-in.o:(.bss+0x400e8): multiple definition of `zd_workqueue'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:1665: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_dmacontroller_tx_reset'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dmacontroller_tx_reset' changed from 270 in drivers/net/wireless/bcm43xx/built-in.o to 262 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_usb_ioread16v'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_pio_free'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_free' changed from 246 in drivers/net/wireless/bcm43xx/built-in.o to 104 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_phy_init_tssi2dbm_table'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_phy_init_tssi2dbm_table' changed from 832 in drivers/net/wireless/bcm43xx/built-in.o to 708 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_dma_free'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dma_free' changed from 314 in drivers/net/wireless/bcm43xx/built-in.o to 176 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_hexdump'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_dma_tx_resume'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dma_tx_resume' changed from 139 in drivers/net/wireless/bcm43xx/built-in.o to 105 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_phy_init'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_phy_init' changed from 1727 in drivers/net/wireless/bcm43xx/built-in.o to 1452 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_rf_set_channel'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_pio_freeze_txqueues'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_freeze_txqueues' changed from 279 in drivers/net/wireless/bcm43xx/built-in.o to 124 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_mac_suspend'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_mac_suspend' changed from 232 in drivers/net/wireless/bcm43xx/built-in.o to 220 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_usb_scnprint_id'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_switch_radio_on'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_plcp_get_ratecode_cck'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_chip_init_hw'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_pio_thaw_txqueues'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_thaw_txqueues' changed from 426 in drivers/net/wireless/bcm43xx/built-in.o to 272 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_tsf_write'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_tsf_write' changed from 296 in drivers/net/wireless/bcm43xx/built-in.o to 200 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_iowrite16a_locked'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_usb_enable_int'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_chip_set_multicast_hash'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_mac_enable'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_mac_enable' changed from 201 in drivers/net/wireless/bcm43xx/built-in.o to 191 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_rf_init_al2230'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_debugfs_exit'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_rf_init_hw'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_usb_disable_rx'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_pio_init'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_init' changed from 389 in drivers/net/wireless/bcm43xx/built-in.o to 218 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_iowrite16'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_debugfs_remove_device'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_debugfs_remove_device' changed from 173 in drivers/net/wireless/bcm43xx/built-in.o to 142 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_usb_iowrite16v'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_chip_disable_int'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_radio_turn_on'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_turn_on' changed from 559 in drivers/net/wireless/bcm43xx/built-in.o to 357 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_wireless_core_reset'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_wireless_core_reset' changed from 388 in drivers/net/wireless/bcm43xx/built-in.o to 237 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_iowrite32'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_dmacontroller_rx_reset'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_dmacontroller_rx_reset' changed from 154 in drivers/net/wireless/bcm43xx/built-in.o to 149 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_chip_enable_hwint'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
ld: Warning: size of symbol `zd_chip_enable_hwint' changed from 80 in drivers/net/wireless/zd1211rw/built-in.o to 79 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_rf_name'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_radio_selectchannel'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_selectchannel' changed from 1268 in drivers/net/wireless/bcm43xx/built-in.o to 1107 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_usb_clear'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_chip_lock_phy_regs'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_pio_rx'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_pio_rx' changed from 1004 in drivers/net/wireless/bcm43xx/built-in.o to 764 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_default_baseband_attenuation'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_default_baseband_attenuation' changed from 127 in drivers/net/wireless/bcm43xx/built-in.o to 31 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_usb_rfwrite'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_get_e2p_mac_addr'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_default_radio_attenuation'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_default_radio_attenuation' changed from 521 in drivers/net/wireless/bcm43xx/built-in.o to 351 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_mac_init_hw'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
ld: Warning: size of symbol `zd_mac_init_hw' changed from 410 in drivers/net/wireless/zd1211rw/built-in.o to 279 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_rf_scnprint_id'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_sysfs_unregister'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_sysfs_unregister' changed from 96 in drivers/net/wireless/bcm43xx/built-in.o to 50 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_shm_read32'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_shm_read32' changed from 210 in drivers/net/wireless/bcm43xx/built-in.o to 261 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_rx'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_rx' changed from 1652 in drivers/net/wireless/bcm43xx/built-in.o to 1723 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `zd_iowrite32a_locked'
drivers/net/wireless/zd1211rw/built-in.o:drivers/net/wireless/zd1211rw/zd_chip.c:89: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_radio_lock'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_lock' changed from 66 in drivers/net/wireless/bcm43xx/built-in.o to 61 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_radio_set_txpower_bg'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_radio_set_txpower_bg' changed from 645 in drivers/net/wireless/bcm43xx/built-in.o to 404 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_phy_set_baseband_attenuation'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_phy_set_baseband_attenuation' changed from 243 in drivers/net/wireless/bcm43xx/built-in.o to 145 in drivers/net/wireless/mac80211/built-in.o
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_leds_exit'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
drivers/net/wireless/mac80211/built-in.o: In function `rtl8225_write':
drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c:496: multiple definition of `bcm43xx_default_txctl1'
drivers/net/wireless/bcm43xx/built-in.o:drivers/net/wireless/bcm43xx/bcm43xx_main.c:696: first defined here
ld: Warning: size of symbol `bcm43xx_default_txctl1' changed from 141 in drivers/net/wireless/bcm43xx/built-in.o to 45 in drivers/net/wireless/mac80211/built-in.o
drivers/net/natsemi.c: In function ‘natsemi_resume’:
drivers/net/natsemi.c:3255: warning: ignoring return value of ‘pci_enable_device’, declared with attribute warn_unused_result
  CC      drivers/net/ns83820.o
  CC      drivers/net/fealnx.o
make[3]: *** [drivers/net/wireless/built-in.o] Error 1
make[2]: *** [drivers/net/wireless] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


