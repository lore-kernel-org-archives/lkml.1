Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbXCTSKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbXCTSKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXCTSKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:10:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:31856 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbXCTSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:10:34 -0400
Date: Tue, 20 Mar 2007 11:09:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com
Subject: [PATCH] utrace: make an inline void
Message-Id: <20070320110926.e2f51054.randy.dunlap@oracle.com>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 20:56:23 -0800 Andrew Morton wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/


From: Randy Dunlap <randy.dunlap@oracle.com>

Avoid multiple/repeated warnings:
include/linux/utrace.h:594: warning: return type defaults to 'int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/utrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21-rc4-mm1.orig/include/linux/utrace.h
+++ linux-2.6.21-rc4-mm1/include/linux/utrace.h
@@ -590,7 +590,7 @@ static inline void utrace_report_death(s
 {
 	BUG();
 }
-static inline utrace_report_delayed_group_leader(struct task_struct *tsk)
+static inline void utrace_report_delayed_group_leader(struct task_struct *tsk)
 {
 	BUG();
 }
