Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbYGVFos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbYGVFos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbYGVF00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:43409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbYGVF0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Lynch <ntl@pobox.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 69/79] sysfs-rules.txt: reword API stability statement
Date: Mon, 21 Jul 2008 22:19:33 -0700
Message-Id: <1216703983-21448-69-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

The first paragraph of this document implies that user space developers
shouldn't use sysfs at all, but then it goes on to describe rules that
developers should follow when accessing sysfs.  Not only is this somewhat
self-contradictory, it has been shown to discourage developers from using
established sysfs interfaces.

A note of caution is more appropriate than a blanket "sysfs will never
be stable" assertion.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/sysfs-rules.txt |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
index 80ef562..6049a2a 100644
--- a/Documentation/sysfs-rules.txt
+++ b/Documentation/sysfs-rules.txt
@@ -3,9 +3,8 @@ Rules on how to access information in the Linux kernel sysfs
 The kernel-exported sysfs exports internal kernel implementation details
 and depends on internal kernel structures and layout. It is agreed upon
 by the kernel developers that the Linux kernel does not provide a stable
-internal API. As sysfs is a direct export of kernel internal
-structures, the sysfs interface cannot provide a stable interface either;
-it may always change along with internal kernel changes.
+internal API. Therefore, there are aspects of the sysfs interface that
+may not be stable across kernel releases.
 
 To minimize the risk of breaking users of sysfs, which are in most cases
 low-level userspace applications, with a new kernel release, the users
-- 
1.5.6.3

