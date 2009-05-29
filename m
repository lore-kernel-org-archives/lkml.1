Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbZE2Sen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbZE2Sen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZE2Sec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:34:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:64741 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZE2Seb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:34:31 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 0/2] more usb sysrq improvements
Date: Fri, 29 May 2009 13:34:15 -0500
Message-Id: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 29 May 2009 18:36:23.0968 (UTC) FILETIME=[5E58A200:01C9E08C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is to add sysrq support for the pl2303 usb device
and to stop sysrq processing on non-console usb serial ports.

Thanks,
Jason.


The short log and git info is below, which is against the 2.6.30
development tree with the previous 4 accepted usb patches in the
gregkh queue.

The following changes since commit a425a638c858fd10370b573bde81df3ba500e271:
are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh_2

Jason Wessel (2):
      pl2303 usb_serial: implement sysrq handling on break
      usb_serial: only allow sysrq on a console port

 drivers/usb/serial/generic.c |    2 +-
 drivers/usb/serial/pl2303.c  |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)
