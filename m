Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZAGPbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZAGPbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbZAGPbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:31:25 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:42825 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898AbZAGPbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:31:24 -0500
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 10:31:24 EST
Date: Wed, 7 Jan 2009 15:20:35 +0000
From: Andrew Price <andy@andrewprice.me.uk>
To: linux-kernel@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] Cleanup: Remove zero-sized file (clock.h)
Message-ID: <20090107152035.GA19289@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-integrator/clock.h was not removed properly and was left
zero-sized so it was being removed by 'make distclean', leaving an
uncommitted change. This removes it.

Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 arch/arm/mach-integrator/clock.h

diff --git a/arch/arm/mach-integrator/clock.h b/arch/arm/mach-integrator/clock.h
deleted file mode 100644
index e69de29..0000000
-- 
1.5.6.5

