Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYF0Lk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYF0Lk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYF0LkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:40:20 -0400
Received: from saeurebad.de ([85.214.36.134]:38713 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYF0LkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:40:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mmotm] fix double export of kobject_rename
CC: linux-kernel@vger.kernel.org
Date: Fri, 27 Jun 2008 13:39:47 +0200
Message-ID: <87wskbxg1o.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably a merging error, line comes from the merge with -next.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/lib/kobject.c b/lib/kobject.c
index 8761ef6..abfb1e2 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -540,7 +540,6 @@ out:
 	kfree(devpath);
 	return error;
 }
-EXPORT_SYMBOL_GPL(kobject_rename);
 
 /**
  * kobject_del - unlink kobject from hierarchy.
