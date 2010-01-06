Return-Path: <linux-kernel-owner+w=401wt.eu-S932287Ab0AFQ4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab0AFQ4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932182Ab0AFQ4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:56:50 -0500
Received: from www84.your-server.de ([213.133.104.84]:48063 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab0AFQ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:56:49 -0500
Subject: [PATCH] checkpatch.pl: remove the punch card limit
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Jan 2010 17:56:24 +0100
Message-ID: <1262796984.1011.17.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time of 80 characters punch card and terminals are over, so i would
be a good thing to set the line length limit to 120. Every display today
should be able handle this. And it think it make formated source code
more readable.

For everybody who want know: The 80 column limit of a terminal comes
from the punch cards, which stored exact 80 characters.
  
Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.33-rc2.orig/scripts/checkpatch.pl	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.33-rc2.new/scripts/checkpatch.pl	2010-01-06 17:46:40.057565661 +0100
@@ -1374,13 +1374,13 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
+#120 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
-		    $length > 80)
+		    $length > 120)
 		{
-			WARN("line over 80 characters\n" . $herecurr);
+			WARN("line over 120 characters\n" . $herecurr);
 		}
 
 # check for adding lines without a newline.




