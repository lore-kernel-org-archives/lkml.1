Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZEZMTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZEZMTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZEZMTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:19:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:37424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbZEZMTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:19:34 -0400
Date: Tue, 26 May 2009 14:19:35 +0200
From: Michal Marek <mmarek@suse.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] samples: make SAMPLE_KOBJECT module-only
Message-ID: <20090526121935.GA20790@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With SAMPLE_KOBJECT=y, it isn't even linked into the kernel image.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 samples/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 4b02f5a..e00d2e1 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -20,7 +20,8 @@ config SAMPLE_TRACEPOINTS
 	  This build tracepoints example modules.
 
 config SAMPLE_KOBJECT
-	tristate "Build kobject examples"
+	tristate "Build kobject examples -- loadable modules only"
+	depends on m
 	help
 	  This config option will allow you to build a number of
 	  different kobject sample modules showing how to use kobjects,
-- 
1.6.3
