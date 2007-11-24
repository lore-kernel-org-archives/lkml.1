Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbXKXVWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbXKXVWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 16:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbXKXVWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 16:22:24 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50325 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbXKXVWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 16:22:23 -0500
Date: Sat, 24 Nov 2007 22:22:19 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071124211046.9931.46998.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] [MIPS]: Compliment va_start() with va_end().
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compliment va_start() with va_end().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---

 ieee754.c   |    2 ++
 ieee754dp.c |    2 ++
 ieee754sp.c |    2 ++
 3 files changed, 6 insertions(+)


diff --git a/arch/mips/math-emu/ieee754.c b/arch/mips/math-emu/ieee754.c
index 946aee3..cb1b682 100644
--- a/arch/mips/math-emu/ieee754.c
+++ b/arch/mips/math-emu/ieee754.c
@@ -108,6 +108,7 @@ int ieee754si_xcpt(int r, const char *op, ...)
 	ax.rv.si = r;
 	va_start(ax.ap, op);
 	ieee754_xcpt(&ax);
+	va_end(ax.ap);
 	return ax.rv.si;
 }
 
@@ -122,5 +123,6 @@ s64 ieee754di_xcpt(s64 r, const char *op, ...)
 	ax.rv.di = r;
 	va_start(ax.ap, op);
 	ieee754_xcpt(&ax);
+	va_end(ax.ap);
 	return ax.rv.di;
 }
diff --git a/arch/mips/math-emu/ieee754dp.c b/arch/mips/math-emu/ieee754dp.c
index 3e214aa..6d2d89f 100644
--- a/arch/mips/math-emu/ieee754dp.c
+++ b/arch/mips/math-emu/ieee754dp.c
@@ -57,6 +57,7 @@ ieee754dp ieee754dp_xcpt(ieee754dp r, const char *op, ...)
 	ax.rv.dp = r;
 	va_start(ax.ap, op);
 	ieee754_xcpt(&ax);
+	va_end(ax.ap);
 	return ax.rv.dp;
 }
 
@@ -83,6 +84,7 @@ ieee754dp ieee754dp_nanxcpt(ieee754dp r, const char *op, ...)
 	ax.rv.dp = r;
 	va_start(ax.ap, op);
 	ieee754_xcpt(&ax);
+	va_end(ax.ap);
 	return ax.rv.dp;
 }
 
diff --git a/arch/mips/math-emu/ieee754sp.c b/arch/mips/math-emu/ieee754sp.c
index adda851..4635340 100644
--- a/arch/mips/math-emu/ieee754sp.c
+++ b/arch/mips/math-emu/ieee754sp.c
@@ -58,6 +58,7 @@ ieee754sp ieee754sp_xcpt(ieee754sp r, const char *op, ...)
 	ax.rv.sp = r;
 	va_start(ax.ap, op);
 	ieee754_xcpt(&ax);
+	va_end(ax.ap);
 	return ax.rv.sp;
 }
 
@@ -84,6 +85,7 @@ ieee754sp ieee754sp_nanxcpt(ieee754sp r, const char *op, ...)
 	ax.rv.sp = r;
 	va_start(ax.ap, op);
 	ieee754_xcpt(&ax);
+	va_end(ax.ap);
 	return ax.rv.sp;
 }
 
