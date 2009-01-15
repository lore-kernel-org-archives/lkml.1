Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbZAOUD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbZAOUD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762875AbZAOUAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:24 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56109 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574AbZAOUAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Atr9AQGI259xzJuopTs2ZDTv4+KuvkERReBgiLGHrQSAoREToayV2U7pHwOJjnZjhZ
         X9BG7b2pNpytO/ulee4P36ZaE1tN7zm7Nv5U+X5dgPewOIqAcY6FhtsDtWcqeAX91STV
         wMXyhhm7N++srkvQfab9F2LFrIhM7m3qPHbA4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:00:32 +0100
Message-Id: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/9] ide: core code housekeeping
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some housekeeping for core IDE code... against pata-2.6 tree...

diffstat:
 drivers/ide/Kconfig         |    8 +
 drivers/ide/Makefile        |    7 -
 drivers/ide/ide-atapi.c     |    5
 drivers/ide/ide-cd.c        |    4
 drivers/ide/ide-devsets.c   |  190 +++++++++++++++++++++++++++++++++
 drivers/ide/ide-dma.c       |   57 ++++++++++
 drivers/ide/ide-io.c        |  245 +++++++++++--------------------------------
 drivers/ide/ide-iops.c      |   34 ------
 drivers/ide/ide-lib.c       |  240 ------------------------------------------
 drivers/ide/ide-park.c      |   25 ++++
 drivers/ide/ide-xfer-mode.c |  246 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide.c           |  154 ---------------------------
 include/linux/ide.h         |   21 ++-
 13 files changed, 613 insertions(+), 623 deletions(-)
