Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZK1IvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZK1IvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 03:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZK1IvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 03:51:12 -0500
Received: from iksaif.net ([88.191.73.63]:47243 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZK1IvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 03:51:11 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Brian Swetland <swetland@google.com>,
       Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 0/2] staging/android fixes
Date: Sat, 28 Nov 2009 09:45:13 +0100
Message-Id: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is a patch to fix build for android specifics drivers.

What we should do next to prevent them from being removed in 2.6.23 ?

Is there any chance that all android stuff would be merged one day ?
Actually, we got a working 2.6.32 kernel for android here (with wakelock, ashm, etc..):
http://git.iksaif.net/?p=android-x86/kernel;a=shortlog;h=refs/heads/android-x86-backport

Thanks,

Corentin Chary (2):
  staging/android: fix build issues
  staging/android: remove BROKEN flag

 drivers/staging/android/Kconfig           |    1 -
 drivers/staging/android/logger.c          |    1 +
 drivers/staging/android/lowmemorykiller.c |    6 ++++--
 3 files changed, 5 insertions(+), 3 deletions(-)

