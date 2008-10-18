Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYJRFYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYJRFYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 01:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYJRFYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 01:24:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64408 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYJRFYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 01:24:16 -0400
Message-ID: <48F972F2.6090508@oracle.com>
Date: Fri, 17 Oct 2008 22:24:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Hans Ulrich Niedermann <hun@n-dimensional.de>
Subject: [PATCH 3/3] docs: align command spacing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Ulrich Niedermann <hun@n-dimensional.de>

The total width of the command name plus spaces should be
8 characters, but were 7 and 9, respectively. With 8 chars,
all commands are now lining up nicely.

The mandocs, psdocs, xmldocs commands are OK.

Before:
  HOSTCC  scripts/basic/docproc
  DOCPROC Documentation/DocBook/deviceiobook.xml
  HTML   Documentation/DocBook/deviceiobook.html
  DOCPROC Documentation/DocBook/wanbook.xml
  PDF      Documentation/DocBook/wanbook.pdf

After:
  HOSTCC  scripts/basic/docproc
  DOCPROC Documentation/DocBook/deviceiobook.xml
  HTML    Documentation/DocBook/deviceiobook.html
  DOCPROC Documentation/DocBook/wanbook.xml
  PDF     Documentation/DocBook/wanbook.pdf

Signed-off-by: Hans Ulrich Niedermann <hun@n-dimensional.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lin2627-git8.orig/Documentation/DocBook/Makefile
+++ lin2627-git8/Documentation/DocBook/Makefile
@@ -136,7 +136,7 @@ quiet_cmd_db2ps = PS      $@
 %.ps : %.xml
 	$(call cmd,db2ps)
 
-quiet_cmd_db2pdf = PDF      $@
+quiet_cmd_db2pdf = PDF     $@
       cmd_db2pdf = $(subst TYPE,pdf, $($(PDF_METHOD)template))
 %.pdf : %.xml
 	$(call cmd,db2pdf)
@@ -148,7 +148,7 @@ build_main_index = rm -rf $(main_idx) &&
 		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
 		   cat $(HTML) >> $(main_idx)
 
-quiet_cmd_db2html = HTML   $@
+quiet_cmd_db2html = HTML    $@
       cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
 		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
         $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
