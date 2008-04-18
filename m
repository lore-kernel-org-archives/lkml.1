Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYDRP2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYDRP2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYDRP2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:28:40 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:65233 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751904AbYDRP2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:28:39 -0400
Date: Fri, 18 Apr 2008 16:28:35 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] dontdiff: ignore timeconst.h
Message-ID: <20080418152835.GA18296@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore the autobuilt kernel/timeconst.h when
using diff on an built kernel tree.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

diff -urp linux-2.6.25-dontdiff/Documentation/dontdiff linux-2.6.25-dontdiff2/Documentation/dontdiff
--- linux-2.6.25-dontdiff/Documentation/dontdiff	2008-04-18 16:16:45.000000000 +0100
+++ linux-2.6.25-dontdiff2/Documentation/dontdiff	2008-04-18 16:26:14.000000000 +0100
@@ -173,6 +173,7 @@ sm_tbl*
 split-include
 tags
 tftpboot.img
+timeconst.h
 times.h*
 tkparse
 trix_boot.h

