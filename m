Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXHIHXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXHIHXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934389AbXHIHXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:23:12 -0400
Received: from mail.linux-boards.com ([192.114.83.142]:59755 "EHLO
	mail.linux-boards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbXHIHXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:23:11 -0400
Message-ID: <46BABF62.2010904@compulab.co.il>
Date: Thu, 09 Aug 2007 10:16:50 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.4 (X11/20070715)
MIME-Version: 1.0
To: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATHC] make power supply class available for arm architecture
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The config system doesn't show the power supply class menu if arch=arm, this 
patch fixes it.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d614529..9f7c6de 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1026,6 +1026,8 @@ source "drivers/spi/Kconfig"

  source "drivers/w1/Kconfig"

+source "drivers/power/Kconfig"
+
  source "drivers/hwmon/Kconfig"

  #source "drivers/l3/Kconfig"

