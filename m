Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbZC3Bu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbZC3Bu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbZC3BuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:50:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50856 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZC3BuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:50:13 -0400
Message-ID: <49D0250E.7060701@redhat.com>
Date: Sun, 29 Mar 2009 20:49:02 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] add fiemap.h to header-y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include fiemap.h in header-y; it defines the interface
for the FS_IOC_FIEMAP file mapping ioctl.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/include/linux/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/Kbuild
+++ linux-2.6/include/linux/Kbuild
@@ -67,6 +67,7 @@ header-y += falloc.h
 header-y += fd.h
 header-y += fdreg.h
 header-y += fib_rules.h
+header-y += fiemap.h
 header-y += firewire-cdev.h
 header-y += firewire-constants.h
 header-y += fuse.h

