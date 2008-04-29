Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbYD2UBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbYD2UBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYD2UBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:01:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbYD2UBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:01:42 -0400
Date: Tue, 29 Apr 2008 16:01:22 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [TRIVIAL] typo in hfsplus.
Message-ID: <20080429200122.GA2859@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/fs/hfsplus/super.c~	2008-04-29 15:59:42.000000000 -0400
+++ linux-2.6/fs/hfsplus/super.c	2008-04-29 15:59:51.000000000 -0400
@@ -357,7 +357,7 @@ static int hfsplus_fill_super(struct sup
 		printk(KERN_WARNING "hfs: Filesystem is marked locked, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
-		printk(KERN_WARNING "hfs: write access to a jounaled filesystem is not supported, "
+		printk(KERN_WARNING "hfs: write access to a journaled filesystem is not supported, "
 		       "use the force option at your own risk, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	}

-- 
http://www.codemonkey.org.uk
