Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZCDJRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZCDJRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZCDJRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:17:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:45308 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZCDJRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UB7A5Xa7Uc87Rk9TeJw1adun1E2iVMKkCb2JkcPArKGwn6Lolij1EyWXfEU9eghO2t
         mP5oqBvTgnqkFSiov/KhFkYjmBgs0cFOQIHMbCWbSwpEzopXiYixvQlgMazZfTwmW5i2
         oOt2appBginDWwx1arIV+5VLFvVAdhwlEyg3E=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/3] some ide fixes
Date: Wed,  4 Mar 2009 10:16:53 +0100
Message-Id: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

I've updated the two ide-floppy patches from you to current pata-2.6 and
added the partial completions fix to the second one so that we don't
break bisect builds (although this is hardly unlikely since nobody uses
an ide-floppy anymore). The 3rd patch is the ide-cd fix from linux-next
which has been tested by Tetsuo and me.

 drivers/ide/ide-atapi.c  |  136 +++++++++++++++-------------------------------
 drivers/ide/ide-cd.c     |    4 --
 drivers/ide/ide-floppy.c |   26 ++--------
 drivers/ide/ide-tape.c   |   32 ++++++------
 include/linux/ide.h      |    5 --
 5 files changed, 64 insertions(+), 139 deletions(-)
