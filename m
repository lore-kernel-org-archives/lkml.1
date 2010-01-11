Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390Ab0AKUwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0AKUwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321Ab0AKUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:06 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51440 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab0AKUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=qaXj2V9HMSGl5pzOE51eGhvgN6D53HCRH0Xb9DyWdLaQ9d9CaqpJxTL82/PT+5JjjQ
         p8Q7jKgfjgr2kRp9dYD3QzF4z9VgWU7W0bYzptePVfEojo0YYcWWjMOBkoo04kjVMvZR
         RpLo0DAlkFtz66QbGo4Pjn8ECZ0T9beUGJKfs=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 00/15] Staging: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:39 +0100
Message-Id: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas / Ingo / Greg

I started with the patch in -rt 041e3130496f31d0cb4887fc6183117e662f5141
and tried to forward port it to 2.6.33-rc3

The patch no-longer applied, because some of the changes were already accepted
upstream, some files had been moved or dropped and so on.

So, I broke the original patch into one patch per file, and fixed merge errors.
Then I also went and changed similar problems in new code

This code should be queued-up for the 2.6.34 merge window, and should also
be applied to the latests -rt branch.

John Kacur (6):
  mt9d112: Convert the semaphore mess.
  mt9p012_fox: Convert the semaphore mess
  mt9t013: Convert the semaphore mess
  s5k3e2fx: Convert the semaphore mess
  pmem: Convert the semaphore mess.
  vme_user: Convert the semaphore mess

Thomas Gleixner (9):
  dt9812: Convert the semaphore mess
  usbdux.c: Convert the semaphore mess
  usbduxfast: Convert the semaphore mess
  alphatrack: Convert the semaphore mess
  tranzport: Convert he semaphore mess
  mimio: Convert semaphore mess
  wwrap: Convert the semaphore mess
  p9auth: Convert the semaphore mess
  rtmp_init: Convert the semaphore mess.

 drivers/staging/comedi/drivers/dt9812.c     |    4 ++--
 drivers/staging/comedi/drivers/usbdux.c     |    4 ++--
 drivers/staging/comedi/drivers/usbduxfast.c |    4 ++--
 drivers/staging/dream/camera/mt9d112.c      |    2 +-
 drivers/staging/dream/camera/mt9p012_fox.c  |    2 +-
 drivers/staging/dream/camera/mt9t013.c      |    2 +-
 drivers/staging/dream/camera/s5k3e2fx.c     |    2 +-
 drivers/staging/dream/pmem.c                |    2 +-
 drivers/staging/frontier/alphatrack.c       |    2 +-
 drivers/staging/frontier/tranzport.c        |    4 ++--
 drivers/staging/mimio/mimio.c               |    2 +-
 drivers/staging/otus/wwrap.c                |    2 +-
 drivers/staging/p9auth/p9auth.c             |    2 +-
 drivers/staging/rt2860/common/rtmp_init.c   |    2 +-
 drivers/staging/vme/devices/vme_user.c      |    2 +-
 15 files changed, 19 insertions(+), 19 deletions(-)

