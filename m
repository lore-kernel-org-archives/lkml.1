Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZKRJZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZKRJZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZKRJZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:42277 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbZKRJZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:12 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH 11/20] BKL: Remove BKL from exofs
Date: Wed, 18 Nov 2009 10:24:44 +0100
Message-Id: <1258536293-7762-12-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need the BKL in exofs.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/exofs/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 9f500de..11e35b1 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -31,7 +31,6 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/vfs.h>
-- 
1.6.4.2

