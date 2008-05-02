Return-Path: <linux-kernel-owner+w=401wt.eu-S935681AbYEBPng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935681AbYEBPng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932512AbYEBPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:43:22 -0400
Received: from hosted.by.hostbasket.com ([85.255.197.33]:51749 "EHLO
	SMTPGate.qlayer.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933972AbYEBPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:43:21 -0400
X-Greylist: delayed 1630 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 11:43:20 EDT
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Jesper Juhl <trivial@kernel.org>
Subject: [PATCH 2.6.25.1] Suppress more generated files via Documentation/dontdiff
Date: Fri, 2 May 2008 17:16:02 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021716.02753.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can the patch below please be reviewed ? Last time I ran diff over two kernel 
trees I noted that several generated files were included in the diff. The 
patch below suppresses these generated files (modules.order, timeconst.h and 
several vdso* and vdso32* files).

Signed-off-by: bart.vanassche@gmail.com

--- orig/linux-2.6.25.1/Documentation/dontdiff  2008-05-01 23:45:25.000000000 
+0200
+++ linux-2.6.25.1/Documentation/dontdiff       2008-05-02 15:43:51.000000000 
+0200
@@ -142,6 +142,7 @@ mkprep
 mktables
 mktree
 modpost
+modules.order
 modversions.h*
 offset.h
 offsets.h
@@ -173,10 +174,11 @@ split-include
 tags
 tftpboot.img
 times.h*
+timeconst.h
 tkparse
 trix_boot.h
 utsrelease.h*
-vdso.lds
+vdso*[^Sch]
 version.h*
 vmlinux
 vmlinux-*
