Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbXCFEQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbXCFEQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 23:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXCFEQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 23:16:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:45581 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXCFEQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 23:16:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:x-google-sender-auth;
        b=tI2MTcmazV1hoEj7pyLXbqf4LQOfry9AwG38isQfFPBrdl6siM/KgbAM/whNxOJGgtnLmPOMT8Hccti+5Ie7MnlM+3QraRiiB44PlahHhqJPb95ncq2yC/EuBjmM+lwdG0F0rXY3+CZ6OWFFfC4ghfjFftdLtGi1gvRins6Nu8k=
Message-ID: <86802c440703052016rc7500cbn929fa94d623c2a1@mail.gmail.com>
Date: Mon, 5 Mar 2007 20:16:10 -0800
From: "Yinghai Lu" <yinghai.lu@amd.com>
To: ebiederm@xmission.com, "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH 1/2] x86_64 irq: remove extra smp_processor_id calling
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_172839_25553037.1173154570670"
X-Google-Sender-Auth: 204630101cf9567c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_172839_25553037.1173154570670
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

please check the patch

------=_Part_172839_25553037.1173154570670
Content-Type: text/x-patch; name=1_irq_move_clean.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_eyxtvw4v
Content-Disposition: attachment; filename="1_irq_move_clean.patch"

W1BBVENIIDEvMl0geDg2XzY0IGlycTogcmVtb3ZlIGV4dHJhIHNtcF9wcm9jZXNzb3JfaWQgY2Fs
bGluZwoKcmVtb3ZlIHRoZSBleHRyYSBzbXBfcHJvY2Vzc29yX2lkIGNhbGxpbmcuCgpTaWduZWQt
b2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpLmx1QGFtZC5jb20+IAoKZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2XzY0L2tlcm5lbC9pb19hcGljLmMgYi9hcmNoL3g4Nl82NC9rZXJuZWwvaW9fYXBpYy5j
CmluZGV4IGM2YTViYzcuLjMxOGQ5MDUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2XzY0L2tlcm5lbC9p
b19hcGljLmMKKysrIGIvYXJjaC94ODZfNjQva2VybmVsL2lvX2FwaWMuYwpAQCAtMTQwNyw4ICsx
NDA3LDcgQEAgc3RhdGljIHZvaWQgaXJxX2NvbXBsZXRlX21vdmUodW5zaWduZWQgaW50IGlycSkK
IAogCXZlY3RvciA9IH5nZXRfaXJxX3JlZ3MoKS0+b3JpZ19yYXg7CiAJbWUgPSBzbXBfcHJvY2Vz
c29yX2lkKCk7Ci0JaWYgKCh2ZWN0b3IgPT0gY2ZnLT52ZWN0b3IpICYmCi0JICAgIGNwdV9pc3Nl
dChzbXBfcHJvY2Vzc29yX2lkKCksIGNmZy0+ZG9tYWluKSkgeworCWlmICgodmVjdG9yID09IGNm
Zy0+dmVjdG9yKSAmJiBjcHVfaXNzZXQobWUsIGNmZy0+ZG9tYWluKSkgewogCQljcHVtYXNrX3Qg
Y2xlYW51cF9tYXNrOwogCiAJCWNwdXNfYW5kKGNsZWFudXBfbWFzaywgY2ZnLT5vbGRfZG9tYWlu
LCBjcHVfb25saW5lX21hcCk7Cg==
------=_Part_172839_25553037.1173154570670--
