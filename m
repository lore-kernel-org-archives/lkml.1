Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZE1PUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZE1PUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZE1PUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:20:41 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3200 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZE1PUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:20:40 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KKD19Y-02-Y9C-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dma-debug: driver filter
Date: Thu, 28 May 2009 17:19:27 +0200
Message-ID: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 28 May 2009 15:19:34.0357 (UTC) FILETIME=[B4DB4050:01C9DFA7]
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

diffstat:

 Documentation/DMA-API.txt |   11 +++
 lib/dma-debug.c           |  157 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 167 insertions(+), 1 deletions(-)

shortlog:

Joerg Roedel (4):
      dma-debug: add variables and checks for driver filter
      dma-debug: add debugfs file for driver filter
      dma-debug: add dma_debug_driver kernel command line
      dma-debug: add documentation for the driver filter


