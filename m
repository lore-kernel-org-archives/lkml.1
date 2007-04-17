Return-Path: <linux-kernel-owner+w=401wt.eu-S1161042AbXDQRVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbXDQRVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXDQRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:21:09 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:57347 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161042AbXDQRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:21:08 -0400
Date: Tue, 17 Apr 2007 13:19:55 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [PATCH] general: convert "kernel" subdirectory to UTF-8
Message-ID: <alpine.DEB.0.83.0704171317580.914@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1875672472-557741582-1176830396=:914"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1875672472-557741582-1176830396=:914
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Convert the "kernel" subdirectory of the tree to UTF-8. The only file 
modified is <kernel/sys.c>.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I can't get my mail client to send in ISO-8859-1 instead of UTF-8, so the 
actual patch is attached in octet-stream format. The below patch is just 
for reference and will almost certainly NOT work.

Also, since the patch includes both encodings, whichever encoding you 
select while viewing it will display one correct and one garbled line. 
However, the bytecodes -are- correct.

diff -uprN linux-2.6.21-rc7.orig/kernel/sys.c linux-2.6.21-rc7.mod/kernel/sys.c
--- linux-2.6.21-rc7.orig/kernel/sys.c	2007-04-17 11:42:13.000000000 -0400
+++ linux-2.6.21-rc7.mod/kernel/sys.c	2007-04-17 13:16:59.000000000 -0400
@@ -1292,7 +1292,7 @@ asmlinkage long sys_setfsuid(uid_t uid)
 }
 
 /*
- * Samma på svenska..
+ * Samma pÃ¥ svenska..
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
--1875672472-557741582-1176830396=:914
Content-Type: APPLICATION/octet-stream; name=patch-kernel.bin
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.83.0704171319550.914@sigma.j-a-k-j.com>
Content-Description: 
Content-Disposition: attachment; filename=patch-kernel.bin

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcva2VybmVsL3N5cy5j
IGxpbnV4LTIuNi4yMS1yYzcubW9kL2tlcm5lbC9zeXMuYwotLS0gbGludXgt
Mi42LjIxLXJjNy5vcmlnL2tlcm5lbC9zeXMuYwkyMDA3LTA0LTE3IDExOjQy
OjEzLjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2Qv
a2VybmVsL3N5cy5jCTIwMDctMDQtMTcgMTM6MTY6NTkuMDAwMDAwMDAwIC0w
NDAwCkBAIC0xMjkyLDcgKzEyOTIsNyBAQCBhc21saW5rYWdlIGxvbmcgc3lz
X3NldGZzdWlkKHVpZF90IHVpZCkKIH0KIAogLyoKLSAqIFNhbW1hIHDlIHN2
ZW5za2EuLgorICogU2FtbWEgcMOlIHN2ZW5za2EuLgogICovCiBhc21saW5r
YWdlIGxvbmcgc3lzX3NldGZzZ2lkKGdpZF90IGdpZCkKIHsK

--1875672472-557741582-1176830396=:914--
