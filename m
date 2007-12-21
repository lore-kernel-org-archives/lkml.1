Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbXLUKSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbXLUKSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXLUKSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:18:40 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:42183 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbXLUKSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:18:39 -0500
Date: Fri, 21 Dec 2007 12:18:37 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Warnings from sched_debug.c
Message-ID: <Pine.SOC.4.64.0712211217170.16480@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happens on sparc64 with 2.6.24-rc6 (gcc-4.2):

  CC      kernel/sched.o
In file included from kernel/sched.c:879:
kernel/sched_debug.c: In function 'nsec_high':
kernel/sched_debug.c:38: warning: comparison of distinct pointer types lacks a cast
kernel/sched_debug.c:41: warning: comparison of distinct pointer types lacks a cast
kernel/sched_debug.c: In function 'nsec_low':
kernel/sched_debug.c:51: warning: comparison of distinct pointer types lacks a cast


-- 
Meelis Roos (mroos@linux.ee)
