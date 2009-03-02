Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZCBXLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZCBXLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbZCBXKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:10:45 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:2969 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbZCBXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:10:44 -0500
Message-ID: <49AC6771.2030106@cybernetics.com>
Date: Mon, 02 Mar 2009 18:10:41 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] epoll: use real type instead of void *
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventpoll.c uses void * in one place for no obvious reason; change
it to use the real type instead.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
---
--- a/fs/eventpoll.c	2009-02-23 13:32:00.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 13:32:57.000000000 -0500
@@ -192,7 +192,7 @@ struct eppoll_entry {
 	struct list_head llink;
 
 	/* The "base" pointer is set to the container "struct epitem" */
-	void *base;
+	struct epitem *base;
 
 	/*
 	 * Wait queue item that will be linked to the target file wait




