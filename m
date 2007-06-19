Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbXFSVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbXFSVqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXFSVqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:46:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34986 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXFSVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:46:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Jun 2007 23:45:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] Documentation/HOWTO: update URLs of git trees
To: Chris Wright <chrisw@sous-sol.org>
cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070619211555.GG3457@sequoia.sous-sol.org>
Message-ID: <tkrat.896aa9f24e1427a2@s5r6.in-berlin.de>
References: <tkrat.eee40c572537b7ba@s5r6.in-berlin.de>
 <20070619211555.GG3457@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Jun, Chris Wright wrote:
> * Stefan Richter (stefanr@s5r6.in-berlin.de) wrote:
>> +  Other kernel trees can be found listed at http://kernel.org/git and in
> 
> Should be http://git.kernel.org/ these days

Right.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Documentation/HOWTO: update URLs of git trees

Also, remove outdated 1394 tree and mention MAINTAINERS as pointer to
development trees.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/HOWTO |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

Index: linux-2.6.22-rc5/Documentation/HOWTO
===================================================================
--- linux-2.6.22-rc5.orig/Documentation/HOWTO
+++ linux-2.6.22-rc5/Documentation/HOWTO
@@ -322,39 +322,34 @@ kernel releases as described above.
 Here is a list of some of the different kernel trees available:
   git trees:
     - Kbuild development tree, Sam Ravnborg <sam@ravnborg.org>
-	kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
+	git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
 
     - ACPI development tree, Len Brown <len.brown@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 
     - Block development tree, Jens Axboe <axboe@suse.de>
-	kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+	git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 
     - DRM development tree, Dave Airlie <airlied@linux.ie>
-	kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 
     - ia64 development tree, Tony Luck <tony.luck@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
-
-    - ieee1394 development tree, Jody McIntyre <scjody@modernduck.com>
-	kernel.org:/pub/scm/linux/kernel/git/scjody/ieee1394.git
+	git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 
     - infiniband, Roland Dreier <rolandd@cisco.com>
-	kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+	git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 
     - libata, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 
     - network drivers, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 
     - pcmcia, Dominik Brodowski <linux@dominikbrodowski.net>
-	kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 
     - SCSI, James Bottomley <James.Bottomley@SteelEye.com>
-	kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-
-  Other git kernel trees can be found listed at http://kernel.org/git
+	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 
   quilt trees:
     - USB, PCI, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>
@@ -362,6 +357,9 @@ Here is a list of some of the different 
     - x86-64, partly i386, Andi Kleen <ak@suse.de>
         ftp.firstfloor.org:/pub/ak/x86_64/quilt/
 
+  Other kernel trees can be found listed at http://git.kernel.org/ and in
+  the MAINTAINERS file.
+
 Bug Reporting
 -------------
 


-- 
Stefan Richter
-=====-=-=== -==- =--==
http://arcgraph.de/sr/

