Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbXG1Ovr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbXG1Ovr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 10:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXG1Ovl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 10:51:41 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:7704 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXG1Ovk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 10:51:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=QGEQd9sRy6YK1cuSv6xRXJL9YY3+VYFTh2jqXcXm/mKu0QJGO/aFWzyR0sC3XGCz0nIeKZyLUQbe+6CEpDDl3LaBUXRDxnnjo1SkiKoRXnft76tzmGbbKd/unQN7XZ+nshP1dFvDAIexLFELy4Dv8hsUEpmw6zDasIDqPlwWLik=
Message-ID: <8b67d60707280751k76539f06t9a0feb67f2acdcb0@mail.gmail.com>
Date: Sat, 28 Jul 2007 15:51:38 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [PATCH] Framebuffer: Fix 16bpp colour output in Dreamcast pvr2fb
Cc: lethal@linux-sh.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13320_28273230.1185634298702"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13320_28273230.1185634298702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Tony,

This patch - on top of your others - fixes the colour output for 16bpp
RGB565 output in the Dreamcast - it was a simple out by one error in
the bit shift.

Still looking at the 24bpp and 32bpp issues.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

------=_Part_13320_28273230.1185634298702
Content-Type: text/x-patch; name="DC-16bpp.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="DC-16bpp.diff"
X-Attachment-Id: f_f4o80lqk

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vcHZyMmZiLmMgYi9kcml2ZXJzL3ZpZGVvL3B2cjJm
Yi5jCmluZGV4IDNhYzMyZjMuLjM4M2U4N2UgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdmlkZW8vcHZy
MmZiLmMKKysrIGIvZHJpdmVycy92aWRlby9wdnIyZmIuYwpAQCAtMzMwLDI3ICszMzEsMjggQEAg
c3RhdGljIGludCBwdnIyZmJfc2V0Y29scmVnKHVuc2lnbmVkIGludCByZWdubywgdW5zaWduZWQg
aW50IHJlZCwKIAkgICAgY2FzZSAxNjogLyogUkdCIDU2NSAqLwogCQl0bXAgPSAgKHJlZCAgICYg
MHhmODAwKSAgICAgICB8CiAJCSAgICAgICgoZ3JlZW4gJiAweGZjMDApID4+IDUpIHwKLQkJICAg
ICAgKChibHVlICAmIDB4ZjgwMCkgPj4gMTEpOworCQkgICAgICAoKGJsdWUgICYgMHhmODAwKSA+
PiAxMCk7CiAKIAkJcHZyMmZiX3NldF9wYWxfZW50cnkocGFyLCByZWdubywgdG1wKTsK
------=_Part_13320_28273230.1185634298702--
