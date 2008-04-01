Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYDASpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYDASpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYDASpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:45:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYDASpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=MOUToBv1Oomlm7vBnJsnDm78sFnvybXZstBsFJLXoK+XTJgbUUkjGJqCuWM5iHRgS4w87B9aLIC5QhJj9crzas+ZjNczXlq6a1qAHNd7zItCnMVa0+NnjuBHjAMsDsaiA+IBH0KsmNfStCAb19r+d2dqg4z2vwQYryZxALFDN/w=
Message-ID: <eb3ff54b0804011145na2b25bdo4cbe7f45457b1e1c@mail.gmail.com>
Date: Tue, 1 Apr 2008 21:45:15 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] [net-2.6.26] [IPV6] Remove unused declarations in include/net/ip6_route.h.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14624_24266337.1207075515184"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14624_24266337.1207075515184
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
  This patches removes unused declarations in include/net/ip6_route.h
	
	1) Standlaone ip6_null_entry is no longer needed as it is replaced by
	the ip6_null_entry member of ipv6 (instance of struct netns_ipv6)	in
	struct net (as a result of Network Namespaces patches).
	
	
	2) These 3 methods from this same header are not defined anywhere:
	   ip6_rt_addr_add(), ip6_rt_addr_del(), rt6_sndmsg()

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_14624_24266337.1207075515184
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_feitjs0a0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2lwNl9yb3V0ZS5oIGIvaW5jbHVkZS9uZXQvaXA2X3Jv
dXRlLmgKaW5kZXggM2FlNjc5OS4uOTA4MDA3NiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvaXA2
X3JvdXRlLmgKKysrIGIvaW5jbHVkZS9uZXQvaXA2X3JvdXRlLmgKQEAgLTM3LDcgKzM3LDYgQEAg
c3RydWN0IHJvdXRlX2luZm8gewogI2RlZmluZSBSVDZfTE9PS1VQX0ZfU1JDUFJFRl9QVUJMSUMJ
MHgwMDAwMDAxMAogI2RlZmluZSBSVDZfTE9PS1VQX0ZfU1JDUFJFRl9DT0EJMHgwMDAwMDAyMAog
Ci1leHRlcm4gc3RydWN0IHJ0Nl9pbmZvCSppcDZfbnVsbF9lbnRyeTsKIAogI2lmZGVmIENPTkZJ
R19JUFY2X01VTFRJUExFX1RBQkxFUwogZXh0ZXJuIHN0cnVjdCBydDZfaW5mbwkqaXA2X3Byb2hp
Yml0X2VudHJ5OwpAQCAtNjEsMjAgKzYwLDYgQEAgZXh0ZXJuIGludAkJCWlwNl9yb3V0ZV9hZGQo
c3RydWN0IGZpYjZfY29uZmlnICpjZmcpOwogZXh0ZXJuIGludAkJCWlwNl9pbnNfcnQoc3RydWN0
IHJ0Nl9pbmZvICopOwogZXh0ZXJuIGludAkJCWlwNl9kZWxfcnQoc3RydWN0IHJ0Nl9pbmZvICop
OwogCi1leHRlcm4gaW50CQkJaXA2X3J0X2FkZHJfYWRkKHN0cnVjdCBpbjZfYWRkciAqYWRkciwK
LQkJCQkJCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYsCi0JCQkJCQlpbnQgYW55Y2FzdCk7Ci0KLWV4
dGVybiBpbnQJCQlpcDZfcnRfYWRkcl9kZWwoc3RydWN0IGluNl9hZGRyICphZGRyLAotCQkJCQkJ
c3RydWN0IG5ldF9kZXZpY2UgKmRldik7Ci0KLWV4dGVybiB2b2lkCQkJcnQ2X3NuZG1zZyhpbnQg
dHlwZSwgc3RydWN0IGluNl9hZGRyICpkc3QsCi0JCQkJCSAgIHN0cnVjdCBpbjZfYWRkciAqc3Jj
LAotCQkJCQkgICBzdHJ1Y3QgaW42X2FkZHIgKmd3LAotCQkJCQkgICBzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2LCAKLQkJCQkJICAgaW50IGRzdGxlbiwgaW50IHNyY2xlbiwKLQkJCQkJICAgaW50IG1l
dHJpYywgX191MzIgZmxhZ3MpOwotCiBleHRlcm4gc3RydWN0IHJ0Nl9pbmZvCQkqcnQ2X2xvb2t1
cChzdHJ1Y3QgbmV0ICpuZXQsCiAJCQkJCSAgICBzdHJ1Y3QgaW42X2FkZHIgKmRhZGRyLAogCQkJ
CQkgICAgc3RydWN0IGluNl9hZGRyICpzYWRkciwK
------=_Part_14624_24266337.1207075515184--
