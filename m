Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbXBMTP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbXBMTP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbXBMTP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:15:28 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33648 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbXBMTP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:15:26 -0500
Date: Tue, 13 Feb 2007 11:10:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: johannes@sipsolutions.net
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
Subject: [PATCH] kernel-doc: include struct short description in title
 output
Message-Id: <20070213111042.e10a4234.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Output of a struct in html mode needs to include the short description
from the struct name line in the output title line.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20-git7.orig/scripts/kernel-doc
+++ linux-2.6.20-git7/scripts/kernel-doc
@@ -452,7 +452,7 @@ sub output_struct_html(%) {
     my %args = %{$_[0]};
     my ($parameter);
 
-    print "<h2>".$args{'type'}." ".$args{'struct'}."</h2>\n";
+    print "<h2>".$args{'type'}." ".$args{'struct'}. " - " .$args{'purpose'}."</h2>\n";
     print "<b>".$args{'type'}." ".$args{'struct'}."</b> {<br>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
