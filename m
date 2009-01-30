Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZA3Xa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZA3Xa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZA3XaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:30:12 -0500
Received: from smtp-out.google.com ([216.239.45.13]:7043 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZA3XaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:30:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:mime-version:content-type:
	content-disposition:x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=uRBEXjq5ROIj85PZ3S4++y8GzXFEARsFQLv4GTbUN9AsLWnPRQ7TNwLGKlR7ySYMY
	HaG+9Ccof0PloiQD97JTg==
Date: Fri, 30 Jan 2009 15:29:54 -0800
From: Mandeep Singh Baines <msb@google.com>
To: mingo@elte.hu, eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: remove unused definition for spawn_softlockup_task
Message-ID: <20090130232954.GA18399@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.77
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of spawn_softlockup_task in sched.h became
unnecessary once it was converted to the early_initcall()
interface.

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 include/linux/sched.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2f94d5..2a2811c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -302,9 +302,6 @@ extern int softlockup_thresh;
 static inline void softlockup_tick(void)
 {
 }
-static inline void spawn_softlockup_task(void)
-{
-}
 static inline void touch_softlockup_watchdog(void)
 {
 }
-- 
1.5.4.5

