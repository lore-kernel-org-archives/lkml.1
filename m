Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYJBOBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYJBOBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 10:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYJBOBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 10:01:25 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:52374 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYJBOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 10:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=j7vvnLmNZ0ocyBby53uSwPxicuXV7kH8ZCaiI9bE0oOLLSkzp3GvsValV/Dulqo5s9
         ZswxsG4IpkVbJp4k+NwZAZEYXgucV5K4eBrvymniXJmZJUk3OgF9wrIpzIR6z0zD2FaB
         IIKadlMEBJt6xQVbX+v/YbWExjlIIxcIocxfw=
Message-ID: <b647ffbd0810020701l60ee69fx9360baa5a4b855e8@mail.gmail.com>
Date: Thu, 2 Oct 2008 17:01:22 +0300
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: sleeping function called from invalid context at kernel/mutex.c
Cc: "Peter Oruba" <peter.oruba@amd.com>, "Sitsofe Wheeler" <sitsofe@yahoo.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0810020659j2e5d38c2v51847000de682492@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4727_11034263.1222956082621"
References: <48E25B25.10408@yahoo.com> <20081001071004.GA9366@elte.hu>
	 <b647ffbd0810020029v1fd59d85u8d8048aebe3e4d55@mail.gmail.com>
	 <48E4882E.5000100@amd.com> <20081002085529.GB3550@elte.hu>
	 <b647ffbd0810020656l48eba7bdt8cd8e4cd47a8a95b@mail.gmail.com>
	 <b647ffbd0810020659j2e5d38c2v51847000de682492@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4727_11034263.1222956082621
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

err... I appologize for spamming. I've forgot to attach the fix.

>
>
>  On 02/10/2008, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>  > On 02/10/2008, Ingo Molnar <mingo@elte.hu> wrote:
>  >  >
>  >  >  * Peter Oruba <peter.oruba@amd.com> wrote:
>  >  >
>  >  >  > microcode_update_cpu() is still there, being called from
>  >  >  > microcode_init_cpu() and mc_sysdev_resume().
>  >  >
>  >  >
>  >  > ah, microcode_update_cpu, not update_microcode_cpu. So yes, the problem
>  >  >  is still there with the latest code.
>  >
>
>  Right, I've been looking at the wrong tree. Please find the fix
>  enclosed. Compiles ok, shouldn't break anything else.
>
>   >
>   >         Ingo
>   >
>
>
>
>  --
>  Best regards,
>  Dmitry Adamushko
>


-- 
Best regards,
Dmitry Adamushko

------=_Part_4727_11034263.1222956082621
Content-Type: application/octet-stream; name=ucode-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fltgfscn
Content-Disposition: attachment; filename=ucode-fix.patch

ClN1YmplY3Q6IHg4Ni1taWNyb2NvZGU6IHVwZGF0ZSBsb2NraW5nIHNjaGVtZQoKRml4IHRoZSBm
b2xsb3dpbmcgInNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFsaWQgY29udGV4dCIg
d2FybmluZzoKCi4uLgpfX21pZ2h0X3NsZWVwCm11dGV4X2xvY2tfbmVzdGVkCm1pY3JvY29kZV91
cGRhdGVfY3B1Cm1jX3N5c2Rldl9yZXN1bWUKX19zeXNkZXZfcmVzdW1lCnN5c2Rldl9yZXN1bWUK
ZGV2aWNlX3Bvd2VyX3VwCi4uLgoKU2lnbmVkLW9mZi1ieTogRG1pdHJ5IEFkYW11c2hrbyA8ZG1p
dHJ5LmFkYW11c2hrb0BnbWFpbC5jb20+CgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL21p
Y3JvY29kZV9jb3JlLmMgYi9hcmNoL3g4Ni9rZXJuZWwvbWljcm9jb2RlX2NvcmUuYwppbmRleCA4
ZGIyZWI1Li45MzZkOGQ1IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbWljcm9jb2RlX2Nv
cmUuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvbWljcm9jb2RlX2NvcmUuYwpAQCAtMzI0LDEwICsz
MjQsNiBAQCB2b2lkIG1pY3JvY29kZV91cGRhdGVfY3B1KGludCBjcHUpCiAJc3RydWN0IHVjb2Rl
X2NwdV9pbmZvICp1Y2kgPSB1Y29kZV9jcHVfaW5mbyArIGNwdTsKIAlpbnQgZXJyID0gMDsKIAot
CS8qIFdlIHNob3VsZCBiaW5kIHRoZSB0YXNrIHRvIHRoZSBDUFUgKi8KLQlCVUdfT04ocmF3X3Nt
cF9wcm9jZXNzb3JfaWQoKSAhPSBjcHUpOwotCi0JbXV0ZXhfbG9jaygmbWljcm9jb2RlX211dGV4
KTsKIAkvKgogCSAqIENoZWNrIGlmIHRoZSBzeXN0ZW0gcmVzdW1lIGlzIGluIHByb2dyZXNzICh1
Y2ktPnZhbGlkICE9IE5VTEwpLAogCSAqIG90aGVyd2lzZSBqdXN0IHJlcXVlc3QgYSBmaXJtd2Fy
ZToKQEAgLTM0MCwxMSArMzM2LDggQEAgdm9pZCBtaWNyb2NvZGVfdXBkYXRlX2NwdShpbnQgY3B1
KQogCQkJZXJyID0gbWljcm9jb2RlX29wcy0+cmVxdWVzdF9taWNyb2NvZGVfZncoY3B1LAogCQkJ
CQkmbWljcm9jb2RlX3BkZXYtPmRldik7CiAJfQotCiAJaWYgKCFlcnIpCiAJCW1pY3JvY29kZV9v
cHMtPmFwcGx5X21pY3JvY29kZShjcHUpOwotCi0JbXV0ZXhfdW5sb2NrKCZtaWNyb2NvZGVfbXV0
ZXgpOwogfQogCiBzdGF0aWMgdm9pZCBtaWNyb2NvZGVfaW5pdF9jcHUoaW50IGNwdSkKQEAgLTM1
Miw3ICszNDUsMTMgQEAgc3RhdGljIHZvaWQgbWljcm9jb2RlX2luaXRfY3B1KGludCBjcHUpCiAJ
Y3B1bWFza190IG9sZCA9IGN1cnJlbnQtPmNwdXNfYWxsb3dlZDsKIAogCXNldF9jcHVzX2FsbG93
ZWRfcHRyKGN1cnJlbnQsICZjcHVtYXNrX29mX2NwdShjcHUpKTsKKwkvKiBXZSBzaG91bGQgYmlu
ZCB0aGUgdGFzayB0byB0aGUgQ1BVICovCisJQlVHX09OKHJhd19zbXBfcHJvY2Vzc29yX2lkKCkg
IT0gY3B1KTsKKworCW11dGV4X2xvY2soJm1pY3JvY29kZV9tdXRleCk7CiAJbWljcm9jb2RlX3Vw
ZGF0ZV9jcHUoY3B1KTsKKwltdXRleF91bmxvY2soJm1pY3JvY29kZV9tdXRleCk7CisKIAlzZXRf
Y3B1c19hbGxvd2VkX3B0cihjdXJyZW50LCAmb2xkKTsKIH0KIAo=
------=_Part_4727_11034263.1222956082621--
