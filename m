Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbXCEJXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbXCEJXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 04:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXCEJXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 04:23:22 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:43361 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbXCEJXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 04:23:21 -0500
To: "young dave" <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-rc2 compile warnings
References: <a8e1da0703050104g74d45e4ay79846e81a970ec00@mail.gmail.com>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Mon, 05 Mar 2007 12:23:46 +0300
In-Reply-To: <a8e1da0703050104g74d45e4ay79846e81a970ec00@mail.gmail.com> (young dave's message of "Mon, 5 Mar 2007 09:04:38 +0000")
Message-ID: <87d53o9h7h.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"young dave" <hidave.darkstar@gmail.com> writes:

> Hi,
> As I compile the linux-2.6.21-rc2  (gcc version 3.4.6), there's some
> warning  messages:
you should probably check -mm tree may be some issues already fixed where.
>
> drivers/video/Kconfig:1622:warning: 'select' used by config symbol
> 'FB_PS3' refer to undefined symbol 'PS3_PS3AV'
>
> fs/partitions/check.c: In function `add_partition':
> fs/partitions/check.c:388: warning: ignoring return value of
> `kobject_add', declared with attribute warn_unused_result
> fs/partitions/check.c:391: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> fs/partitions/check.c:399: warning: ignoring return value of
> `sysfs_create_file', declared with attribute warn_unused_result
>
> drivers/ata/libata-sff.c: In function `ata_pci_init_one':
> drivers/ata/libata-sff.c:820: warning: ignoring return value of
> `pci_request_region', declared with attribute warn_unused_result
> drivers/ata/libata-sff.c:822: warning: ignoring return value of
> `pci_request_region', declared with attribute warn_unused_result
> drivers/ata/libata-sff.c:824: warning: ignoring return value of
> `pci_request_region', declared with attribute warn_unused_result
>
> drivers/base/core.c: In function `device_add':
> drivers/base/core.c:580: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c:585: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c:589: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c:594: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c: In function `device_rename':
> drivers/base/core.c:1039: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c:1049: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
>
> drivers/block/floppy.c: In function `floppy_init':
> drivers/block/floppy.c:4337: warning: ignoring return value of
I've already sent patch, but i wasn't added to -mm yet ( at least
it not rejecdted yet :) ) 
> `device_create_file', declared with attribute warn_unused_result
> drivers/cpufreq/cpufreq.c: In function `cpufreq_add_dev':
> drivers/cpufreq/cpufreq.c:826: warning: ignoring return value of
> `sysfs_create_file', declared with attribute warn_unused_result
> drivers/cpufreq/cpufreq.c:830: warning: ignoring return value of
> `sysfs_create_file', declared with attribute warn_unused_result
> drivers/cpufreq/cpufreq.c:832: warning: ignoring return value of
> `sysfs_create_file', declared with attribute warn_unused_result
>
> drivers/ide/pci/cs5530.c: In function `init_chipset_cs5530':
> drivers/ide/pci/cs5530.c:244: warning: ignoring return value of
> `pci_set_mwi', declared with attribute warn_unused_result
>
> drivers/ide/pci/sc1200.c: In function `sc1200_resume':
> drivers/ide/pci/sc1200.c:397: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
>
> drivers/ide/setup-pci.c: In function `ide_scan_pcibus':
> drivers/ide/setup-pci.c:866: warning: ignoring return value of
> `__pci_register_driver', declared with attribute warn_unused_result
>
> drivers/input/mousedev.c: In function `mousedev_connect':
> drivers/input/mousedev.c:664: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
>
> drivers/input/joydev.c: In function `joydev_connect':
> drivers/input/joydev.c:542: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
>
>
> drivers/input/evdev.c: In function `evdev_connect':
> drivers/input/evdev.c:653: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/message/i2o/device.c: In function `i2o_device_add':
> drivers/message/i2o/device.c:247: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/message/i2o/device.c:254: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/message/i2o/device.c:260: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
> drivers/message/i2o/device.c:267: warning: ignoring return value of
> `sysfs_create_link', declared with attribute warn_unused_result
>  CC      drivers/message/i2o/debug.
>
> drivers/net/sk98lin/skge.c: In function `skge_resume':
> drivers/net/sk98lin/skge.c:5128: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
> drivers/net/tulip/xircom_tulip_cb.c: In function `outl_CSR6':
> drivers/net/tulip/xircom_tulip_cb.c:348: warning: `save_flags' is
> deprecated (declared at include/linux/interrupt.h:214)
> drivers/net/tulip/xircom_tulip_cb.c:349: warning: `cli' is deprecated
> (declared at include/linux/interrupt.h:206)
> drivers/net/tulip/xircom_tulip_cb.c:358: warning: `restore_flags' is
> deprecated (declared at include/linux/interrupt.h:219)
> drivers/net/tulip/xircom_tulip_cb.c:376: warning: `restore_flags' is
> deprecated (declared at include/linux/interrupt.h:219)
> drivers/net/tulip/xircom_tulip_cb.c:384: warning: `restore_flags' is
> deprecated (declared at include/linux/interrupt.h:219)
> drivers/net/tulip/xircom_tulip_cb.c: In function `xircom_ioctl':
> drivers/net/tulip/xircom_tulip_cb.c:1456: warning: `save_flags' is
> deprecated (declared at include/linux/interrupt.h:214)
> drivers/net/tulip/xircom_tulip_cb.c:1457: warning: `cli' is deprecated
> (declared at include/linux/interrupt.h:206)
> drivers/net/tulip/xircom_tulip_cb.c:1459: warning: `restore_flags' is
> deprecated (declared at include/linux/interrupt.h:219)
> drivers/net/tulip/xircom_tulip_cb.c:1464: warning: `save_flags' is
> deprecated (declared at include/linux/interrupt.h:214)
> drivers/net/tulip/xircom_tulip_cb.c:1465: warning: `cli' is deprecated
> (declared at include/linux/interrupt.h:206)
> drivers/net/tulip/xircom_tulip_cb.c:1485: warning: `restore_flags' is
> deprecated (declared at include/linux/interrupt.h:219)
> drivers/net/tulip/xircom_tulip_cb.c: In function `set_rx_mode':
> drivers/net/tulip/xircom_tulip_cb.c:1593: warning: `save_flags' is
> deprecated (declared at include/linux/interrupt.h:214)
> drivers/net/tulip/xircom_tulip_cb.c:1593: warning: `cli' is deprecated
> (declared at include/linux/interrupt.h:206)
> drivers/net/tulip/xircom_tulip_cb.c:1620: warning: `restore_flags' is
> deprecated (declared at include/linux/interrupt.h:219)
> drivers/net/tulip/xircom_tulip_cb.c: In function `xircom_resume':
> drivers/net/tulip/xircom_tulip_cb.c:1661: warning: ignoring return
> value of `pci_enable_device', declared with attribute
> warn_unused_result
> drivers/net/cassini.c: In function `cas_init_one':
> drivers/net/cassini.c:4925: warning: ignoring return value of
> `pci_set_mwi', declared with attribute warn_unused_result
>
>
> drivers/net/3c59x.c: In function `vortex_resume':
> drivers/net/3c59x.c:829: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
in 2.6.21-rc2-mm1
> drivers/net/3c59x.c: In function `vortex_up':
> drivers/net/3c59x.c:1495: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
>
>
> drivers/net/ne2k-pci.c: In function `ne2k_pci_resume':
> drivers/net/ne2k-pci.c:676: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
>
> drivers/net/eepro100.c: In function `eepro100_resume':
> drivers/net/eepro100.c:2298: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
you should check SAW's comment in this function :)  
>
> include/linux/pci.h: In function `tlan_probe':
> drivers/net/tlan.c:486: warning: ignoring return value of
> `pci_register_driver', declared with attribute warn_unused_result
>
> drivers/net/natsemi.c: In function `natsemi_resume':
> drivers/net/natsemi.c:3237: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
> drivers/net/starfire.c: In function `starfire_init_one':
> drivers/net/starfire.c:744: warning: ignoring return value of
> `pci_set_mwi', declared with attribute warn_unused_result
> In file included from drivers/net/at1700.c:41:
> include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy -
> please move your driver to the new sysfs api"
> In file included from drivers/net/eexpress.c:115:
> include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy -
> please move your driver to the new sysfs api"
> drivers/net/cs89x0.c:198: warning: 'netcard_portlist' defined but not used
> drivers/pci/search.c: In function `pci_find_slot':
> drivers/pci/search.c:100: warning: `pci_find_device' is deprecated
> (declared at include/linux/pci.h:475)
> drivers/pci/search.c: At top level:
> drivers/pci/search.c:434: warning: `pci_find_device' is deprecated
> (declared at drivers/pci/search.c:242)
> drivers/pci/search.c:434: warning: `pci_find_device' is deprecated
> (declared at drivers/pci/search.c:242)
> drivers/serial/8250_pci.c: In function `pciserial_resume_one':
> drivers/serial/8250_pci.c:1826: warning: ignoring return value of
> `pci_enable_device', declared with attribute warn_unused_result
Ohh this was discussed already discussed many times. 
> drivers/video/aty/radeon_base.c: In function `radeonfb_pci_register':
> drivers/video/aty/radeon_base.c:2317: warning: ignoring return value
> of `sysfs_create_bin_file', declared with attribute warn_unused_result
> drivers/video/aty/radeon_base.c:2319: warning: ignoring return value
> of `sysfs_create_bin_file', declared with attribute warn_unused_result
> WARNING: drivers/net/sis900.o - Section mismatch: reference to
> .init.text:sis900_mii_probe from .text between 'sis900_probe' (at
> offset 0x4e2) and 'sis900_default_phy'
> WARNING: drivers/net/sunhme.o - Section mismatch: reference to
> .init.text: from .text between 'happy_meal_pci_probe' (at offset
> 0x3129) and 'happy_meal_pci_remove'
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
> .init.text: from .text between 'de_init_one' (at offset 0x25ec) and
> 'de_remove_one'
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
> .init.text: from .text between 'de_init_one' (at offset 0x26bb) and
> 'de_remove_one'
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
> .init.text: from .text between 'de_init_one' (at offset 0x26c2) and
> 'de_remove_one'
>
>
> regards
> dave
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

