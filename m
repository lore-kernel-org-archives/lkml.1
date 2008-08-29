Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYH2I71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYH2I71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYH2I7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:59:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:63883 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYH2I7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Rn4YuR3MfeC8MCsqxwrUCZ8+fUtZCYjypj6+0CNLN6q+qMQMKFcDUY5I3dNi78SzGJ
         MniCS92HlOfhQV1EpQ9L+CnrxPoW1KZXYOlHFL6aQGDajC4qj7lMWr1cWTKZ7v0IGJhy
         4yh7wg8H808XCVwcoO3cwfm1nwgn8qnE9HqEA=
Message-ID: <e68bb3470808290159s734283d7s2270bbbf455d630d@mail.gmail.com>
Date: Fri, 29 Aug 2008 16:59:16 +0800
From: "=?GB2312?B?zfLX2suz?=" <mcuos.com@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.17.14]arm:Add the Nuvoton w90x900 Platform support to ARM tree
Cc: torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vincen.zswan mcuos.com@gmail.com
hi,
I come from Nuvoton technology corporation.I have add the Nuvoton ARM
series IC w90x900(W90P910,W90P920,W90P950,W90N960) Platform support to
LINUX ARM tree and make a patch to linux-2.6.17.14.

The patch named:nuvoton-arm-linux-2.6.17.patch
you can get the patch from link: http://www.mcuos.com/attachment.php?aid=530

Changes:
(1)Add two directory to support W90X900 IC

/arch/arm/mach-W90X900
/include/asm-arm/arch-W90X900

(2)w90x900 bootloader don't auto sent the r1=mach type num,so add this file

/arch/arm/kernel/head-common.S

(3)I have apply the w90x900 mach-types num is 1860.

/arch/arm/tools/mach-types

(4)w90x900 EVB all drivers have been test.
/drivers/char/nuvoton_sc.h
/drivers/char/tsc2007.c
/drivers/char/w90x900_mouse.c
/drivers/char/w90x900_sc.c
/drivers/char/w90x900_ts.c
/drivers/char/w90x900_usb.c

/drivers/i2c/busses/i2c-w90x900-p0.c
/drivers/i2c/busses/i2c-w90x900-p1.c

/drivers/ide/w90x900_ide.c

/drivers/input/serio/w90x900_ps2.c
/drivers/input/touchscreen/w90x900_ts.c
/drivers/input/w90x900_keypad.c

/drivers/mtd/maps/w90x900_flash.c

/drivers/net/8139too.c
/drivers/net/arm/eth_w90x900.c
/drivers/net/r8169.c

/drivers/pci/pci_w90x900.c

/drivers/rtc/w90x900_rtc.c

/drivers/scsi/w90x900_ms.c
/drivers/scsi/w90x900_sdio.c

/drivers/serial/serial_core.c
/drivers/serial/w90x900_serial.c
/drivers/spi/spi_w90x900.c

/drivers/usb/host/ehci-w90x900.c
/drivers/usb/host/ohci-w90x900.c

/drivers/video/w90x900fb.c

/sound/oss/w90x900_WM8978.c
/sound/oss/w90x900_ac97.c
/sound/oss/w90x900_audio.c
/sound/oss/w90x900_i2s.c
(5)When patch the w90x900 paltform,some kernel files need update by nuvoton.

/drivers/char/keyboard.c
/drivers/ide/ide-io.c
/drivers/ide/ide.c
/drivers/input/keyboard/atkbd.c
/drivers/usb/host/ehci.h
/drivers/usb/host/ohci-hcd.c
/drivers/usb/core/hcd.c
/drivers/usb/core/hub.c
/drivers/usb/host/ehci-hcd.c
/drivers/usb/host/ehci-hub.c
/include/asm-arm/ide.h
/include/linux/ide.h
/include/linux/serial_core.h


Thanks to everybody who discussed the patch.

Best Regards
Vincen

Signed-off-by: vincen.zswan <mcuos.com@gmail.com>
