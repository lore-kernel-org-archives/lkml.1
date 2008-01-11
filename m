Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbYAKRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbYAKRH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbYAKRHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:07:15 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51527 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510AbYAKRHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:07:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 11 Jan 2008 18:06:35 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] checkpatch.pl: show how to read from stdin
To: Andy Whitcroft <apw@shadowen.org>
cc: Daniel Walker <dwalker@mvista.com>, Bernd Petrovitsch <bernd@firmix.at>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <47875809.7060301@gmail.com>
Message-ID: <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>
References: <20080111041120.085610726@mvista.com> 
 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com> 
 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home> 
 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com>
 <1200044206.29897.73.camel@imap.mvista.com>
 <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
---
 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

Index: linux/scripts/checkpatch.pl
===================================================================
--- linux.orig/scripts/checkpatch.pl
+++ linux/scripts/checkpatch.pl
@@ -53,6 +53,7 @@ if ($#ARGV < 0) {
 	print "         --file       => check a source file\n";
 	print "         --strict     => enable more subjective tests\n";
 	print "         --root       => path to the kernel tree root\n";
+	print "When patchfile is -, read standard input.\n";
 	exit(1);
 }
 

-- 
Stefan Richter
-=====-==--- ---= -=-==
http://arcgraph.de/sr/

