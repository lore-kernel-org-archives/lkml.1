Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbXJWHQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbXJWHQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXJWHP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:15:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:60271 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbXJWHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=rSabhqFaZQulLMq0vK309R510xslZK2VhKdj52x4DVJYMAwO20ZazOJhUlCp3dVLh9f8JAk3ne3Jq8/4fRabB0gRsY4SaOGF3IzmtOKTPeBCEnNPZ4iEAT1+Opg9Q0F1/a49U1TNK04iwTrEY2DUgAQPaD+hfcxtDYVp/ptwwL0=
Message-ID: <3877989d0710230015x1640388aod98cae2fa3fc82c2@mail.gmail.com>
Date: Tue, 23 Oct 2007 15:15:55 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: linux-ia64@vger.kernel.org
Subject: [PATCH] fix typo in per_cpu_offset
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12136_32329095.1193123755592"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12136_32329095.1193123755592
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello list,

there is a typo in the definition of per_cpu_offset because, for ia64,
the __per_cpu_offset is an array.

 extern unsigned long __per_cpu_offset[NR_CPUS];
-#define per_cpu_offset(x) (__per_cpu_offset(x))
+#define per_cpu_offset(x) (__per_cpu_offset[x])

Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

------=_Part_12136_32329095.1193123755592
Content-Type: application/octet-stream; name=correct_per_cpu_offset.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8430x0q
Content-Disposition: attachment; filename=correct_per_cpu_offset.patch

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLWlhNjQvcGVyY3B1LmggYi9pbmNsdWRlL2FzbS1pYTY0
L3BlcmNwdS5oCmluZGV4IDQzYTdhYWMuLmM0ZjFlMzIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNt
LWlhNjQvcGVyY3B1LmgKKysrIGIvaW5jbHVkZS9hc20taWE2NC9wZXJjcHUuaApAQCAtNDYsNyAr
NDYsNyBAQCAjZW5kaWYKICNpZmRlZiBDT05GSUdfU01QCiAKIGV4dGVybiB1bnNpZ25lZCBsb25n
IF9fcGVyX2NwdV9vZmZzZXRbTlJfQ1BVU107Ci0jZGVmaW5lIHBlcl9jcHVfb2Zmc2V0KHgpIChf
X3Blcl9jcHVfb2Zmc2V0KHgpKQorI2RlZmluZSBwZXJfY3B1X29mZnNldCh4KSAoX19wZXJfY3B1
X29mZnNldFt4XSkKIAogLyogRXF1YWwgdG8gX19wZXJfY3B1X29mZnNldFtzbXBfcHJvY2Vzc29y
X2lkKCldLCBidXQgZmFzdGVyIHRvIGFjY2VzczogKi8KIERFQ0xBUkVfUEVSX0NQVSh1bnNpZ25l
ZCBsb25nLCBsb2NhbF9wZXJfY3B1X29mZnNldCk7Cg==
------=_Part_12136_32329095.1193123755592--
