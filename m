Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbZEIDal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbZEIDal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbZEID3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:29:11 -0400
Received: from kroah.org ([198.145.64.141]:41362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbZEID3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:29:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] Remove old PRINTK_DEBUG config item
Date: Fri,  8 May 2009 20:25:57 -0700
Message-Id: <1241839559-9157-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032432.GA9000@kroah.com>
References: <20090509032432.GA9000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

On Tue, Apr 21, 2009 at 01:55:53PM +0200, Stefan Richter wrote:
> Robert P. J. Day wrote:
> >   lib/Kconfig.debug:      select PRINTK_DEBUG
> >
> > should that perhaps refer to "DYNAMIC_PRINTK_DEBUG"?  since there is
> > no such thing as a PRINTK_DEBUG Kconfig variable.
>
> Looks like a rudiment from an earlier version of Jason's "driver core:
> basic infrastructure for per-module dynamic debug messages",
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=346e15beb5343c2eb8216d820f2ed8f150822b08
> Search an LKML archive for '+#ifdef CONFIG_PRINTK_DEBUG'.
>
> Jason, should it be deleted or replaced by something?

We re-named 'DYNAMIC_PRINTK_DEBUG' to 'DYNAMIC_DEBUG' in 2.6.30....
'PRINTK_DEBUG' as pointed out never existed. So, it appears to be
extraneous, and should be removed. thanks for pointing it out.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/Kconfig.debug |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 812c282..6cdcf38 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -891,7 +891,6 @@ config DYNAMIC_DEBUG
 	default n
 	depends on PRINTK
 	depends on DEBUG_FS
-	select PRINTK_DEBUG
 	help
 
 	  Compiles debug level messages into the kernel, which would not
-- 
1.6.3

