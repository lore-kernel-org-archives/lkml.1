Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbZIDIGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbZIDIGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbZIDIGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:06:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32732 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbZIDIGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:06:10 -0400
Message-Id: <4AA0E69202000078000136EC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 04 Sep 2009 09:06:10 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <rui.zhang@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] thermal: add missing Kconfig dependency
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise THERMAL_HWMON can be selected when HWMON=n and THERMAL=n,
which fails to build.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/thermal/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.31-rc8/drivers/thermal/Kconfig	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.31-rc8-thermal-dependency/drivers/thermal/Kconfig	2009-09-02 12:13:01.000000000 +0200
@@ -15,6 +15,7 @@ menuconfig THERMAL
 
 config THERMAL_HWMON
 	bool "Hardware monitoring support"
+	depends on THERMAL
 	depends on HWMON=y || HWMON=THERMAL
 	help
 	  The generic thermal sysfs driver's hardware monitoring support



