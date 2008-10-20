Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYJTSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYJTSCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYJTSCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:02:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36960 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752377AbYJTSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:02:06 -0400
Message-ID: <48FCC7D5.3090802@sgi.com>
Date: Mon, 20 Oct 2008 11:03:01 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
CC: Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: PATCH [1/1] cpumask: remove redundant cpumask_size
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpumask: remove redundant cpumask_size

Not sure how both cpumask_size() functions slipped back in but
remove the macro version.

Depends on struct cpumask patches 1-35.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    2 --
 1 file changed, 2 deletions(-)

--- test-compile.orig/include/linux/cpumask.h
+++ test-compile/include/linux/cpumask.h
@@ -141,8 +141,6 @@ static inline ssize_t cpumask_size(void)
 }
 
 
-#define cpumask_size() (BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long))
-
 /* Deprecated. */
 typedef struct cpumask cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;
