Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYLGRVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYLGRVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYLGRVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:21:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:23256 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYLGRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=vxAO8QS/uhLJjAPrFp2wcPrzZbr3cWZA0z/9tg3sEf9gLOf9X2BRrwztYkBQvGk0mV
         UHUvAyvIJ01GxZpgjijOAo95O1lPkP+d6auv7kiu2FMSWUVQ+Hl0bWboW7l5sIfcBZ7h
         4ESZSMb8yrQHUF2gQf5wV9aOA3PpuOEHn892Y=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/4] ide: remove ide-scsi remnants
Date: Sun,  7 Dec 2008 18:21:07 +0100
Message-Id: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are the patches removing bits and pieces belonging to the late ide-scsi :).

 drivers/ide/ide-atapi.c  |   97 +++++++++++++++++++++++++++++++++++++---------
 drivers/ide/ide-io.c     |    3 +
 drivers/ide/ide-ioctls.c |    3 +-
 drivers/ide/ide-probe.c  |    2 +
 include/linux/ide.h      |   34 ++++++++++------
 5 files changed, 106 insertions(+), 33 deletions(-)
