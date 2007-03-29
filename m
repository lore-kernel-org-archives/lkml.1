Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXC2Rip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXC2Rip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXC2Rip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:38:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44378 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbXC2Rip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:38:45 -0400
Date: Thu, 29 Mar 2007 10:39:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] header cleaning: don't include smp_lock.h when not used
Message-Id: <20070329103910.84f1ee8c.randy.dunlap@oracle.com>
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

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove includes of <linux/smp_lock.h> where it is not used/needed.
Suggested by Al Viro.

Builds cleanly on x86_64, i386, alpha, ia64, powerpc, sparc,
sparc64, and arm (all 59 defconfigs).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---

162 KB patch at:
http://oss.oracle.com/~rdunlap/patches/smp-lockh-clean.patch


(should I just artificially split this into < 100 KB chunks for lkml?)
