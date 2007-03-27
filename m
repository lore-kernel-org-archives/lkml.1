Return-Path: <linux-kernel-owner+w=401wt.eu-S965451AbXC0VVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbXC0VVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965453AbXC0VVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:21:37 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:43872 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965451AbXC0VVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:21:36 -0400
Date: Tue, 27 Mar 2007 15:21:33 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] clarify CONFIG_DEBUG_INFO help text
Message-ID: <20070327212133.GA22409@schatzie.adilger.int>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds some extra clarification to the CONFIG_DEBUG_INFO
Kconfig help text.  The current text is mostly a recursive definition and
doesn't really say much of anything.  When I first read this I thought it
was going to enable extra verbosity in debug messages or something, but it
is only enabling the "gcc -g" compile option in the Makefile.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

--- ./lib/Kconfig.debug.orig	2007-02-07 17:10:34.000000000 -0700
+++ ./lib/Kconfig.debug	2007-03-27 13:32:17.000000000 -0600
@@ -322,6 +322,9 @@
 	help
           If you say Y here the resulting kernel image will include
 	  debugging info resulting in a larger kernel image.
+	  This adds debug symbols to the kernel and modules (gcc -g), and
+	  is needed if you intend to use kernel crashdump or binary object
+	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
 	  Say Y here only if you plan to debug the kernel.
 
 	  If unsure, say N.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

