Return-Path: <linux-kernel-owner+w=401wt.eu-S933324AbXGZMQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbXGZMQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXGZMP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:15:59 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:15692 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779AbXGZMP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:15:58 -0400
Date: Thu, 26 Jul 2007 16:15:48 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] .gitignore update
Message-ID: <20070726121547.GA16937@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow I ended up with the following in tree:

	$ git status
		...
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#       fs/proc/root.o.FuMxJQ
	#       net/ipv4/tcp_minisocks.o.geCDYR

These are presumably temporary gcc files, which aren't interesting.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/.gitignore
+++ b/.gitignore
@@ -7,6 +7,7 @@
 #
 .*
 *.o
+*.o.*
 *.a
 *.s
 *.ko

