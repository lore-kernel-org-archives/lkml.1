Return-Path: <linux-kernel-owner+w=401wt.eu-S1423310AbXD3OgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423310AbXD3OgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423304AbXD3Ofh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:35:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423310AbXD3Oe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:34:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=Y7HTYVpq3tebGZZdJUkulYEdEEPQG4q2e4MD5aJ6W1aHHfFKgm6k6BWdvQzq8K7Qg
	Z+4tWZdGTjZLsTMYLAJ3Q==
Date: Mon, 30 Apr 2007 07:34:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Brownell <dbrownell@users.sourceforge.net>
cc: linux-kernel@vger.kernel.org
Subject: [patch] pm: include EIO from errno-base.h
Message-ID: <Pine.LNX.4.64.0704291700220.1822@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

call_platform_enable_wakeup() uses EIO, so it needs to be defined.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/pm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -25,6 +25,7 @@
 
 #include <linux/list.h>
 #include <asm/atomic.h>
+#include <asm/errno.h>
 
 /*
  * Power management requests... these are passed to pm_send_all() and friends.
