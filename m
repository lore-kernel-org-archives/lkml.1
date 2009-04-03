Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbZDCEGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbZDCEGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZDCEGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:06:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60562 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZDCEGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:06:33 -0400
Date: Thu, 2 Apr 2009 21:06:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       niv@us.ibm.com, manfred@colorfullife.com, peterz@infradead.org
Subject: [PATCH] make treercu be default
Message-ID: <20090403040625.GA9473@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that I have not gotten any complaints or bug reports on treercu
recently, this patch makes it be the default.  There are a number of
other defconfig files that explicitly call out CLASSIC_RCU, but which
have comment headers saying not to edit them.  Probably holdovers from
one of the flavors of "make config", but...

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.29/init/Kconfig linux-2.6.29-trd/init/Kconfig
--- linux-2.6.29/init/Kconfig	2009-03-23 16:12:14.000000000 -0700
+++ linux-2.6.29-trd/init/Kconfig	2009-04-02 20:46:53.000000000 -0700
@@ -242,7 +242,7 @@ menu "RCU Subsystem"
 
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU
 
 config CLASSIC_RCU
 	bool "Classic RCU"
