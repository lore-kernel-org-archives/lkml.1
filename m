Return-Path: <linux-kernel-owner+w=401wt.eu-S1751976AbYIAWKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbYIAWKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYIAWJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:09:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:38674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYIAWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:09:52 -0400
Date: Mon, 1 Sep 2008 15:09:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, torvalds@linux-foundation.org
Subject: [path] don't diff generated firmware files
Message-ID: <20080901150951.5cba4dc7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the new firmware infrastructure in 2.6.27, some files are generated and shouldn't be
diffed; add these 2 to the "dontdiff" file

Signed-off-by: Arjan van de Ven <arjan@Linux.intel.com>

diff -purN --exclude-from=linux.trees.git/Documentation/dontdiff /home/arjan/linux.trees.git/Documentation/dontdiff linux.trees.git/Documentation/dontdiff
--- linux.trees.git/Documentation/dontdiff	2008-05-01 13:13:42.000000000 -0700
+++ linux.trees.git/Documentation/dontdiff	2008-09-01 15:09:16.000000000 -0700
@@ -5,6 +5,8 @@
 *.css
 *.dvi
 *.eps
+*.fw.gen.S
+*.fw
 *.gif
 *.grep
 *.grp
