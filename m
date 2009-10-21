Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZJUUn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZJUUn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZJUUn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:43:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:37138 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZJUUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=q2fh5hKmAw8HMByGxKIceDV8z6KiZFlMslQSD47cRlKUPcDg9wu8tyG8i/GUulpty8
         UvH62NX+f+TkjG7EATvd2+52K7HCExrYbRYU5w1R2ySTr4VWR7DjjePW+7QqpXlUeVLB
         dDpPtqhnzfxL7osWDR4yPZNCG7EpeLcoGp/Bk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:43:44 +0200
Message-Id: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/12] Staging: rt28x0 cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cleanups for rt28x0 drivers (almost 8 KLOC gone) removing private
driver parameters, ioctls, WEXT handlers and unused features..

Tested with RT2860 and RT3070 (both still work for me :).

diffstat:
 drivers/staging/rt2860/Makefile             |    2 
 drivers/staging/rt2860/chip/rtmp_phy.h      |   36 
 drivers/staging/rt2860/chips/rt30xx.c       |    2 
 drivers/staging/rt2860/common/cmm_asic.c    |    6 
 drivers/staging/rt2860/common/cmm_info.c    | 4039 +++++-----------------------
 drivers/staging/rt2860/common/cmm_mac_pci.c |    7 
 drivers/staging/rt2860/common/cmm_profile.c | 1779 ------------
 drivers/staging/rt2860/common/crypt_hmac.c  |   85 
 drivers/staging/rt2860/common/crypt_sha2.c  |  257 -
 drivers/staging/rt2860/common/ee_efuse.c    | 1145 -------
 drivers/staging/rt2860/common/ee_prom.c     |   48 
 drivers/staging/rt2860/common/eeprom.c      |    6 
 drivers/staging/rt2860/common/mlme.c        |    1 
 drivers/staging/rt2860/common/rtmp_init.c   |   21 
 drivers/staging/rt2860/common/rtmp_mcu.c    |    2 
 drivers/staging/rt2860/crypt_hmac.h         |   11 
 drivers/staging/rt2860/crypt_sha2.h         |   28 
 drivers/staging/rt2860/eeprom.h             |   15 
 drivers/staging/rt2860/oid.h                |   19 
 drivers/staging/rt2860/pci_main_dev.c       |   35 
 drivers/staging/rt2860/rt_config.h          |    8 
 drivers/staging/rt2860/rt_linux.c           |   30 
 drivers/staging/rt2860/rt_linux.h           |   10 
 drivers/staging/rt2860/rt_main_dev.c        |    6 
 drivers/staging/rt2860/rt_profile.c         |   95 
 drivers/staging/rt2860/rtmp.h               |  300 --
 drivers/staging/rt2860/rtmp_chip.h          |    4 
 drivers/staging/rt2860/rtmp_def.h           |    9 
 drivers/staging/rt2860/sta/connect.c        |    1 
 drivers/staging/rt2860/sta_ioctl.c          | 1315 ---------
 drivers/staging/rt2860/usb_main_dev.c       |    7 
 drivers/staging/rt2870/Makefile             |    2 
 drivers/staging/rt2870/common/rtusb_io.c    |   11 
 33 files changed, 819 insertions(+), 8523 deletions(-)
