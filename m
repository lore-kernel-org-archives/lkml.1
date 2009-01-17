Return-Path: <linux-kernel-owner+w=401wt.eu-S934202AbZAQCi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbZAQCi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbZAQCiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:38:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33844 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbZAQCiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:38:15 -0500
Date: Sat, 17 Jan 2009 02:38:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] misc: dell-laptop should depend on POWER_SUPPLY
Message-ID: <20090117023804.GA2291@srcf.ucam.org>
References: <20090113202012.GA9522@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113202012.GA9522@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dell-laptop makes use of the power supply class information to choose 
which backlight interface to change. Add a depends on it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 419c378..03de0a2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -225,6 +225,7 @@ config DELL_LAPTOP
 	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
+	depends on POWER_SUPPLY
 	default n
 	---help---
 	This driver adds support for rfkill and backlight control to Dell

-- 
Matthew Garrett | mjg59@srcf.ucam.org
