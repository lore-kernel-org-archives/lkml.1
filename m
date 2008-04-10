Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbYDJMig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbYDJMig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYDJMhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:37:25 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:51209 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755490AbYDJMhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:37:21 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-29.messagelabs.com!1207831038!10511181!9
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] UIO: fixes, cleanups and a new driver
Date: Thu, 10 Apr 2008 14:36:59 +0200
Message-Id: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.5
X-OriginalArrivalTime: 10 Apr 2008 12:37:03.0467 (UTC) FILETIME=[9444C3B0:01C89B07]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15840.007
X-TM-AS-Result: No--5.931400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in this series you can find a generic platform_device driver for UIO and
a few cleanups and fixes to the existing UIO code.  The first patch fixes a
possible Oops.

Below you can find shortlog and diffstat.

I appreciate any (constructive) feedback.

Best regards
Uwe

Uwe Kleine-König (4):
      UIO: hold a reference to the device's owner while the device is open
      UIO: use menuconfig
      UIO: wrap all uio drivers in "if UIO" and "endif"
      [RFC] UIO: generic platform driver

 drivers/uio/Kconfig    |   19 ++++--
 drivers/uio/Makefile   |    1 +
 drivers/uio/uio.c      |   40 +++++++-----
 drivers/uio/uio_pdrv.c |  165 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 202 insertions(+), 23 deletions(-)
