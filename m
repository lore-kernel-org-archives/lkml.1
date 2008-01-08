Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYAHKgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYAHKgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYAHKf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:35:58 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:40593 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbYAHKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:35:57 -0500
X-Greylist: delayed 2759 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 05:35:56 EST
Message-Id: <20080108094956.610620186@nttdata.co.jp>
References: <20080108094903.484613061@nttdata.co.jp>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jan 2008 18:49:05 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #6 02/21] Add struct vfsmount to struct task_struct.
X-OriginalArrivalTime: 08 Jan 2008 09:49:57.0006 (UTC) 
    FILETIME=[D39D7AE0:01C851DB]
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="boundary-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--boundary-1
Content-Disposition: inline; 
    filename="add-struct-vfsmount-to-struct-task_struct.patch"
Content-Type: application/octect-stream
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBhbGxvd3MgVkZTIHdyYXBwZXIgZnVuY3Rpb25zIGFzc29jaWF0ZSAic3RydWN0
IHZmc21vdW50Ig0Kd2l0aCAic3RydWN0IHRhc2tfc3RydWN0IiBzbyB0aGF0IExTTSBob29rcyBj
YW4gY2FsY3VsYXRlDQpwYXRobmFtZSBvZiBnaXZlbiAic3RydWN0IGRlbnRyeSIuDQoNClNpZ25l
ZC1vZmYtYnk6IFRldHN1byBIYW5kYSA8cGVuZ3Vpbi1rZXJuZWxASS1sb3ZlLlNBS1VSQS5uZS5q
cD4NCi0tLQ0KIGluY2x1ZGUvbGludXgvaW5pdF90YXNrLmggfCAgICAxICsNCiBpbmNsdWRlL2xp
bnV4L3NjaGVkLmggICAgIHwgICAgMiArKw0KIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspDQoNCi0tLSBsaW51eC0yLjYtbW0ub3JpZy9pbmNsdWRlL2xpbnV4L2luaXRfdGFzay5oDQor
KysgbGludXgtMi42LW1tL2luY2x1ZGUvbGludXgvaW5pdF90YXNrLmgNCkBAIC0xODcsNiArMTg3
LDcgQEAgZXh0ZXJuIHN0cnVjdCBncm91cF9pbmZvIGluaXRfZ3JvdXBzOw0KIAkuZGlydGllcyA9
IElOSVRfUFJPUF9MT0NBTF9TSU5HTEUoZGlydGllcyksCQkJXA0KIAlJTklUX1RSQUNFX0lSUUZM
QUdTCQkJCQkJXA0KIAlJTklUX0xPQ0tERVAJCQkJCQkJXA0KKwkubGFzdF92ZnNtb3VudCAgPSBO
VUxMLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KIH0NCiANCiAN
Ci0tLSBsaW51eC0yLjYtbW0ub3JpZy9pbmNsdWRlL2xpbnV4L3NjaGVkLmgNCisrKyBsaW51eC0y
LjYtbW0vaW5jbHVkZS9saW51eC9zY2hlZC5oDQpAQCAtMTIzOCw2ICsxMjM4LDggQEAgc3RydWN0
IHRhc2tfc3RydWN0IHsNCiAJaW50IG1ha2VfaXRfZmFpbDsNCiAjZW5kaWYNCiAJc3RydWN0IHBy
b3BfbG9jYWxfc2luZ2xlIGRpcnRpZXM7DQorCS8qIHZmc21vdW50IGluZm8gZm9yIExTTSBob29r
cy4gKi8NCisJc3RydWN0IHZmc21vdW50ICpsYXN0X3Zmc21vdW50Ow0KIH07DQogDQogLyoNCg0K
LS0gDQo=

--boundary-1--
