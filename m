Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbXIKOxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbXIKOxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXIKOwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:52:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49167 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXIKOwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:52:38 -0400
Date: Tue, 11 Sep 2007 10:52:22 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [ PATCH 3/3 ] UML - More idiomatic parameter parsing
Message-ID: <20070911145222.GA6391@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make mconsole parameter parsing slightly more idiomatic.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/mconsole_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/mconsole_kern.c	2007-09-09 10:23:29.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/mconsole_kern.c	2007-09-11 10:38:17.000000000 -0400
@@ -878,7 +878,7 @@ void unlock_notify(void)
 
 __initcall(create_proc_mconsole);
 
-#define NOTIFY "=notify:"
+#define NOTIFY "notify:"
 
 static int mconsole_setup(char *str)
 {
@@ -890,7 +890,7 @@ static int mconsole_setup(char *str)
 	return 1;
 }
 
-__setup("mconsole", mconsole_setup);
+__setup("mconsole=", mconsole_setup);
 
 __uml_help(mconsole_setup,
 "mconsole=notify:<socket>\n"
