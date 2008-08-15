Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYHOP5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYHOP5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbYHOP5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:57:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:46689 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760298AbYHOP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=v7gsouj9HxeN4ecU0amzhpNrdLbeC/5vWZE9Dun0BKLlyn0qJqDwPDyiT2liPEjEc7
         oci2zH9pWMvfBnax3r0n7fN/7gWH+V8ndgoc1QTVaftXX0dZ0Gt7WyAP8m3fuQkeROKb
         NrDj1uLuF5It4Q54uUVZ82mRgYFJfEG7sUwok=
Message-ID: <520f0cf10808150857u5803d86cj205e671f640c81c4@mail.gmail.com>
Date: Fri, 15 Aug 2008 17:57:32 +0200
From: "John Kacur" <jkacur@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH] Compile problems in locking-selftest.c with CONFIG_DEBUG_PREEMPT
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2674_4995668.1218815852547"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2674_4995668.1218815852547
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patch fixes the following compiler error in the rt-kernel
if CONFIG_DEBUG_PREEMPT is enabled.

lib/locking-selftest.c: In function 'dotest':
lib/locking-selftest.c:951: error: incompatible types in initialization
lib/locking-selftest.c:1003: error: incompatible types in assignment

------=_Part_2674_4995668.1218815852547
Content-Type: text/x-patch; name=locking-selftest-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjwzea8f0
Content-Disposition: attachment; filename=locking-selftest-fix.patch

U3ViamVjdDogQ29tcGlsZSBwcm9ibGVtcyBpbiBsb2NraW5nLXNlbGZ0ZXN0LmMgd2l0aCBDT05G
SUdfREVCVUdfUFJFRU1QVAoKbGliL2xvY2tpbmctc2VsZnRlc3QuYzogSW4gZnVuY3Rpb24g4oCY
ZG90ZXN04oCZOgpsaWIvbG9ja2luZy1zZWxmdGVzdC5jOjk1MTogZXJyb3I6IGluY29tcGF0aWJs
ZSB0eXBlcyBpbiBpbml0aWFsaXphdGlvbgpsaWIvbG9ja2luZy1zZWxmdGVzdC5jOjEwMDM6IGVy
cm9yOiBpbmNvbXBhdGlibGUgdHlwZXMgaW4gYXNzaWdubWVudAoKU2lnbmVkLW9mZi1ieTogSm9o
biBLYWN1ciA8amthY3VyIGF0IGdtYWlsIGRvdCBjb20+CgpJbmRleDogbGludXgtMi42LjI2LjEt
cnQxLmprL2xpYi9sb2NraW5nLXNlbGZ0ZXN0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LjI2
LjEtcnQxLmprLm9yaWcvbGliL2xvY2tpbmctc2VsZnRlc3QuYworKysgbGludXgtMi42LjI2LjEt
cnQxLmprL2xpYi9sb2NraW5nLXNlbGZ0ZXN0LmMKQEAgLTk0OCw3ICs5NDgsNyBAQCBzdGF0aWMg
dm9pZCBkb3Rlc3Qodm9pZCAoKnRlc3RjYXNlX2ZuKSh2CiAJdW5zaWduZWQgbG9uZyBzYXZlZF9w
cmVlbXB0X2NvdW50ID0gcHJlZW1wdF9jb3VudCgpOwogCWludCBleHBlY3RlZF9mYWlsdXJlID0g
MDsKICNpZiBkZWZpbmVkKENPTkZJR19ERUJVR19QUkVFTVBUKSAmJiBkZWZpbmVkKENPTkZJR19E
RUJVR19SVF9NVVRFWEVTKQotICAgICAgICBpbnQgc2F2ZWRfbG9ja19jb3VudCA9IGN1cnJlbnQt
PmxvY2tfY291bnQ7CisgICAgICAgIGF0b21pY190IHNhdmVkX2xvY2tfY291bnQgPSBjdXJyZW50
LT5sb2NrX2NvdW50OwogI2VuZGlmCiAKIAlXQVJOX09OKGlycXNfZGlzYWJsZWQoKSk7Cg==
------=_Part_2674_4995668.1218815852547--
