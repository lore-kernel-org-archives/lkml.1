Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXLLFUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXLLFUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXLLFUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:20:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:38083 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXLLFUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=gliQ7SBXOr97Pf+iMgbvm3majSF5DPOfaIc8ztDcwBdTrksp3xmzkoCpqSTAoJ1E2x4siVVoyOUOVw7O1tTy8p0w5dyCKsIjyum8SaOKc2Ka0aHSwQ58YRY9+AuKNGxkCYfsZvezzKHpHCFYtlfG1yGCqvEu63g8Tuvh6ZB0tA8=
Message-ID: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
Date: Wed, 12 Dec 2007 00:20:31 -0500
From: Shane <gnome42@gmail.com>
To: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
Subject: 2.6.24-rc5 "videobuf_read_start" [drivers/media/video/videobuf-dvb.ko] undefined!
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_31847_1643833.1197436831247"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_31847_1643833.1197436831247
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

In 2.6.24-rc5+, I hit this problem with videobuf_read_start
not being exported. Patch attached, only compile tested.

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC [M]  drivers/media/video/videobuf-core.o
  Building modules, stage 2.
Kernel: arch/x86/boot/bzImage is ready  (#1)
  MODPOST 202 modules
ERROR: "videobuf_read_start" [drivers/media/video/videobuf-dvb.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Shane

------=_Part_31847_1643833.1197436831247
Content-Type: text/plain; name=videobuf_core_export_sym.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fa3d9jmf0
Content-Disposition: attachment; filename=videobuf_core_export_sym.diff

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vdmlkZW9idWYtY29yZS5jIGIvZHJpdmVy
cy9tZWRpYS92aWRlby92aWRlb2J1Zi1jb3JlLmMKaW5kZXggZGUyZjU2Yi4uNDRmYTc2YiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby92aWRlb2J1Zi1jb3JlLmMKKysrIGIvZHJpdmVy
cy9tZWRpYS92aWRlby92aWRlb2J1Zi1jb3JlLmMKQEAgLTEwNTgsNiArMTA1OCw3IEBAIEVYUE9S
VF9TWU1CT0xfR1BMKHZpZGVvYnVmX2RxYnVmKTsKIEVYUE9SVF9TWU1CT0xfR1BMKHZpZGVvYnVm
X3N0cmVhbW9uKTsKIEVYUE9SVF9TWU1CT0xfR1BMKHZpZGVvYnVmX3N0cmVhbW9mZik7CiAKK0VY
UE9SVF9TWU1CT0xfR1BMKHZpZGVvYnVmX3JlYWRfc3RhcnQpOwogRVhQT1JUX1NZTUJPTF9HUEwo
dmlkZW9idWZfcmVhZF9zdG9wKTsKIEVYUE9SVF9TWU1CT0xfR1BMKHZpZGVvYnVmX3N0b3ApOwog
RVhQT1JUX1NZTUJPTF9HUEwodmlkZW9idWZfcmVhZF9zdHJlYW0pOwo=
------=_Part_31847_1643833.1197436831247--
