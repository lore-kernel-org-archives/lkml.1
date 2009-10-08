Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbZJHJWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbZJHJWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZJHJWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:22:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:56693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983AbZJHJWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:22:35 -0400
Message-ID: <4ACDAF18.2030705@kernel.org>
Date: Thu, 08 Oct 2009 18:21:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH suspend-2.6#linux-next] PM / freezer: add missing include
References: <20091008153051.37f043fa.sfr@canb.auug.org.au>
In-Reply-To: <20091008153051.37f043fa.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 09:21:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile failure caused by a48145a7cbf3b0555ba3ad61aaf2c38719bab95d
forgetting to include delay.h.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/power/process.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 66161f0..5ade1bd 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/delay.h>
 
 /* 
  * Timeout for stopping processes
