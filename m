Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYJWPGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYJWPGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYJWPFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:05:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:33907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbYJWPFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:05:50 -0400
Message-Id: <20081023150549.038994457@marvin.suse.de>
User-Agent: quilt/0.47-12
Date: Thu, 23 Oct 2008 16:50:57 +0200
From: Daniel Gollub <dgollub@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: linux-man@vger.kernel.org
Cc: ltp-list@lists.sourceforge.net
Subject: [patch 2/3] [man-pages] Remove "bufsize is not positive" from readlink(2) error section
References: <20081023145054.998439866@marvin.suse.de>
Content-Disposition: inline; filename=man-pages-readlink-2.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error statement "bufsize is not positive" is obsolete, if this proposed
syscall interface change get accepted.

Note: Kernel 2.6.27 and older shipped sys_readlink with a signed "bufsiz" 
argument. Man-page document the readlink syscall always as unsigend (size_t).

Signed-off-by: Daniel Gollub <dgollub@suse.de>

---

 man2/readlink.2 |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/man2/readlink.2 b/man2/readlink.2
index b94db21..470c222 100644
--- a/man2/readlink.2
+++ b/man2/readlink.2
@@ -86,10 +86,6 @@ Search permission is denied for a component of the path prefix.
 extends outside the process's allocated address space.
 .TP
 .B EINVAL
-.I bufsiz
-is not positive.
-.TP
-.B EINVAL
 The named file is not a symbolic link.
 .TP
 .B EIO

