Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYHJPhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYHJPhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYHJPhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:37:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYHJPhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=ZFvxa9/niVeIgTnbVmmP1fNPReipssvJpGLu01f24Iv/HASVJYAxHU7pFVOtTXmdOs
         7L0RaIz8kqmi2tvQOBFUUzj1PdA/smHq1dOTweRS4rWJt9GxEkOsFzabIi/T17WPsRd1
         ysSKA4S5oLCutXmK/30RWJkcfA1U42/ecFuwc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:35:27 +0200
Message-Id: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/22] ide: more work on generic ATAPI support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just some more work on generic ATAPI layer...

- code unifications here and there

- move IDEFLOPPY_IOCTL_FORMAT_* support to a separate file

- ide_pc_intr() no longer requires zillion of arguments

Applies on top of current pata tree, tested with ide-scsi.

diffstat:
 drivers/ide/Makefile           |    3 
 drivers/ide/ide-atapi.c        |  323 +++++++++++++++--
 drivers/ide/ide-floppy.c       |  739 ++++++-----------------------------------
 drivers/ide/ide-floppy.h       |   72 +++
 drivers/ide/ide-floppy_ioctl.c |  245 +++++++++++++
 drivers/ide/ide-tape.c         |  396 ++++++---------------
 drivers/scsi/ide-scsi.c        |  178 ++-------
 include/linux/ide.h            |  266 +++++++++-----
 8 files changed, 1035 insertions(+), 1187 deletions(-)
