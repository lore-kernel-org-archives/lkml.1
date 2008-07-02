Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYGBRIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYGBRIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 13:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYGBRIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 13:08:42 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:52408 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYGBRIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 13:08:41 -0400
Date: Wed, 2 Jul 2008 12:08:33 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] sysfs-rules.txt: reword API stability statement
Message-ID: <20080702170833.GZ9594@localdomain>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
 <20080702003755.4daff613.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702003755.4daff613.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 84529432-4859-11DD-BADF-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first paragraph of this document implies that user space
developers shouldn't use sysfs at all, but then it goes on to describe
rules that developers should follow when accessing sysfs.  Not only is
this somewhat self-contradictory, it has been shown to discourage
developers from using established sysfs interfaces.

A note of caution is more appropriate than a blanket "sysfs will never
be stable" assertion.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---

Andrew Morton wrote:
> 
> Those are dopey weasel words and they should be removed.

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
1.5.5

