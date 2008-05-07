Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbYEGPPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbYEGPPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYEGPPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:15:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:19471 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYEGPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Y4ajvpAcOPuQ3+i5AAaJUimEvzahYoNsOo/B5e93aFRh220ZkZwXfD+fBEpFQ09RKK55aO0L9qFf2JyHPxutTuqF5ZwXvxO8uFAapy4nt2hsqEgYAECi+MHtRFwakRP8CB6hRAKV/xjEMIHs4ljoUb8zXhmTgLY+qKy2VCbWQBY=
Message-ID: <6101e8c40805070815g68d8139fn61b7f923021a2f16@mail.gmail.com>
Date: Wed, 7 May 2008 17:15:13 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [OP] v2.6.22.23-op1
Cc: "Jeff Moyer" <jmoyer@redhat.com>, "Al Viro" <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16063_32980000.1210173313100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16063_32980000.1210173313100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I announced the v2.6.22.23-op1 "stable" kernel.

 gitweb:          http://repo.or.cz/w/linux-2.6.22.y-op.git
 git-tree:        git://repo.or.cz/linux-2.6.22.y-op.git
 patches-gitweb : http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
 tar-bz2: http://students.zipernowsky.hu/~oliverp/kernel-stable/v2.6.22.23-op1.tar.bz2
 patch: http://students.zipernowsky.hu/~oliverp/kernel-stable/patch-v2.6.22.23-op1.bz2
 incr-patch: http://students.zipernowsky.hu/~oliverp/kernel-stable/incr/patch-v2.6.22.22-op1-v2.6.22.23-op1.bz2
 chlog:  http://students.zipernowsky.hu/~oliverp/kernel-stable/chlog-v2.6.22.23-op1

---
Al Viro (1):
      fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)

Jeff Moyer (1):
      aio: only account I/O wait time in read_events if there are active request

Oliver Pinter (1):
      v2.6.22.23-op1

---
 Makefile   |    2 +-
 fs/aio.c   |    7 ++++++-
 fs/locks.c |   17 +++++++++++++++--
 3 files changed, 22 insertions(+), 4 deletions(-)

-- 
Thanks,
Oliver

------=_Part_16063_32980000.1210173313100
Content-Type: text/x-diff; name=patch-v2.6.22.22-op1-v2.6.22.23-op1
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=patch-v2.6.22.22-op1-v2.6.22.23-op1

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggNzIwMDE2MC4uZDAwMTk1OSAx
MDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAgLTEsNyArMSw3IEBACiBWRVJT
SU9OID0gMgogUEFUQ0hMRVZFTCA9IDYKIFNVQkxFVkVMID0gMjIKLUVYVFJBVkVSU0lPTiA9IC4y
Mi1vcDEKK0VYVFJBVkVSU0lPTiA9IC4yMy1vcDEKIE5BTUUgPSBIb2x5IERhbmNpbmcgTWFuYXRl
ZXMsIEJhdG1hbiEKIAogIyAqRE9DVU1FTlRBVElPTioKZGlmZiAtLWdpdCBhL2ZzL2Fpby5jIGIv
ZnMvYWlvLmMKaW5kZXggYjM0MTljNS4uZTY4M2I5MSAxMDA2NDQKLS0tIGEvZnMvYWlvLmMKKysr
IGIvZnMvYWlvLmMKQEAgLTExNzEsNyArMTE3MSwxMiBAQCByZXRyeToKIAkJCXJldCA9IDA7CiAJ
CQlpZiAodG8udGltZWRfb3V0KQkvKiBPbmx5IGNoZWNrIGFmdGVyIHJlYWQgZXZ0ICovCiAJCQkJ
YnJlYWs7Ci0JCQlpb19zY2hlZHVsZSgpOworCQkJLyogVHJ5IHRvIG9ubHkgc2hvdyB1cCBpbiBp
byB3YWl0IGlmIHRoZXJlIGFyZSBvcHMKKwkJCSAqICBpbiBmbGlnaHQgKi8KKwkJCWlmIChjdHgt
PnJlcXNfYWN0aXZlKQorCQkJCWlvX3NjaGVkdWxlKCk7CisJCQllbHNlCisJCQkJc2NoZWR1bGUo
KTsKIAkJCWlmIChzaWduYWxfcGVuZGluZyh0c2spKSB7CiAJCQkJcmV0ID0gLUVJTlRSOwogCQkJ
CWJyZWFrOwpkaWZmIC0tZ2l0IGEvZnMvbG9ja3MuYyBiL2ZzL2xvY2tzLmMKaW5kZXggNjQyODYw
NS4uZTZkNGMzYiAxMDA2NDQKLS0tIGEvZnMvbG9ja3MuYworKysgYi9mcy9sb2Nrcy5jCkBAIC0x
NzMzLDYgKzE3MzMsNyBAQCBpbnQgZmNudGxfc2V0bGsodW5zaWduZWQgaW50IGZkLCBzdHJ1Y3Qg
ZmlsZSAqZmlscCwgdW5zaWduZWQgaW50IGNtZCwKIAlzdHJ1Y3QgZmlsZV9sb2NrICpmaWxlX2xv
Y2sgPSBsb2Nrc19hbGxvY19sb2NrKCk7CiAJc3RydWN0IGZsb2NrIGZsb2NrOwogCXN0cnVjdCBp
bm9kZSAqaW5vZGU7CisJc3RydWN0IGZpbGUgKmY7CiAJaW50IGVycm9yOwogCiAJaWYgKGZpbGVf
bG9jayA9PSBOVUxMKQpAQCAtMTgwMyw3ICsxODA0LDE1IEBAIGFnYWluOgogCSAqIEF0dGVtcHQg
dG8gZGV0ZWN0IGEgY2xvc2UvZmNudGwgcmFjZSBhbmQgcmVjb3ZlciBieQogCSAqIHJlbGVhc2lu
ZyB0aGUgbG9jayB0aGF0IHdhcyBqdXN0IGFjcXVpcmVkLgogCSAqLwotCWlmICghZXJyb3IgJiYg
ZmNoZWNrKGZkKSAhPSBmaWxwICYmIGZsb2NrLmxfdHlwZSAhPSBGX1VOTENLKSB7CisJLyoKKwkg
KiB3ZSBuZWVkIHRoYXQgc3Bpbl9sb2NrIGhlcmUgLSBpdCBwcmV2ZW50cyByZW9yZGVyaW5nIGJl
dHdlZW4KKwkgKiB1cGRhdGUgb2YgaW5vZGUtPmlfZmxvY2sgYW5kIGNoZWNrIGZvciBpdCBkb25l
IGluIGNsb3NlKCkuCisJICogcmN1X3JlYWRfbG9jaygpIHdvdWxkbid0IGRvLgorCSAqLworCXNw
aW5fbG9jaygmY3VycmVudC0+ZmlsZXMtPmZpbGVfbG9jayk7CisJZiA9IGZjaGVjayhmZCk7CisJ
c3Bpbl91bmxvY2soJmN1cnJlbnQtPmZpbGVzLT5maWxlX2xvY2spOworCWlmICghZXJyb3IgJiYg
ZiAhPSBmaWxwICYmIGZsb2NrLmxfdHlwZSAhPSBGX1VOTENLKSB7CiAJCWZsb2NrLmxfdHlwZSA9
IEZfVU5MQ0s7CiAJCWdvdG8gYWdhaW47CiAJfQpAQCAtMTg1OSw2ICsxODY4LDcgQEAgaW50IGZj
bnRsX3NldGxrNjQodW5zaWduZWQgaW50IGZkLCBzdHJ1Y3QgZmlsZSAqZmlscCwgdW5zaWduZWQg
aW50IGNtZCwKIAlzdHJ1Y3QgZmlsZV9sb2NrICpmaWxlX2xvY2sgPSBsb2Nrc19hbGxvY19sb2Nr
KCk7CiAJc3RydWN0IGZsb2NrNjQgZmxvY2s7CiAJc3RydWN0IGlub2RlICppbm9kZTsKKwlzdHJ1
Y3QgZmlsZSAqZjsKIAlpbnQgZXJyb3I7CiAKIAlpZiAoZmlsZV9sb2NrID09IE5VTEwpCkBAIC0x
OTI5LDcgKzE5MzksMTAgQEAgYWdhaW46CiAJICogQXR0ZW1wdCB0byBkZXRlY3QgYSBjbG9zZS9m
Y250bCByYWNlIGFuZCByZWNvdmVyIGJ5CiAJICogcmVsZWFzaW5nIHRoZSBsb2NrIHRoYXQgd2Fz
IGp1c3QgYWNxdWlyZWQuCiAJICovCi0JaWYgKCFlcnJvciAmJiBmY2hlY2soZmQpICE9IGZpbHAg
JiYgZmxvY2subF90eXBlICE9IEZfVU5MQ0spIHsKKwlzcGluX2xvY2soJmN1cnJlbnQtPmZpbGVz
LT5maWxlX2xvY2spOworCWYgPSBmY2hlY2soZmQpOworCXNwaW5fdW5sb2NrKCZjdXJyZW50LT5m
aWxlcy0+ZmlsZV9sb2NrKTsKKwlpZiAoIWVycm9yICYmIGYgIT0gZmlscCAmJiBmbG9jay5sX3R5
cGUgIT0gRl9VTkxDSykgewogCQlmbG9jay5sX3R5cGUgPSBGX1VOTENLOwogCQlnb3RvIGFnYWlu
OwogCX0K
------=_Part_16063_32980000.1210173313100--
