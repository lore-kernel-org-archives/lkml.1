Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbXDKPl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbXDKPl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXDKPl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:41:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58168 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbXDKPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:41:56 -0400
Date: Wed, 11 Apr 2007 08:44:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] alphabetically-sorted entries in
 index.html of 'htmldocs'
Message-Id: <20070411084412.68530a3f.randy.dunlap@oracle.com>
In-Reply-To: <20070411080211.GB3982@gollum.tnic>
References: <20070410234422.GA30554@zmei.tnic>
	<20070410212143.3a5d786d.randy.dunlap@oracle.com>
	<20070411080211.GB3982@gollum.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 10:02:12 +0200 Borislav Petkov wrote:

> This patch sorts the DOCBOOKS entries in Documentation/DocBook/Makefile
> alphabetically.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Make docbook index.html contain sorted output.

I prefer to let the computer do it.  This also avoids
people not reading the comment(s).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2621-rc6.orig/Documentation/DocBook/Makefile
+++ linux-2621-rc6/Documentation/DocBook/Makefile
@@ -41,7 +41,7 @@ psdocs: $(PS)
 PDF := $(patsubst %.xml, %.pdf, $(BOOKS))
 pdfdocs: $(PDF)
 
-HTML := $(patsubst %.xml, %.html, $(BOOKS))
+HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
 	$(call build_main_index)
 
