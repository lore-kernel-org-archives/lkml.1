Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbYBYW7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbYBYW7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbYBYW72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:59:28 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:58387 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762123AbYBYW71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:59:27 -0500
Date: Mon, 25 Feb 2008 22:59:21 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Ignore emacs backup and temporary files.
Message-ID: <20080225225921.GA19507@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Dearman <chris@mips.com>

Signed-off-by: Chris Dearman <chris@mips.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/.gitignore b/.gitignore
index 8363e48..fdcce40 100644
--- a/.gitignore
+++ b/.gitignore
@@ -53,3 +53,5 @@ cscope.*
 
 *.orig
 *.rej
+*~
+\#*#
