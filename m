Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZDUBnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZDUBnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZDUBnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:43:13 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:50425 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZDUBnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:43:12 -0400
Date: Mon, 20 Apr 2009 18:43:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Henrik Austad <henrik@austad.us>
Subject: [PATCH] Doc: hrtimers.txt was moved a long time ago, update
 reference
Message-Id: <20090420184330.34f8d129.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49ED248F.006A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <henrik@austad.us>
Subject: Doc: hrtimers.txt was moved a long time ago, update reference

In 3833eecc183ce052e9ac96b39b45121a2d11ac16 hrtimers.txt was moved from
Documentation/hrtimers into Documentation/timers in order to keep all
timer-related together. The reference to hrtimers in highres.txt was not updated 
however, and still pointed to the old directory.

Signed-off-by: Henrik Austad <henrik@austad.us>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/timers/highres.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/timers/highres.txt b/Documentation/timers/highres.txt
index 2133223..e878997 100644
--- a/Documentation/timers/highres.txt
+++ b/Documentation/timers/highres.txt
@@ -30,7 +30,7 @@ hrtimer base infrastructure
 ---------------------------
 
 The hrtimer base infrastructure was merged into the 2.6.16 kernel. Details of
-the base implementation are covered in Documentation/hrtimers/hrtimer.txt. See
+the base implementation are covered in Documentation/timers/hrtimers.txt. See
 also figure #2 (OLS slides p. 15)
 
 The main differences to the timer wheel, which holds the armed timer_list type
-- 
