Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbXDWMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbXDWMOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXDWMOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:14:14 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:22937 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbXDWMON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type:sender;
        b=H/+acgbtwuG42skVmS8gMcq34zut9p+BkyehCvbmKYYzdVZZ3SK+AchVaRtU8nYdFoMbEyOJ8n9hgxgFuIuup4dZ97lPqoq5Rnt0SXHpQ4Z9nLFWtQkFST6ZQGz7LxxbUTPHCWlxwxB8ps3x9+2uC+O44B4uZCPzhB55IS4N4zA=
Date: Mon, 23 Apr 2007 08:14:03 -0400 (EDT)
From: Parag Warudkar <pwarudkar@aol.com>
X-X-Sender: paragw@paragw-desktop
Reply-To: pwarudkar@aol.com
To: pwarudkar@aol.com
cc: Jiri Kosina <jikos@jikos.cz>, Andrew Morton <akpm@linux-foundation.org>,
       dsk6@pitt.edu, linux-kernel@vger.kernel.org
Subject: Re: Sleep during spinlock in TPM driver
In-Reply-To: <alpine.DEB.0.82.0704230801230.6240@paragw-desktop>
Message-ID: <Pine.LNX.4.64.0704230809080.6722@paragw-desktop>
References: <alpine.DEB.0.82.0704221505370.14039@paragw-desktop>
 <Pine.LNX.4.64.0704230941390.20657@twin.jikos.cz>
 <alpine.DEB.0.82.0704230801230.6240@paragw-desktop>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1461978870-1177330443=:6722"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1461978870-1177330443=:6722
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


Grrrr.. My email client was at it again. Sorry it messed up with the 
additonal + again.

Do not use Alpine - This is the first email client (alphas and betas 
included) which is buggy enough to change what you write!

Not taking chances this time - patch attached.

Parag

--8323329-1461978870-1177330443=:6722
Content-Type: TEXT/x-diff; charset=US-ASCII; name=tpm.c.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0704230814030.6722@paragw-desktop>
Content-Description: 
Content-Disposition: attachment; filename=tpm.c.patch

LS0tIGxpbnV4LTIuNi11cy9kcml2ZXJzL2NoYXIvdHBtL3RwbS5jCTIwMDct
MDQtMjEgMTQ6NTU6MDMuMTM0OTc1MzYwIC0wNDAwDQorKysgbGludXgtMi42
LXdrL2RyaXZlcnMvY2hhci90cG0vdHBtLmMJMjAwNy0wNC0yMiAxNDo1ODo1
MS45NTc5OTk5NjMgLTA0MDANCkBAIC05NDIsMTIgKzk0MiwxMiBAQA0KIHsN
CiAJc3RydWN0IHRwbV9jaGlwICpjaGlwID0gZmlsZS0+cHJpdmF0ZV9kYXRh
Ow0KIA0KKwlmbHVzaF9zY2hlZHVsZWRfd29yaygpOw0KIAlzcGluX2xvY2so
JmRyaXZlcl9sb2NrKTsNCiAJZmlsZS0+cHJpdmF0ZV9kYXRhID0gTlVMTDsN
Ci0JY2hpcC0+bnVtX29wZW5zLS07DQogCWRlbF9zaW5nbGVzaG90X3RpbWVy
X3N5bmMoJmNoaXAtPnVzZXJfcmVhZF90aW1lcik7DQotCWZsdXNoX3NjaGVk
dWxlZF93b3JrKCk7DQogCWF0b21pY19zZXQoJmNoaXAtPmRhdGFfcGVuZGlu
ZywgMCk7DQorCWNoaXAtPm51bV9vcGVucy0tOw0KIAlwdXRfZGV2aWNlKGNo
aXAtPmRldik7DQogCWtmcmVlKGNoaXAtPmRhdGFfYnVmZmVyKTsNCiAJc3Bp
bl91bmxvY2soJmRyaXZlcl9sb2NrKTsNCkBAIC0xMDk3LDggKzEwOTcsMTMg
QEANCiANCiAJLyogRHJpdmVyIHNwZWNpZmljIHBlci1kZXZpY2UgZGF0YSAq
Lw0KIAljaGlwID0ga3phbGxvYyhzaXplb2YoKmNoaXApLCBHRlBfS0VSTkVM
KTsNCi0JaWYgKGNoaXAgPT0gTlVMTCkNCisJZGV2bmFtZSA9IGttYWxsb2Mo
REVWTkFNRV9TSVpFLCBHRlBfS0VSTkVMKTsNCisJDQorCWlmIChjaGlwID09
IE5VTEwgfHwgZGV2bmFtZSA9PSBOVUxMKSB7DQorCQlrZnJlZShjaGlwKTsN
CisJCWtmcmVlKGRldm5hbWUpOw0KIAkJcmV0dXJuIE5VTEw7DQorCX0NCiAN
CiAJaW5pdF9NVVRFWCgmY2hpcC0+YnVmZmVyX211dGV4KTsNCiAJaW5pdF9N
VVRFWCgmY2hpcC0+dHBtX211dGV4KTsNCkBAIC0xMTI0LDcgKzExMjksNiBA
QA0KIA0KIAlzZXRfYml0KGNoaXAtPmRldl9udW0sIGRldl9tYXNrKTsNCiAN
Ci0JZGV2bmFtZSA9IGttYWxsb2MoREVWTkFNRV9TSVpFLCBHRlBfS0VSTkVM
KTsNCiAJc2NucHJpbnRmKGRldm5hbWUsIERFVk5BTUVfU0laRSwgIiVzJWQi
LCAidHBtIiwgY2hpcC0+ZGV2X251bSk7DQogCWNoaXAtPnZlbmRvci5taXNj
ZGV2Lm5hbWUgPSBkZXZuYW1lOw0KIA0K

--8323329-1461978870-1177330443=:6722--
