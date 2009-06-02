Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZFBOiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZFBOiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZFBOhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:37:08 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:55988
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755001AbZFBOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:37:07 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KKM8LB-04-0I2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org
Subject: [PATCH 0/4] dma-debug: driver filter v2
Date: Tue, 2 Jun 2009 16:36:40 +0200
Message-ID: <1243953404-31799-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 02 Jun 2009 14:36:48.0016 (UTC) FILETIME=[8F437100:01C9E38F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small patchset adds a new feature to dma-api debugging: a driver
filter. A driver developer can write the name of his driver to
dma-api/driver_filter and the kernel will then only print errors
produced by this driver. This is useful if other drivers in the system
also have bugs. In this case the driver developer can limit the bug
output to messages interesting for him.

	Joerg

Changes since v1:

	- addressed Andrews comments (used string functions were
	  appropriate and reduced inlining, added some more
	  comments)

diffstat:

 Documentation/DMA-API.txt           |   12 +++
 Documentation/kernel-parameters.txt |    7 ++
 lib/dma-debug.c                     |  167 ++++++++++++++++++++++++++++++++++-
 3 files changed, 185 insertions(+), 1 deletions(-)

shortlog:

Joerg Roedel (4):
      dma-debug: add variables and checks for driver filter
      dma-debug: add debugfs file for driver filter
      dma-debug: add dma_debug_driver kernel command line
      dma-debug: add documentation for the driver filter


