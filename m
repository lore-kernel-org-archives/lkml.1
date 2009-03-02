Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbZCBRzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbZCBRzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZCBRz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:55:27 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:24158 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZCBRz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:55:26 -0500
Message-ID: <49AC1D71.4050303@oracle.com>
Date: Mon, 02 Mar 2009 09:54:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: [PATCH] staging/line6: depends on SND
References: <20090302182217.90ca3356.sfr@canb.auug.org.au>
In-Reply-To: <20090302182217.90ca3356.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49AC1D82.02D4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

line6 code has lots of dependencies on ALSA (and build errors),
so express that in Kconfig.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/line6/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090302.orig/drivers/staging/line6/Kconfig
+++ linux-next-20090302/drivers/staging/line6/Kconfig
@@ -1,6 +1,6 @@
 config LINE6_USB
 	tristate "Line6 USB support"
-	depends on USB
+	depends on USB && SND
 	help
 	  This is a driver for the guitar amp, cab, and effects modeller
 	  PODxt Pro by Line6 (and similar devices), supporting the
