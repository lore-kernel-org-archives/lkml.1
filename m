Return-Path: <linux-kernel-owner+w=401wt.eu-S933518AbZAQClh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbZAQClh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbZAQCl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:41:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34714 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788AbZAQCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:41:26 -0500
Date: Sat, 17 Jan 2009 02:41:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] platform/x86: eeepc-laptop uses INPUT
Message-ID: <20090117024119.GB2291@srcf.ucam.org>
References: <20090114162502.GA20451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114162502.GA20451@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc-laptop uses the input layer, so needs to depend on it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Ugh. The drivers in here seem to use a mixture of select and depends - 
I've just followed what was already being used, but have no idea what 
the convention really is here.

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index e65448e..d4908e0 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -281,6 +281,7 @@ config EEEPC_LAPTOP
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select RFKILL
+	select INPUT
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
