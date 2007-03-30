Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbXC3ELP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbXC3ELP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 00:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXC3ELP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 00:11:15 -0400
Received: from koto.vergenet.net ([210.128.90.7]:60354 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXC3ELP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 00:11:15 -0400
Date: Fri, 30 Mar 2007 13:10:03 +0900
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org
Cc: Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>
Subject: [PATCH] CPUSETS: add mems to basic usage documentation
Message-ID: <20070330041001.GA20566@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that there must be at least one node in mems
and at least one CPU in cpus in order to be able to assign
tasks to a cpuset. This makes sense. And I think it would
also make sense to include a mems setting in the basic usage
section of the documentation.

I also wonder if something logged to dmsg, explaining why
a write failed, would be a good enhancement. I ended up having
rummage arround in cpuset.c in order to work out why my 
configuration was failing.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/Documentation/cpusets.txt
===================================================================
--- linux-2.6.orig/Documentation/cpusets.txt	2007-03-30 13:03:07.000000000 +0900
+++ linux-2.6/Documentation/cpusets.txt	2007-03-30 13:03:19.000000000 +0900
@@ -557,6 +557,9 @@
 Add some cpus:
 # /bin/echo 0-7 > cpus
 
+Add some mems:
+# /bin/echo 0-7 > mems
+
 Now attach your shell to this cpuset:
 # /bin/echo $$ > tasks
 
