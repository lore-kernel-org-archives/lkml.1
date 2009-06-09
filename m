Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbZFIKtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbZFIKtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759999AbZFIKsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:48:17 -0400
Received: from mail.atmel.fr ([81.80.104.162]:65329 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbZFIKsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:48:16 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-usb@vger.kernel.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com
Subject: at91/USB: high speed USB support for at91sam9g45 series
Date: Tue,  9 Jun 2009 13:38:11 +0200
Message-Id: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those 2 patches are adding the USB high speed 
support to the at91sam9g45 SOC family.

They are relying on the integration of at91sam9g45 
already posted. Here is the patch series that you 
will have to take into account before applying 
those patches.

clock.c changes:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=5438/1

9g45 introduction:
http://lkml.org/lkml/2009/6/4/77
http://lkml.org/lkml/2009/6/4/76
http://lkml.org/lkml/2009/6/4/78

atmel_usba tiny modification (bias function only for 9rl):
http://lkml.org/lkml/2009/6/5/355

 arch/arm/mach-at91/at91sam9g45_devices.c |   56 +++++
 arch/arm/mach-at91/board-sam9m10g45ek.c  |    1 +
 arch/arm/mach-at91/include/mach/board.h  |    1 +
 arch/arm/tools/mach-types                |    1 +
 drivers/usb/Kconfig                      |    1 +
 drivers/usb/gadget/Kconfig               |    4 +-
 drivers/usb/host/ehci-atmel.c            |  251 ++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c              |    5 +
 drivers/usb/host/ohci-at91.c             |    3 +-
 9 files changed, 320 insertions(+), 3 deletions(-)
 create mode 100644 drivers/usb/host/ehci-atmel.c


