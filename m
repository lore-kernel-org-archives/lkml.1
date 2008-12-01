Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYLAQrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYLAQrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYLAQrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:47:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:44007 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYLAQrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:user-agent:mime-version:content-type
         :from;
        b=EMeT0QK20sRFYr9YKM8/zHgzvMVZ8gYTBAMn0yu4BszFlwP/X4tv/vFOWziV1yi25h
         bhPBNzw4OFHNzcOa2q+URIwPwdrUUFChjOteribZ5wpBe6y9S0tYcn1xCW54mJkH466E
         70NTxRRj69YidlC3XeZRUFhXO5Vmia3sCHARU=
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: [ext4] Documentation patch
Date: Mon, 01 Dec 2008 17:46:56 +0100
Message-ID: <8763m3u9kv.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Harald Arnesen <skogtun.harald@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My first patch, hope it goes through ok! 
Applies to 2.6.28-rc6-00184-gd9d060a.

Compare ext4's journalling with anything but ext3's. These use the same
journalling modes, most other Linux filesystems do only metadata
journalling.

Signed-off-by: Harald Arnesen <harald@skogtun.org>

========================================================================
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 174eaff..5bbe79e 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -61,7 +61,7 @@ Note: More extensive information for getting started with ext4 can be
   - When comparing performance with other filesystems, remember that
     ext3/4 by default offers higher data integrity guarantees than most.
     So when comparing with a metadata-only journalling filesystem, such
-    as ext3, use `mount -o data=writeback'.  And you might as well use
+    as jfs or xfs, use `mount -o data=writeback'.  And you might as well use
     `mount -o nobh' too along with it.  Making the journal larger than
     the mke2fs default often helps performance with metadata-intensive
     workloads.
-- 
Hilsen Harald.
