Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbZFSBVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbZFSBVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZFSBVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:21:40 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:40274 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZFSBVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:21:40 -0400
Date: Thu, 18 Jun 2009 21:21:22 -0400
To: mingo@elte.hu, tglx@linutronix.de, williams@redhat.com, jcm@redhat.com,
       jcm@jonmasters.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: [PULL] hardware latency detector
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1MHSnC-0006bC-OW@tonnant>
From: Jon Masters <jcm@jonmasters.org>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull "hwlat", the hardware latency detector for 2.6.31.

Patches can be pulled from:

  git://git.kernel.org/pub/scm/linux/kernel/git/jcm/linux-2.6-hwlat.git for-linus

Jon Masters (2):
      hwlat_detector: A system hardware latency detector
      hwlat_detector: include linux/delay.h in hwlat_detector

 Documentation/hwlat_detector.txt |   64 ++
 MAINTAINERS                      |    9 +
 drivers/misc/Kconfig             |   28 +
 drivers/misc/Makefile            |    1 +
 drivers/misc/hwlat_detector.c    | 1208 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 1310 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwlat_detector.txt
 create mode 100644 drivers/misc/hwlat_detector.c
