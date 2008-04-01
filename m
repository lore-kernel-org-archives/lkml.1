Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYDALeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYDALeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758477AbYDALd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:33:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:62361 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbYDALd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=hwB5dCf4If3p94IMhHlMllsp/QOdu9QJpuGVWUrrFfGs5KBXg4MOJ71eHumjKwRXQmE4htnD6pbpTr2WvPCl6VvCd//1qRMgRsvLk6xo37dEQvzufUWGDfK8Ntdurfav3yFeQGFYeXXjzarOF+DpEf/k2SR7OVA84OZnfqwhuck=
Message-ID: <eb3ff54b0804010433v67f0ea60w4681b3a3400c3484@mail.gmail.com>
Date: Tue, 1 Apr 2008 14:33:54 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-2.6.26] [IPV6] Remove three method declarations in include/net/ndisc.h.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13238_10317193.1207049634727"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13238_10317193.1207049634727
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
This patch removes two unused method declarations in include/net/ndisc.h:
ndisc_forwarding_on(void) and  ndisc_forwarding_off(void);
Also igmp6_cleanup(void) appears twice in this header, so one
igmp6_cleanup(void)
declaration is removed.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_13238_10317193.1207049634727
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_feicv8ac0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L25kaXNjLmggYi9pbmNsdWRlL25ldC9uZGlzYy5oCmlu
ZGV4IDVhZWRmMzIuLjBjMzJkNDMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L25kaXNjLmgKKysr
IGIvaW5jbHVkZS9uZXQvbmRpc2MuaApAQCAtOTMsOSArOTMsNiBAQCBleHRlcm4gdm9pZAkJCW5k
aXNjX3NlbmRfcnMoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwKIAkJCQkJICAgICAgc3RydWN0IGlu
Nl9hZGRyICpzYWRkciwKIAkJCQkJICAgICAgc3RydWN0IGluNl9hZGRyICpkYWRkcik7CiAKLWV4
dGVybiB2b2lkCQkJbmRpc2NfZm9yd2FyZGluZ19vbih2b2lkKTsKLWV4dGVybiB2b2lkCQkJbmRp
c2NfZm9yd2FyZGluZ19vZmYodm9pZCk7Ci0KIGV4dGVybiB2b2lkCQkJbmRpc2Nfc2VuZF9yZWRp
cmVjdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCQkJCQkJICAgIHN0cnVjdCBuZWlnaGJvdXIgKm5l
aWdoLAogCQkJCQkJICAgIHN0cnVjdCBpbjZfYWRkciAqdGFyZ2V0KTsKQEAgLTExNSw3ICsxMTIs
NiBAQCBleHRlcm4gaW50CQkJaWdtcDZfZXZlbnRfcXVlcnkoc3RydWN0IHNrX2J1ZmYgKnNrYik7
CiAKIGV4dGVybiBpbnQJCQlpZ21wNl9ldmVudF9yZXBvcnQoc3RydWN0IHNrX2J1ZmYgKnNrYik7
CiAKLWV4dGVybiB2b2lkCQkJaWdtcDZfY2xlYW51cCh2b2lkKTsKIAogI2lmZGVmIENPTkZJR19T
WVNDVEwKIGV4dGVybiBpbnQgCQkJbmRpc2NfaWZpbmZvX3N5c2N0bF9jaGFuZ2Uoc3RydWN0IGN0
bF90YWJsZSAqY3RsLAo=
------=_Part_13238_10317193.1207049634727--
