Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbYBTBQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbYBTBQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbYBTBP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:15:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:17761 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbYBTBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:x-google-sender-auth;
        b=LTTI5BBhsTmodpwgMqu2pVjZlExxnZVyAyV7YhLePhnUGQt9fE+opeasaHUeB9jT4wbkSfYNMs0RJKfkOkF0Qr/ar0JXq9qVTFSNyyeTSvUBbjy0bfuv+5cfirr5x2nqi9RTlipYQ2CPvJDiSI8eex0fpezSI466eZnkvzayG3A=
Message-ID: <ff6a9c820802191715o1640cf9bu8dc0c1ff83d4ad55@mail.gmail.com>
Date: Wed, 20 Feb 2008 09:15:54 +0800
From: SDiZ <sdiz@sdiz.net>
To: "Marcel Holtmann" <marcel@holtmann.org>,
       "David Miller" <davem@davemloft.net>
Subject: [PATCH][BLUETOOTH] CONWISE Technology based adapters with buggy SCO support (bugzilla #9027)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_19036_15322957.1203470154559"
X-Google-Sender-Auth: cec721072de73b2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_19036_15322957.1203470154559
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

The attached patch (against current git head) fix the CONWISE
Technology based adapters with buggy SCO support issue (bugzilla
#9027)


Regrads,
Daniel Cheng (SDiZ)

------=_Part_19036_15322957.1203470154559
Content-Type: application/octet-stream;
 name=conwise-buggy-sco-support.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcv6zqhu0
Content-Disposition: attachment; filename=conwise-buggy-sco-support.patch

RnJvbSBhYzYzN2JlYjcxMDM3MmQ5YjFlZjFjNDcyZWEzYWQ1ODM1YzIwMzRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYW5pZWwgQ2hlbmcgKFNEaVopIDxzZGl6QHNkaXoubmV0PgpE
YXRlOiBXZWQsIDIwIEZlYiAyMDA4IDA5OjEwOjE2ICswODAwClN1YmplY3Q6IFtQQVRDSF0gQ09O
V0lTRSBUZWNobm9sb2d5IGJhc2VkIGFkYXB0ZXJzIHdpdGggYnVnZ3kgU0NPIHN1cHBvcnQKCi0t
LQogZHJpdmVycy9ibHVldG9vdGgvaGNpX3VzYi5jIHwgICAgMyArKysKIDEgZmlsZXMgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Ymx1ZXRvb3RoL2hjaV91c2IuYyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2hjaV91c2IuYwppbmRleCAz
NzJjN2VmLi40ZjhhNzQ0IDEwMDY0NAotLS0gYS9kcml2ZXJzL2JsdWV0b290aC9oY2lfdXNiLmMK
KysrIGIvZHJpdmVycy9ibHVldG9vdGgvaGNpX3VzYi5jCkBAIC0xNDgsNiArMTQ4LDkgQEAgc3Rh
dGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGJsYWNrbGlzdF9pZHNbXSA9IHsKIAl7IFVTQl9ERVZJ
Q0UoMHgwNDAwLCAweDA4MDcpLCAuZHJpdmVyX2luZm8gPSBIQ0lfQlJPS0VOX0lTT0MgfSwKIAl7
IFVTQl9ERVZJQ0UoMHgwNDAwLCAweDA4MGEpLCAuZHJpdmVyX2luZm8gPSBIQ0lfQlJPS0VOX0lT
T0MgfSwKIAorCS8qIENPTldJU0UgVGVjaG5vbG9neSBiYXNlZCBhZGFwdGVycyB3aXRoIGJ1Z2d5
IFNDTyBzdXBwb3J0ICovCisJeyBVU0JfREVWSUNFKDB4MGU1ZSwgMHg2NjIyKSwgLmRyaXZlcl9p
bmZvID0gSENJX0JST0tFTl9JU09DIH0sCisKIAkvKiBCZWxraW4gRjhUMDEyIGFuZCBGOFQwMTMg
ZGV2aWNlcyAqLwogCXsgVVNCX0RFVklDRSgweDA1MGQsIDB4MDAxMiksIC5kcml2ZXJfaW5mbyA9
IEhDSV9SRVNFVCB8IEhDSV9XUk9OR19TQ09fTVRVIH0sCiAJeyBVU0JfREVWSUNFKDB4MDUwZCwg
MHgwMDEzKSwgLmRyaXZlcl9pbmZvID0gSENJX1JFU0VUIHwgSENJX1dST05HX1NDT19NVFUgfSwK
LS0gCjEuNS40LjEKCg==
------=_Part_19036_15322957.1203470154559--
