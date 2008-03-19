Return-Path: <linux-kernel-owner+w=401wt.eu-S938036AbYCSVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938036AbYCSVlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbYCSUKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:10:24 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:33792 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYCSUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:10:22 -0400
Message-ID: <dc84318c0803182006u46b4ac2aj8d7a127963a0d5f3@mail.gmail.com>
Date: Wed, 19 Mar 2008 11:06:02 +0800
From: "Daolong Wang" <ahlongxp@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]CHECKPATCH:fix misleading output on spaces/tabs error
Cc: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got confused by this line:

    "ERROR: use tabs not spaces"

It literally means "use tabs but not spaces is WRONG", which
 is WRONG.

    "ERROR: do not use spaces when tabs expected"

sounds more appropriate.

Signed-off-by: Wang Daolong <ahlongxp@gmail.com>
---
--- scripts/checkpatch.pl.org	2008-03-18 23:08:41.000000000 +0800
+++ scripts/checkpatch.pl	2008-03-18 23:19:34.000000000 +0800
@@ -1064,7 +1064,7 @@ sub process {
 		if ($rawline =~ /^\+\s* \t\s*\S/ ||
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("use tabs not spaces\n" . $herevet);
+			ERROR("do not use spaces when tabs expected\n" . $herevet);
 		}

 # check for RCS/CVS revision markers
