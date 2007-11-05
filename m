Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbXKEDDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbXKEDDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 22:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXKEDCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 22:02:54 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:25166 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752582AbXKEDCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 22:02:53 -0500
Date: Mon, 5 Nov 2007 12:02:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: duplicated include files
Message-ID: <20071105030240.GA26439@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0711041229580.27153@localhost.localdomain> <20071104100724.518cf6c9.randy.dunlap@oracle.com> <Pine.LNX.4.64.0711041334590.5541@localhost.localdomain> <20071104190348.GN12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104190348.GN12045@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 08:03:48PM +0100, Adrian Bunk wrote:
> BTW:  "make includecheck" already does the same...
> 
When was that added? It's not listed in the 'make help', and I see
there's a versioncheck too that's not reported. Some of these are
actually useful, I wonder what else is lurking in the depths of
undocumented Makefile target land ;-)

docs: Add includecheck/versioncheck to 'make help'

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/Makefile b/Makefile
index 188c3b6..1ab40ac 100644
--- a/Makefile
+++ b/Makefile
@@ -1168,6 +1168,8 @@ help:
 	@echo  ''
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
+	@echo  '  versioncheck    - Sanity check on version.h usage'
+	@echo  '  includecheck    - Sanity check on duplicate includes'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
 	@echo  '  export_report   - List the usages of all exported symbols'
 	@if [ -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
