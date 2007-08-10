Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXHJDmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXHJDmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 23:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXHJDmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 23:42:39 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51056
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXHJDmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 23:42:38 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: akpm@linux-foundation.org
Subject: [PATCH] Minor fix to Documentation/powerpc/00-INDEX
Date: Thu, 9 Aug 2007 23:42:35 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, paulus@samba.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708092342.35238.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>

I have a python script to convert 00-INDEX files into index.html files, and a
second script to show 404 errors in the result as well as files/directories
nothing links to.   (It's not very useful yet, but in case you're wondering
http://kernel.org/doc/docdiridx.py and http://kernel.org/doc/doclinkcheck.py
.)

Anyway, my simple index.html generator breaks on the Documentation/powerpc
directory because one of the description lines is two lines long.  This
patch joins those two lines together into one line.  This is the only
instance (so far) of this problem.

---

In case you're wondering, here are the current the 404 errors in the
various 00-INDEX files.  Fixing all this is on my todo list:

Documentation/ecryptfs.txt
Documentation/time_interpolators.txt
Documentation/arm/SA1100
Documentation/arm/XScale
Documentation/arm/empeg
Documentation/arm/nwfpe
Documentation/isdn/README.eicon
Documentation/fb/clgenfb.txt
Documentation/networking/ethertap.txt
Documentation/filesystems/reiser4.txt
Documentation/scsi/AM53C974.txt
Documentation/scsi/ChangeLog

The "files and directories not linked to" list is 679 lines long.

diff -r /dev/null Documentation/powerpc/00-INDEX
--- a/Documentation/powerpc/00-INDEX	Thu Aug 09 08:40:21 2007 -0700
+++ b/Documentation/powerpc/00-INDEX	Thu Aug 09 20:49:03 2007 -0500
@@ -6,8 +6,7 @@ 00-INDEX
 00-INDEX
 	- this file
 cpu_features.txt
-	- info on how we support a variety of CPUs with minimal compile-time
-	options.
+	- info on how we support a variety of CPUs with minimal compile-time options.
 eeh-pci-error-recovery.txt
 	- info on PCI Bus EEH Error Recovery
 hvcs.txt

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
