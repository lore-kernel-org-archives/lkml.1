Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZA3PG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZA3PG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZA3PFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:35 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60179 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZA3PFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:34 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 7/8] checkpatch: add __ref as a sparse modifier
Date: Fri, 30 Jan 2009 15:05:19 +0000
Message-Id: <1233327920-16691-8-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <1233327920-16691-1-git-send-email-apw@canonical.com>
References: <1233327920-16691-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __ref as a sparse modifier.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0dcfdce..60ad8db 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -110,7 +110,8 @@ our $Sparse	= qr{
 			__iomem|
 			__must_check|
 			__init_refok|
-			__kprobes
+			__kprobes|
+			__ref
 		}x;
 our $Attribute	= qr{
 			const|
-- 
1.6.1.2.419.g0d87e

