Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXIMPjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXIMPjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbXIMPi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:38:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbXIMPi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:38:59 -0400
Date: Thu, 13 Sep 2007 11:38:51 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Cc: csnook@redhat.com
Subject: [PATCH] x86_64: make atomic64_t semantics consistent with atomic_t
Message-ID: <20070913153851.GA26246@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

The volatile keyword has already been removed from the declaration of atomic_t
on x86_64.  For consistency, remove it from atomic64_t as well.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- a/include/asm-x86_64/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ b/include/asm-x86_64/atomic.h	2007-09-13 11:30:51.000000000 -0400
@@ -206,7 +206,7 @@ static __inline__ int atomic_sub_return(
 
 /* An 64bit atomic type */
 
-typedef struct { volatile long counter; } atomic64_t;
+typedef struct { long counter; } atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
