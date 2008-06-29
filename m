Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbYF2K7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbYF2K7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 06:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYF2K7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:56959 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYF2K7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=rmNTi/QSnhf2JZHD/Su8XoKJ+iqZDkcj+EN/vy6eLSy+AtotNPYxwjhtO5d1BLU5ey
         NrVJ5dvFw/1TBaI2b24BgpO/XcjF3wU4CwnqZgnCHIEriGkaz+ONSrjYaGLU1ABW6vgB
         WJVq0Ljj37tpCUCn6lgMwMqsUXR5hrYly5MOo=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 00/16] Generic ide device flags
Date: Sun, 29 Jun 2008 12:59:03 +0200
Message-Id: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's another series of generic ide tweaks. The biggest change in here is the
introduction of ide_drive_t->dev_flags member which replaces all flags members
in the drivers structs. As a result, some PC_FLAGs become useless and got
removed, details in the respective patch descriptions below. The changes have
been tested with the hardware i have (i.e., ide-cd and ide-floppy).


 drivers/ide/ide-atapi.c    |   26 ++++++---
 drivers/ide/ide-cd.c       |  108 ++++++++++++++++++++---------------------
 drivers/ide/ide-cd.h       |   38 --------------
 drivers/ide/ide-cd_ioctl.c |   27 +++++------
 drivers/ide/ide-floppy.c   |   81 ++++++++++++------------------
 drivers/ide/ide-tape.c     |  116 ++++++++++++++++++-------------------------
 drivers/scsi/ide-scsi.c    |   24 ++-------
 include/linux/ide.h        |   64 +++++++++++++++++++++++--
 8 files changed, 229 insertions(+), 255 deletions(-)


-- 
Regards/Gruß,
Boris.
