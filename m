Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZL1Qr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZL1Qr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZL1Qrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:47:55 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:51871 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750963AbZL1Qry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:47:54 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
Date: Mon, 28 Dec 2009 11:47:51 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F464@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
Thread-Index: AcqH3X5Tr6v9MJbYRC+nusqZvudHVw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 16:47:51.0580 (UTC) FILETIME=[7EA5D5C0:01CA87DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'ic_dev_xid' should be static since it is not exported.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 10a6a60..0a788bf 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -139,7 +139,7 @@ __be32 ic_servaddr = NONE;	/* Boot server IP address */
 __be32 root_server_addr = NONE;	/* Address of NFS server */
 u8 root_server_path[256] = { 0, };	/* Path to mount as root */
 
-u32 ic_dev_xid;		/* Device under configuration */
+static u32 ic_dev_xid;		/* Device under configuration */
 
 /* vendor class identifier */
 static char vendor_class_identifier[253] __initdata; 
