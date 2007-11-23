Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbXKWFnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbXKWFnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 00:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXKWFnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 00:43:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:17909 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbXKWFnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 00:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=nxDYpsbWrSG3a30VpgD/0mRN8zIj4lplosEitpPud0thst8PVBuwx/AshzIFzNMoBnJKRk3iK4a2dQJspdzQYPAVZD3UDF/WV0kg0C8vrlgLfTiEmH2//l50hEg7cp/oajNGnLaEktDPVC/SINobP8xlDo0GKNMz55wK6K6ILss=
Message-ID: <aa79d98a0711222143r746d8789r1bff0cb7b7cd88a5@mail.gmail.com>
Date: Fri, 23 Nov 2007 08:43:04 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [PATCH] PPC: CHRP - fix possible NULL pointer dereference
Cc: PPCML <linuxppc-dev@ozlabs.org>, "Olof Johansson" <olof@lixom.net>,
       "Paul Mackerras" <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071123101646.63550945.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_19488_23666844.1195796584724"
References: <20071122195423.GA9877@cvg>
	 <20071123101646.63550945.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_19488_23666844.1195796584724
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is updated version
---
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch does fix possible NULL pointer dereference
inside of strncmp() if of_get_property() failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

------=_Part_19488_23666844.1195796584724
Content-Type: text/plain; name=ppc-chrs-null-fix.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9cadwlc
Content-Disposition: attachment; filename=ppc-chrs-null-fix.diff

IGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvY2hycC9zZXR1cC5jIHwgICAxMyArKysrKysrKystLS0t
CiAxIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2NocnAvc2V0dXAuYyBiL2FyY2gvcG93ZXJw
Yy9wbGF0Zm9ybXMvY2hycC9zZXR1cC5jCmluZGV4IDU5MzA2MjYuLmRhNGU0NWUgMTAwNjQ0Ci0t
LSBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvY2hycC9zZXR1cC5jCisrKyBiL2FyY2gvcG93ZXJw
Yy9wbGF0Zm9ybXMvY2hycC9zZXR1cC5jCkBAIC0xMTUsNyArMTE1LDcgQEAgdm9pZCBjaHJwX3No
b3dfY3B1aW5mbyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0pCiAJc2VxX3ByaW50ZihtLCAibWFjaGluZVx0
XHQ6IENIUlAgJXNcbiIsIG1vZGVsKTsKIAogCS8qIGxvbmd0cmFpbCAoZ29sZGVuZ2F0ZSkgc3R1
ZmYgKi8KLQlpZiAoIXN0cm5jbXAobW9kZWwsICJJQk0sTG9uZ1RyYWlsIiwgMTMpKSB7CisJaWYg
KG1vZGVsICYmICFzdHJuY21wKG1vZGVsLCAiSUJNLExvbmdUcmFpbCIsIDEzKSkgewogCQkvKiBW
TFNJIFZBUzk2MDExLzEyIGBHb2xkZW4gR2F0ZSAyJyAqLwogCQkvKiBNZW1vcnkgYmFua3MgKi8K
IAkJc2RyYW1lbiA9IChpbl9sZTMyKGdnMl9wY2lfY29uZmlnX2Jhc2UgKyBHRzJfUENJX0RSQU1f
Q1RSTCkKQEAgLTIwMywxNSArMjAzLDIwIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBzaW9fZml4dXBf
aXJxKGNvbnN0IGNoYXIgKm5hbWUsIHU4IGRldmljZSwgdTggbGV2ZWwsCiBzdGF0aWMgdm9pZCBf
X2luaXQgc2lvX2luaXQodm9pZCkKIHsKIAlzdHJ1Y3QgZGV2aWNlX25vZGUgKnJvb3Q7CisJY29u
c3QgY2hhciAqbW9kZWw7CiAKLQlpZiAoKHJvb3QgPSBvZl9maW5kX25vZGVfYnlfcGF0aCgiLyIp
KSAmJgotCSAgICAhc3RybmNtcChvZl9nZXRfcHJvcGVydHkocm9vdCwgIm1vZGVsIiwgTlVMTCks
Ci0JCQkiSUJNLExvbmdUcmFpbCIsIDEzKSkgeworCXJvb3QgPSBvZl9maW5kX25vZGVfYnlfcGF0
aCgiLyIpOworCWlmICghcm9vdCkKKwkJcmV0dXJuOworCisJbW9kZWwgPSBvZl9nZXRfcHJvcGVy
dHkocm9vdCwgIm1vZGVsIiwgTlVMTCk7CisJaWYgKG1vZGVsICYmICFzdHJuY21wKG1vZGVsLCJJ
Qk0sTG9uZ1RyYWlsIiwgMTMpKSB7CiAJCS8qIGxvZ2ljYWwgZGV2aWNlIDAgKEtCQy9LZXlib2Fy
ZCkgKi8KIAkJc2lvX2ZpeHVwX2lycSgia2V5Ym9hcmQiLCAwLCAxLCAyKTsKIAkJLyogc2VsZWN0
IGxvZ2ljYWwgZGV2aWNlIDEgKEtCQy9Nb3VzZSkgKi8KIAkJc2lvX2ZpeHVwX2lycSgibW91c2Ui
LCAxLCAxMiwgMik7CiAJfQorCiAJb2Zfbm9kZV9wdXQocm9vdCk7CiB9CiAK
------=_Part_19488_23666844.1195796584724--
