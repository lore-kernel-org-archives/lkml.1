Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZKMSAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZKMSAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbZKMSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:00:12 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:39496 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZKMSAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:00:11 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: "David S. Miller" <davem@redhat.com>
Subject: [PATCH]remove deprecated and not used: print_mac()
Date: Fri, 13 Nov 2009 19:58:41 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc7; KDE/4.2.4; x86_64; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911131958.42263.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The function print_mac in net/ethernet/eth.c is marked __deprecated
and not used. Remove it.

The patch is against 2.6.32-rc7.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

=====================================================================
--- a/include/linux/if_ether.h	2009-11-13 19:16:15.000000000 +0200
+++ b/include/linux/if_ether.h	2009-11-13 19:18:25.000000000 +0200
@@ -136,10 +136,6 @@
 
 extern ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int len);
 
-/*
- *	Display a 6 byte device address (MAC) in a readable format.
- */
-extern char *print_mac(char *buf, const unsigned char *addr) __deprecated;
 #define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
 #define MAC_BUF_SIZE	18
 #define DECLARE_MAC_BUF(var) char var[MAC_BUF_SIZE]

--- a/net/ethernet/eth.c	2009-11-13 19:16:30.000000000 +0200
+++ b/net/ethernet/eth.c	2009-11-13 19:20:31.000000000 +0200
@@ -393,10 +393,3 @@
 	return ((ssize_t) l);
 }
 EXPORT_SYMBOL(sysfs_format_mac);
-
-char *print_mac(char *buf, const unsigned char *addr)
-{
-	_format_mac_addr(buf, MAC_BUF_SIZE, addr, ETH_ALEN);
-	return buf;
-}
-EXPORT_SYMBOL(print_mac);
