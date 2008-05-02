Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYEBLKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYEBLKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbYEBLKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:10:33 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:50994 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761667AbYEBLKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:10:32 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove *.rej pattern from .gitignore
Date: Fri, 2 May 2008 14:10:08 +0300
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, adobriyan@sw.ru
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805021410.11445.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

With commit "3f1b0e1f287547903f11fa1e6de7d2765597766e" Linus's current git tree starts to ignore any "*.rej" files. So "git status" no longer shows these files, but the ones who works with quilt patchsets, this not makes life easier as expected. Because sometimes a work flow (at least for me) requires "quilt push -f" followed by "git status" to see unresolved merge conflicts, work on these conflicts to correct them and finalize the patch with "quilt refresh".

And if there are some "*.rej" files exists in tree, for whatever reason, this means something goes really wrong there and i think this situation not deserves to be ignored.

This is the second time i came across with this patch cause the first one (http://lkml.org/lkml/2007/7/18/327) ends up nowhere :)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

diff --git a/.gitignore b/.gitignore
index 090b293..9c0d650 100644
--- a/.gitignore
+++ b/.gitignore
@@ -54,6 +54,5 @@ series
 cscope.*
 
 *.orig
-*.rej
 *~
 \#*#


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
