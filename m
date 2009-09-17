Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZIQR2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZIQR2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZIQR2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:28:00 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:63589 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbZIQR2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ZX+G+uRsp+PNQcVr4Qm5k1aasNR3811Lyr6+kAgpUhW1ObmgO2LG7YSJj/b6tTFGY9
         20zg9OoIiVb30hm9KnMTE3YWfpk9yQeEvOBS+f1Mx7uSv/0dEfkJVnHAi2a08D2/w5LM
         DCuCzKyHtIeuex36IT3jajexOB/WVv00W0ynY=
MIME-Version: 1.0
In-Reply-To: <39e348480909171025v21290799jc974c650b6c04379@mail.gmail.com>
References: <39e348480909171025v21290799jc974c650b6c04379@mail.gmail.com>
Date: Thu, 17 Sep 2009 12:28:02 -0500
Message-ID: <39e348480909171028id91fb7fsa721cf45805587ac@mail.gmail.com>
Subject: compiling 2.6.31, SMP with NR_CPUS == 1
From: GoatZilla <goatzilla@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00c09f9db14e760b090473c956e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00c09f9db14e760b090473c956e1
Content-Type: text/plain; charset=ISO-8859-1

I'm not sure if this is just me, or it's already been fixed, but in
include/linux/cpumask.h, if nr_cpu_ids is defined to "1", doesn't that
break init/main.c:368?

--00c09f9db14e760b090473c956e1
Content-Type: application/octet-stream; name="cpumask.patch"
Content-Disposition: attachment; filename="cpumask.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzprsecs0

LS0tIGNwdW1hc2suaAkxNCBTZXAgMjAwOSAyMzoxNDoxNCAtMDAwMAkxLjEuMS4xCisrKyBjcHVt
YXNrLmgJMTcgU2VwIDIwMDkgMTY6NTU6MDkgLTAwMDAKQEAgLTM5Niw3ICszOTYsOSBAQAogCiAj
aWYgTlJfQ1BVUyA9PSAxCiAKLSNkZWZpbmUgbnJfY3B1X2lkcwkJMQorLyogIFNlZSBpbml0L21h
aW4uYzozNjggICovCitleHRlcm4gaW50IG5yX2NwdV9pZHM7CisKICNpZm5kZWYgQ09ORklHX0RJ
U0FCTEVfT0JTT0xFVEVfQ1BVTUFTS19GVU5DVElPTlMKICNkZWZpbmUgZmlyc3RfY3B1KHNyYykJ
CSh7ICh2b2lkKShzcmMpOyAwOyB9KQogI2RlZmluZSBuZXh0X2NwdShuLCBzcmMpCSh7ICh2b2lk
KShzcmMpOyAxOyB9KQpAQCAtNDA2LDcgKzQwOCw2IEBACiAjZW5kaWYgLyogIUNPTkZJR19ESVNB
QkxFX09CU09MRVRFX0NQVU1BU0tfRlVOQ1RJT05TICovCiAjZWxzZSAvKiBOUl9DUFVTID4gMSAq
LwogCi1leHRlcm4gaW50IG5yX2NwdV9pZHM7CiAjaWZuZGVmIENPTkZJR19ESVNBQkxFX09CU09M
RVRFX0NQVU1BU0tfRlVOQ1RJT05TCiBpbnQgX19maXJzdF9jcHUoY29uc3QgY3B1bWFza190ICpz
cmNwKTsKIGludCBfX25leHRfY3B1KGludCBuLCBjb25zdCBjcHVtYXNrX3QgKnNyY3ApOwo=
--00c09f9db14e760b090473c956e1--
