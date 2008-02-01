Return-Path: <linux-kernel-owner+w=401wt.eu-S1765698AbYBAFsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765698AbYBAFsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1749667AbYBAFsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:48:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:12751 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYBAFsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:48:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iIS8RdYwblQmU9TOu7cSBlUtPhtb1uE7f9E+y6pTz9HIg4bjx1RVRbuFPny0kOIdGtl6RmDnAbX0kFuicPPVy/gqmBLOlxFMnRxjLY8JwyM25UMi9lH4gydat4qPKMvO76KTEc5oHQvrKGDqxWmT/Agde5PrwOXuxSl/AiiL3+s=
Subject: [PATCH] feature-removal: Document suspend/hibernate deprecations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 21:48:34 -0800
Message-Id: <1201844914.23523.84.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let this appear as deprecated in 2.6.25, remove after three
releases (2.6.28).

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Something like this should be included if you are deprecating
userspace functionality.  I tried to come up with a useful
reason from your changelogs, but you should fill this in.

 Documentation/feature-removal-schedule.txt |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 181bff0..cb005de 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -354,3 +354,28 @@ Why:	The support code for the old firmware hurts code readability/maintainabilit
 	and slightly hurts runtime performance. Bugfixes for the old firmware
 	are not provided by Broadcom anymore.
 Who:	Michael Buesch <mb@bu3sch.de>
+
+---------------------------
+
+What:	SNAPSHOT_PMOPS ioctl
+When:	2.6.28
+Why:	Badly designed interface, obsoleted by SNAPSHOT_PLATFORM_SUPPORT and
+	SNAPSHOT_POWER_OFF
+Who:	Len Brown <len.brown@intel.com>
+
+---------------------------
+
+What:	SNAPSHOT_SET_SWAP_FILE ioctl
+When:	2.6.28
+Why:	Insert reason here
+Who:	Len Brown <len.brown@intel.com>
+
+---------------------------
+
+What:	SNAPSHOT_ATOMIC_SNAPSHOT, SNAPSHOT_AVAIL_SWAP, SNAPSHOT_GET_SWAP_PAGE ioctls
+When:	2.6.28
+Why:	Defined in a non-portable manner, new numbers introduced, old numbers
+	deprecated.
+Who:	Len Brown <len.brown@intel.com>
+
+---------------------------
-- 
1.5.4.rc4.1142.gf5a97



