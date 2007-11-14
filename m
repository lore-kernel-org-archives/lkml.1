Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbXKNLmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbXKNLmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbXKNLmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:42:01 -0500
Received: from sacred.ru ([62.205.161.221]:44314 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbXKNLl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:41:58 -0500
Message-ID: <473ADEDA.8060706@openvz.org>
Date: Wed, 14 Nov 2007 14:41:14 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] Mark NET_NS with "depends on NAMESPACES"
References: <473ADB5B.50902@openvz.org>
In-Reply-To: <473ADB5B.50902@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 14 Nov 2007 14:41:16 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's already an option controlling the net namespaces
cloning code, so make it work the same way as all the
other namespaces' options.

Should I wait till the option itself gets to mainline and
resend this patch to David?

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/net/Kconfig b/net/Kconfig
index ab4e6da..d61a025 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -30,7 +30,7 @@ menu "Networking options"
 config NET_NS
 	bool "Network namespace support"
 	default n
-	depends on EXPERIMENTAL && !SYSFS
+	depends on EXPERIMENTAL && !SYSFS && NAMESPACES
 	help
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
