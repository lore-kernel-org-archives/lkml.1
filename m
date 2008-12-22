Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYLVV4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYLVV4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbYLVVtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:20 -0500
Received: from mx1.suse.de ([195.135.220.2]:41619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbYLVVtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:18 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 19/56] mm: Export pdflush_operation()
Date: Mon, 22 Dec 2008 13:48:00 -0800
Message-Id: <1229982517-3455-20-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

OCSF2 will need to queue up work for periodic syncing of quotas
among nodes in the cluster. pdflush() is good thread for this so
export it's controlling function so that OCFS2 can use it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 mm/pdflush.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/pdflush.c b/mm/pdflush.c
index a0a14c4..13af84d 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -223,6 +223,7 @@ int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
 
 	return ret;
 }
+EXPORT_SYMBOL(pdflush_operation);
 
 static void start_one_pdflush_thread(void)
 {
-- 
1.5.6

