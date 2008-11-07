Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYKGPOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYKGPOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYKGPOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:14:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYKGPOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:14:01 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 1/5] Capabilities: document the order of arguments to
	cap_issubset
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: sgrubb@redhat.com, morgan@kernel.org, serue@us.ibm.com,
       viro@ZenIV.linux.org.uk
Date: Fri, 07 Nov 2008 10:13:55 -0500
Message-ID: <20081107151355.9977.47852.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the order of arguments for cap_issubset.  It's not instantly clear
which order the argument should be in.  So give an example.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/capability.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 9d1fe30..9f44150 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -454,6 +454,13 @@ static inline int cap_isclear(const kernel_cap_t a)
 	return 1;
 }
 
+/*
+ * Check if "a" is a subset of "set".
+ * return 1 if ALL of the capabilities in "a" are also in "set"
+ *	cap_issubset(0101, 1111) will return 1
+ * return 0 if ANY of the capabilities in "a" are not in "set"
+ *	cap_issubset(1111, 0101) will return 0
+ */
 static inline int cap_issubset(const kernel_cap_t a, const kernel_cap_t set)
 {
 	kernel_cap_t dest;

