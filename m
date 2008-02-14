Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbYBNTbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbYBNTbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYBNTbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:31:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:1097 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbYBNTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rAgZ2cXH3QaOWMuN+2dZT31yp5k8zTaoul3cOiVgKMBhTkoDSRgiIjJjbCvIk9DBTVIrOrL4FG7Dbmes71n76HruzlqdoVh/5ZVPhuVVxbODg4RNeVBZHiTVUoF8eQoxm8tbVxJ+AO+8rdf2i+9IxQ9L11YSdtyAjyZAiFrr0Ew=
Subject: [PATCH] checkpatch: remove fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 11:31:28 -0800
Message-Id: <1203017488.2748.75.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall no longer exists in tree, remove it from checkpatch.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 scripts/checkpatch.pl |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2086a85..6f9b391 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -105,8 +105,7 @@ our $Sparse	= qr{
 			__iomem|
 			__must_check|
 			__init_refok|
-			__kprobes|
-			fastcall
+			__kprobes
 		}x;
 our $Attribute	= qr{
 			const|
-- 
1.5.4.1.1278.gc75be

