Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbXIXKUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbXIXKUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXIXKUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:20:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:24741 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXIXKUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Bp5Re5f0SY8sUN6LT/4NpUFU6XFHGyyfq0VuwllICs2mmRATuEeF7r3oXBuC7ReoT+tAGsXRkJZs5V/TDeins2eilzh+cHX6hlFivHlzLcjTuQCmfPEhitEUlrEp2YTErRJt3iz7YTH48yEQ8o6kzutmCOdP9NyRWQZKi/pIGoA=
Message-ID: <3f9a31f40709240320mb213a7an87cee8bf5517d7f7@mail.gmail.com>
Date: Mon, 24 Sep 2007 15:50:43 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22.7 autoconf.h is screwed up
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

2.6.22.7's include/linux/autoconf.h is completely screwed up as
compare to 2.6.10's autoconf.h .

2.6.22.7 totally changed the meaning of autoconf.h

By just reading autoconf.h of 2.6.10 , we can understand what is the
system and its configuration, it is properly arranged and divided into
categories :

/*
* Automatically generated C config: don't edit
* Linux kernel version: 2.6.10
* Mon Sep 24 20:56:59 2007
*/
#define AUTOCONF_INCLUDED
#define CONFIG_X86 1
#define CONFIG_MMU 1
#define CONFIG_UID16 1
#define CONFIG_GENERIC_ISA_DMA 1
#define CONFIG_GENERIC_IOMAP 1

/*
* Code maturity level options
*/
#define CONFIG_EXPERIMENTAL 1
#define CONFIG_CLEAN_COMPILE 1
#define CONFIG_LOCK_KERNEL 1

/*
* General setup
*/
#define CONFIG_LOCALVERSION ""
#define CONFIG_SWAP 1
#define CONFIG_SYSVIPC 1
#define CONFIG_POSIX_MQUEUE 1
#define CONFIG_BSD_PROCESS_ACCT 1
#undef CONFIG_BSD_PROCESS_ACCT_V3
#define CONFIG_SYSCTL 1


And on 2.6.22.7's autoconf.h is haphazard, not formatted , not
readable and looks totally funny.

/*
* Automatically generated C config: don't edit
* Linux kernel version: 2.6.22.7
* Mon Sep 24 20:49:40 2007
*/
#define AUTOCONF_INCLUDED
#define CONFIG_USB_SISUSBVGA_MODULE 1
#define CONFIG_VIDEO_V4L1_COMPAT 1
#define CONFIG_PCMCIA_FMVJ18X_MODULE 1
#define CONFIG_BLK_CPQ_DA_MODULE 1
#define CONFIG_BLK_DEV_FD_MODULE 1
#define CONFIG_ACPI_AC_MODULE 1
#define CONFIG_SECURITY_NETWORK 1
#define CONFIG_DEBUG_SPINLOCK_SLEEP 1
#define CONFIG_OSF_PARTITION 1
#define CONFIG_USB_LEGOTOWER_MODULE 1
#define CONFIG_FB_TRIDENT_MODULE 1
#define CONFIG_FB_RIVA_BACKLIGHT 1
#define CONFIG_DVB_PLUTO2_MODULE 1
#define CONFIG_GAMEPORT_NS558_MODULE 1
#define CONFIG_JOYSTICK_GRIP_MODULE 1
#define CONFIG_HISAX_ELSA 1
#define CONFIG_BONDING_MODULE 1
#define CONFIG_BLK_DEV_HPT366 1
#define CONFIG_MTD_ABSENT_MODULE 1


Can you please let me know what is the idea behind this latest
autoconf.h and who is creator of this ugly autoconf.h.

Thank you,

Jaswinder Singh.
