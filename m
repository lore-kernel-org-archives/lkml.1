Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYJ2XEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYJ2XEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbYJ2XDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:03:06 -0400
Received: from kroah.org ([198.145.64.141]:35898 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756608AbYJ2XDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:03:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/6] Update stable tree documentation
Date: Wed, 29 Oct 2008 15:58:10 -0700
Message-Id: <1225321092-21933-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223824.GB21657@kroah.com>
References: <20081029223824.GB21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@linux.vnet.ibm.com>

Update the documentation for the stable tree rules to reflect
that device IDs and quirks are also suitable for -stable
kernels.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/stable_kernel_rules.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index 4cfc788..a452227 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -12,6 +12,7 @@ Rules on what kind of patches are accepted, and which ones are not, into the
    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
    security issue, or some "oh, that's not good" issue.  In short, something
    critical.
+ - New device IDs and quirks are also accepted.
  - No "theoretical race condition" issues, unless an explanation of how the
    race can be exploited is also provided.
  - It cannot contain any "trivial" fixes in it (spelling changes,
-- 
1.6.0.2

