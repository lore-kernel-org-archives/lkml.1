Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0CEJyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:54:47 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:41459 "EHLO
	mail.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0CEJyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:54:45 -0500
X-Greylist: delayed 2008 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 04:54:45 EST
From: Jiri Slaby <jslaby@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Johannes Sixt <j.sixt@viscovery.net>
Subject: [PATCH 1/1] gitignore: do not ignore include/linux/
Date: Fri,  5 Mar 2010 10:20:45 +0100
Message-Id: <1267780845-10547-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <4B90CBE5.9090102@viscovery.net>
References: <4B90CBE5.9090102@viscovery.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux entry in .gitignore means that everything in include/linux/
gets ignored with git 1.7.

Prepend a slash to entries which are toplevel to avoid that

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Johannes Sixt <j.sixt@viscovery.net>
---
 .gitignore |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/.gitignore b/.gitignore
index efab0eb..fe6ebb9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -34,16 +34,16 @@ modules.builtin
 #
 # Top-level generic files
 #
-tags
-TAGS
-linux
-vmlinux
-vmlinuz
-System.map
-Module.markers
-Module.symvers
-!.gitignore
-!.mailmap
+/tags
+/TAGS
+/linux
+/vmlinux
+/vmlinuz
+/System.map
+/Module.markers
+/Module.symvers
+!/.gitignore
+!/.mailmap
 
 #
 # Generated include files
-- 
1.7.0.1


