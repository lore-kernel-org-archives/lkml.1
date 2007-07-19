Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbXGSUOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbXGSUOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXGSUOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:14:40 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42987 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755129AbXGSUOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:14:39 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: rusty@rustcorp.com.au
Subject: [PATCH] Remove -static from Documentation/lguest/Makefile
Date: Thu, 19 Jul 2007 23:13:42 +0300
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707192313.44106.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Remove -static from Documentation/lguest/Makefile, most distros only provides shared library form of zlib in their default installation. 
And shared linking also provides litte tiny security for hypotetical security problems will be introduced by zlib :).

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

Documentation/lguest/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/lguest/Makefile b/Documentation/lguest/Makefile
index b9b9427..2331179 100644
--- a/Documentation/lguest/Makefile
+++ b/Documentation/lguest/Makefile
@@ -12,7 +12,7 @@ include $(KBUILD_OUTPUT)/.config
 LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
 CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
-	-static -DLGUEST_GUEST_TOP="$(LGUEST_GUEST_TOP)" -Wl,-T,lguest.lds
+	-DLGUEST_GUEST_TOP="$(LGUEST_GUEST_TOP)" -Wl,-T,lguest.lds
 LDLIBS:=-lz
 
 all: lguest.lds lguest

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
