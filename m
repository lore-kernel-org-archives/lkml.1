Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZADDOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZADDOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZADDN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:13:56 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:6728 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZADDNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:13:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=MwfP0G2AcKSnK2ZzkiZRFPE/p6ENv4whxEVWXvLMEf5VyfaYCXzBkwoZyDjwgEDbip
         VliMbqW7l/NiD1djXfQQcVJQymtT345nP74cUHWz5Yn58qVT2MLtImcutUvfDF4fh6gY
         42Xk6oVm03hVtEBeq2k2DqX3PZ15PFAfS50FU=
Date: Sun, 04 Jan 2009 11:13:58 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@elte.hu
Subject: swiotlb: remove duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090104110951.C9AB.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include in lib/swiotlb.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index fa2dc4e..c3fbcd8 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -23,7 +23,6 @@
 #include <linux/spinlock.h>
 #include <linux/swiotlb.h>
 #include <linux/string.h>
-#include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>

