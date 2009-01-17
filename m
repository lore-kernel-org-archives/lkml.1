Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbZAQK6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbZAQK6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 05:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZAQK6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 05:58:03 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:46448 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755192AbZAQK6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 05:58:01 -0500
Message-ID: <4971B95F.9010101@pardus.org.tr>
Date: Sat, 17 Jan 2009 12:56:31 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Linux 2.6.29_rc2] Undefined symbols when CONFIG_MFD_PCF50633 is
 enabled
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just enabled the following new config parameters:

++CONFIG_INPUT_PCF50633_PMU=m
++CONFIG_CHARGER_PCF50633=m
++CONFIG_MFD_PCF50633=m
++CONFIG_PCF50633_ADC=m
++CONFIG_PCF50633_GPIO=m
++CONFIG_REGULATOR_PCF50633=m
++CONFIG_RTC_DRV_PCF50633=m

and then the build/installation failed with the following symbol errors:

  ..
  ..
  OBJCOPY arch/x86/boot/vmlinux.bin
  AS      arch/x86/boot/header.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  BUILD   arch/x86/boot/bzImage
Root device is (104, 1)
Setup is 12716 bytes (padded to 12800 bytes).
System is 2092 kB
CRC b335d63f
Kernel: arch/x86/boot/bzImage is ready  (#1)
ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
make[1]: *** [__modpost] Error 1


-- 

Ozan Çağlayan
<ozan_at_pardus.org.tr>

