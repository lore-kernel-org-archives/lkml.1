Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbYBKIf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbYBKIf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYBKIfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:35:06 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:53103 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYBKIfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=LeqyqJR5X6csOXAVmfM0xmDWh6xWcRAVOQNsOxmK33E4NnV0qnXNA3txFJp7gRiDYGCQsFJlQ/ZLGcx/9DGJHAoLBvvf81B4HnZjYtbWfQhdETcWpBp6QcvwQtteptjgnvC2EjnKT9uenyXnQ23S2PhfCnjo0BH1+QhaLmEbSQk=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/4] ide: generic packet command representation
Date: Mon, 11 Feb 2008 09:34:36 +0100
Message-Id: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's the ide_atapi_pc unification series. It all went pretty smoothly along
the search & replace line. Using driver-specific members in ide_atapi_pc like
idefloppy_callback and idetape_callback is kinda dumb but this approach seemed
the fastest versus unnecessary callback function signature change that will
touch stuff all over the place. Besides, ide-tape might be gone soon so that
would alleviate the problem.

On a different note, i noticed ide-scsi might also need a cleanup similar to the
other drivers. It is next on my TODO list in case you don't have anything with a
higher prio.


 drivers/ide/ide-floppy.c |  205 +++++++++++++++++--------------------
 drivers/ide/ide-tape.c   |  251 +++++++++++++++++++++-------------------------
 drivers/scsi/ide-scsi.c  |  133 +++++++++++-------------
 include/linux/ide.h      |   47 +++++++++
 4 files changed, 316 insertions(+), 320 deletions(-)

-- 
Thanks,
Boris.
