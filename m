Return-Path: <linux-kernel-owner+w=401wt.eu-S1945975AbXBPQdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975AbXBPQdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945987AbXBPQdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:33:55 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:31712 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945975AbXBPQdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:33:54 -0500
Date: Fri, 16 Feb 2007 08:30:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
Subject: Re: [PATCH] update Doc/oops-tracing.txt for TAINT_USER
Message-Id: <20070216083029.ab6908e4.randy.dunlap@oracle.com>
In-Reply-To: <20070216145033.GA25957@thunk.org>
References: <20070215170414.56e6193b.randy.dunlap@oracle.com>
	<20070216145033.GA25957@thunk.org>
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

On Fri, 16 Feb 2007 09:50:33 -0500 Theodore Tso wrote:

> I suggest you change this to read "if a user or user application".
> 
> Otherwise,
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


From: Randy Dunlap <randy.dunlap@oracle.com>

Add TAINT_USER description to Tainted flags in oops-tracing.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 Documentation/oops-tracing.txt |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.20-git9.orig/Documentation/oops-tracing.txt
+++ linux-2.6.20-git9/Documentation/oops-tracing.txt
@@ -234,6 +234,9 @@ characters, each representing a particul
   6: 'B' if a page-release function has found a bad page reference or
      some unexpected page flags.
 
+  7: 'U' if a user or user application specifically requested that the
+     Tainted flag be set, ' ' otherwise.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
