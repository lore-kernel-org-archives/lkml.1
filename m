Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbZCBLlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbZCBLlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 06:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZCBLlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 06:41:08 -0500
Received: from cathcart.site5.com ([74.54.107.137]:56352 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZCBLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 06:41:07 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: alessandro.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, raph@8d.com,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] rtc-v3020: add ability to access v3020 chip with GPIOs 
Date: Mon,  2 Mar 2009 13:40:55 +0200
Message-Id: <cover.1235400430.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The v3020 RTC can be connected to GPIOs as well as to memory-like interface.
Add ability to use GPIO bit-bang for v3020 read-write access.

The first patch in the serie is just coding style cleanup.

Mike Rapoport (2):
  rtc-v3020: coding style cleanup
  rtc-v3020: add ability to access v3020 chip with GPIOs

 drivers/rtc/rtc-v3020.c   |  230 ++++++++++++++++++++++++++++++++++++--------
 include/linux/rtc-v3020.h |    6 +
 2 files changed, 194 insertions(+), 42 deletions(-)

