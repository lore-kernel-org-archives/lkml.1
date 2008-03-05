Return-Path: <linux-kernel-owner+w=401wt.eu-S935618AbYCEBVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935618AbYCEBVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759545AbYCEBR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:57 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:28059 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762967AbYCEBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vX36h9nGYYLuMIWAq9ETmF1y0rxcVQrpfXtgeIDMTkSxDenDpN1WNbXTP/qBjMLMPOfy1ajF0oTnsk+xn94L+Rwnzb6Ar29kn02dO05CXrA4Nd3tfVKYRD1bovCp9zb4k5Qyi0ym1OxJdo1ZCzK9JlFRxKVfofZEenb5e319Buw=
Subject: [PATCH 8/9] alpha: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "rth@twiddle.net" <rth@twiddle.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:20 -0800
Message-Id: <1204679840.5698.74.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-alpha/byteorder.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-alpha/byteorder.h b/include/asm-alpha/byteorder.h
index 7af2b8d..58e958f 100644
--- a/include/asm-alpha/byteorder.h
+++ b/include/asm-alpha/byteorder.h
@@ -7,7 +7,7 @@
 
 #ifdef __GNUC__
 
-static __inline __attribute_const__ __u32 __arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch__swab32(__u32 x)
 {
 	/*
 	 * Unfortunately, we can't use the 6 instruction sequence
-- 
1.5.4.3.500.g83a2c


