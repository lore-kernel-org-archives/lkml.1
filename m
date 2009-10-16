Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZJPXaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZJPXaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 19:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZJPX37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 19:29:59 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:33587 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750791AbZJPX36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 19:29:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
Date: Fri, 16 Oct 2009 19:30:02 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901E24569@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
Thread-Index: AcpOuJVzeqf1wPKzSKucILSbPTTr5g==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Oct 2009 23:30:02.0653 (UTC) FILETIME=[95BB9CD0:01CA4EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol ic_dev_xid is only used locally to track the device being
configured.  As such, it should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index f8d04c2..374148c 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -139,7 +139,7 @@ __be32 ic_servaddr = NONE;	/* Boot server IP address */
 __be32 root_server_addr = NONE;	/* Address of NFS server */
 u8 root_server_path[256] = { 0, };	/* Path to mount as root */
 
-u32 ic_dev_xid;		/* Device under configuration */
+static u32 ic_dev_xid;		/* Device under configuration */
 
 /* vendor class identifier */
 static char vendor_class_identifier[253] __initdata; 
