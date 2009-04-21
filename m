Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZDUWao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZDUWao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDUWaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:30:35 -0400
Received: from vena.lwn.net ([206.168.112.25]:38262 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZDUWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:30:34 -0400
Date: Tue, 21 Apr 2009 16:30:32 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Trivial: fix a typo in slow-work.h
Message-ID: <20090421163032.21ec2b34@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a comment typo in slow-work.h

...a trivial mistake, but it will mess up kerneldoc if nothing else.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 include/linux/slow-work.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index 8595827..b65c888 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -67,7 +67,7 @@ static inline void slow_work_init(struct slow_work *work,
 }
 
 /**
- * slow_work_init - Initialise a very slow work item
+ * vslow_work_init - Initialise a very slow work item
  * @work: The work item to initialise
  * @ops: The operations to use to handle the slow work item
  *
-- 
1.6.2.2

