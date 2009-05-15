Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbZEOI2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbZEOI2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZEOI2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:28:30 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:59468 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904AbZEOI23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:28:29 -0400
To: Netdev <netdev@vger.kernel.org>
Subject: [PATCH] ipv4: make default for INET_LRO consistent with help text
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Fri, 15 May 2009 10:28:26 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200905151028.28833.elendil@planet.nl>
X-OriginalArrivalTime: 15 May 2009 08:28:29.0887 (UTC) FILETIME=[20510CF0:01C9D537]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e81963b1 changed this config from tristate to bool.
Add default so that it is consistent with the help text.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 9d26a3d..5b919f7 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -408,7 +408,7 @@ config INET_XFRM_MODE_BEET
 
 config INET_LRO
 	bool "Large Receive Offload (ipv4/tcp)"
-
+	default y
 	---help---
 	  Support for Large Receive Offload (ipv4/tcp).
 
