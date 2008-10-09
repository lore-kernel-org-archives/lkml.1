Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYJIBN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYJIBN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYJIBNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:13:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41018 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJIBNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:13:19 -0400
Date: Wed, 8 Oct 2008 18:12:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: [PATCH] documentation: explain memory barriers
Message-Id: <20081008181223.6954c7b2.randy.dunlap@oracle.com>
In-Reply-To: <20081001225404.4e973465.akpm@linux-foundation.org>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
	<20080923154905.50d4b0fa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
	<20080923164623.ce82c1c2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
	<20081001225404.4e973465.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 22:54:04 -0700 Andrew Morton wrote:

> This sequence is repeated three or four times and should be pulled out
> into a well-commented function.  That comment should explain the logic
> behind the use of these barriers, please.

and on 2008-OCT-08 Ben Hutchings wrote:

> All memory barriers need a comment to explain why and what they're doing.


Should this be added to CodingStyle or some other file?




From: Randy Dunlap <randy.dunlap@oracle.com>

We want all uses of memory barriers to be explained in the source
code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmitChecklist |    3 +++
 1 file changed, 3 insertions(+)

--- lin2627-rc9-docs.orig/Documentation/SubmitChecklist
+++ lin2627-rc9-docs/Documentation/SubmitChecklist
@@ -85,3 +85,6 @@ kernel patches.
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
     changes in the VM, VFS, and other subsystems.
+
+24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment in the
+    source code that explains the logic of what they are doing and why.
