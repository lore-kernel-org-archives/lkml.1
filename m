Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab0CMLSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:18:11 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55374 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759028Ab0CMLSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:18:06 -0500
Date: Sat, 13 Mar 2010 12:17:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>, Greg KH <greg@kroah.com>
Subject: staging/dream: fix gpio_input compilation
Message-ID: <20100313111759.GA2317@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


gpio_* drivers still need drivers in staging. Yes, that will need to
be fixed, but at least fix compilation for now.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/Makefile b/drivers/staging/dream/Makefile
index 2b79151..43d1eec 100644
--- a/drivers/staging/dream/Makefile
+++ b/drivers/staging/dream/Makefile
@@ -1,3 +1,4 @@
+EXTRA_CFLAGS=-Idrivers/staging/dream/include
 obj-$(CONFIG_MSM_ADSP)		+= qdsp5/ smd/
 obj-$(CONFIG_MSM_CAMERA)	+= camera/
 obj-$(CONFIG_INPUT_GPIO)	+= gpio_axis.o gpio_event.o gpio_input.o gpio_matrix.o gpio_output.o


