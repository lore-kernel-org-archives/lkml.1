Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbXGFT7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbXGFT7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbXGFT67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:58:59 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:38521 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762233AbXGFT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:58:58 -0400
Date: Fri, 6 Jul 2007 21:58:53 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH v2 3/5] uvesafb: change connector's max message size
Message-ID: <20070706195853.GB12096@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070630163332.GD3838@spock.one.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070630163332.GD3838@spock.one.pl>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the maximum message size to 16k to allow transfers of VBE
data blocks from userspace.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
This patch increases the limit to 16k since the previous value (4k)
proved to be insufficient for the hardware state buffer on some
video cards.

 include/linux/connector.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/connector.h b/include/linux/connector.h
index 14cecaf..12e3140 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -44,7 +44,7 @@
 /*
  * Maximum connector's message size.
  */
-#define CONNECTOR_MAX_MSG_SIZE 	1024
+#define CONNECTOR_MAX_MSG_SIZE		16384
 
 /*
  * idx and val are unique identifiers which 

