Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXHDSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXHDSfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765618AbXHDSdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:33:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765655AbXHDSdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=RnOIS/gf9kKmKgGJe/R6/XcKFJk0lleYYjCJPrHICixH15zLL8oQ3xNuoqwT9P9PGNIwC47DLpT4/x1eEAS8DMkpasLdznfrDctqSBwP4tks9FLhPAl0noS+3h2GOgm2M0+6MRW2pfOAWhMkKGLv2+5mu5PguN6mz2N2QTBkvK4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND][Trivial] Documentation: sysrq, description of 'h' slightly inaccurate
Date: Sat, 4 Aug 2007 20:31:27 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, vulpyne@vulpyne.net, trivial@kernel.org,
       crutcher+kernel@datastacks.com, jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042031.27618.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending a patch from 21 May 2007 that never got any response)


Hello,

In Documentation/sysrq.txt, the description of 'h' says that any key not 
listed *above* will generate help. That's obviously not true since all the 
keys listed below 'h' will do what they are described to do, not display 
help. So change the text so that it says that any key not listed in the 
table will generate help, which is what really happens.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Documentation/sysrq.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index ba328f2..865b271 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -1,6 +1,6 @@
 Linux Magic System Request Key Hacks
 Documentation for sysrq.c
-Last update: 2007-MAR-14
+Last update: 2007-AUG-04
 
 *  What is the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -78,7 +78,7 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:
 'g'	- Used by kgdb on ppc and sh platforms.
 
 'h'     - Will display help (actually any other key than those listed
-          above will display help. but 'h' is easy to remember :-)
+          here will display help. but 'h' is easy to remember :-)
 
 'i'     - Send a SIGKILL to all processes, except for init.
 

