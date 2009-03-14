Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZCNEHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZCNEHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZCNEHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:07:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:2630 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCNEHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Q7z9CUfziuKHrVoK8h47Yxy1GneFaNW4kj0TGSRCQZGa+iZBhBK10NIQ/aqab0CEi6
         8yV/rm5JYIVabs40wESwmMcbe3VHysO31l9elty1OMccpv4UOMTaGTjURWuLMQt9JL1M
         5y0SchSukgLW/Q2OdUB+CtZuef1gTw219zE5M=
MIME-Version: 1.0
In-Reply-To: <804dabb00903132101o6bf812c1r1efd02d069b5c7fa@mail.gmail.com>
References: <804dabb00903132101o6bf812c1r1efd02d069b5c7fa@mail.gmail.com>
Date: Sat, 14 Mar 2009 12:07:30 +0800
Message-ID: <804dabb00903132107k10fe11efo1622877d4a535500@mail.gmail.com>
Subject: Re: [PATCH] replace kernel_thread() with kthread_run() in RT2870
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Paul Lin <paul_lin@ralinktech.com>
Content-Type: multipart/mixed; boundary=000e0cd2bd002f2e5004650c5b2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2bd002f2e5004650c5b2c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sorry, mixed up the patches with another patch.   Here is the correct
one.   Thanks.


On Sat, Mar 14, 2009 at 12:01 PM, Peter Teoh <htmldeveloper@gmail.com> wrot=
e:
> As advised by Greg KH:
>
> http://lkml.org/lkml/2009/3/13/131
>
> Replaced the usage of kernel_thread() with kthread_run(). =A0 Compiled
> successfully, but not tested as I don't have the hardware.
>
> (parsed by scripts/checkpatch.pl as well).
>
> Thanks.
>
> --
> Regards,
> Peter Teoh
>



--=20
Regards,
Peter Teoh

--000e0cd2bd002f2e5004650c5b2c
Content-Type: text/x-diff; charset=US-ASCII; name="rt2870_kernel_thread.patch"
Content-Disposition: attachment; filename="rt2870_kernel_thread.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fs9s2pwd1

UmVwbGFjZSB1c2Ugb2Yga2VybmVsX3RocmVhZCgpIHdpdGgga3RocmVhZF9ydW4oKSwgYXMgdGhl
IGZvcm1lciBpcyBkZXByZWNhdGVkLgoKU2lnbmVkLW9mZi1ieTogUGV0ZXIgVGVvaCA8aHRtbGRl
dmVsb3BlckBnbWFpbC5jb20+CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3J0Mjg3MC9j
b21tb24vMjg3MF9ydG1wX2luaXQuYyBiL2RyaXZlcnMvc3RhZ2luZy9ydDI4NzAvY29tbW9uLzI4
NzBfcnRtcF9pbml0LmMKaW5kZXggOWY1MTQzYi4uOWE4MWQwZSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3J0Mjg3MC9jb21tb24vMjg3MF9ydG1wX2luaXQuYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvcnQyODcwL2NvbW1vbi8yODcwX3J0bXBfaW5pdC5jCkBAIC03NjUsNyArNzY1LDcgQEAg
TkRJU19TVEFUVVMJIENyZWF0ZVRocmVhZHMoCiB7CiAJUFJUTVBfQURBUFRFUiBwQWQgPSBuZXRf
ZGV2LT5tbF9wcml2OwogCVBPU19DT09LSUUgcE9iaiA9IChQT1NfQ09PS0lFKSBwQWQtPk9TX0Nv
b2tpZTsKLQlwaWRfdCBwaWRfbnVtYmVyID0gLTE7CisJc3RydWN0IHRhc2tfc3RydWN0ICp0c2s7
CiAKIAkvL2luaXRfTVVURVgoJihwQWQtPnVzYmRldl9zZW1hcGhvcmUpKTsKIApAQCAtNzgwLDM1
ICs3ODAsMzggQEAgTkRJU19TVEFUVVMJIENyZWF0ZVRocmVhZHMoCiAKIAkvLyBDcmVhdCBNTE1F
IFRocmVhZAogCXBPYmotPk1MTUVUaHJfcGlkPSBUSFJFQURfUElEX0lOSVRfVkFMVUU7Ci0JcGlk
X251bWJlciA9IGtlcm5lbF90aHJlYWQoTWxtZVRocmVhZCwgcEFkLCBDTE9ORV9WTSk7Ci0JaWYg
KHBpZF9udW1iZXIgPCAwKQotCXsKKwl0c2sgPSBrdGhyZWFkX3J1bihNbG1lVGhyZWFkLCBwQWQs
IHBBZC0+bmV0X2Rldi0+bmFtZSk7CisKKwlpZiAoSVNfRVJSKHRzaykpIHsKIAkJcHJpbnRrIChL
RVJOX1dBUk5JTkcgIiVzOiB1bmFibGUgdG8gc3RhcnQgTWxtZSB0aHJlYWRcbiIscEFkLT5uZXRf
ZGV2LT5uYW1lKTsKIAkJcmV0dXJuIE5ESVNfU1RBVFVTX0ZBSUxVUkU7CiAJfQotCXBPYmotPk1M
TUVUaHJfcGlkID0gR0VUX1BJRChwaWRfbnVtYmVyKTsKKworCXBPYmotPk1MTUVUaHJfcGlkID0g
Z2V0X3BpZCh0YXNrX3BpZCh0c2spKTsKIAkvLyBXYWl0IGZvciB0aGUgdGhyZWFkIHRvIHN0YXJ0
CiAJd2FpdF9mb3JfY29tcGxldGlvbigmKHBBZC0+bWxtZUNvbXBsZXRlKSk7CiAKIAkvLyBDcmVh
dCBDb21tYW5kIFRocmVhZAogCXBPYmotPlJUVVNCQ21kVGhyX3BpZD0gVEhSRUFEX1BJRF9JTklU
X1ZBTFVFOwotCXBpZF9udW1iZXIgPSBrZXJuZWxfdGhyZWFkKFJUVVNCQ21kVGhyZWFkLCBwQWQs
IENMT05FX1ZNKTsKLQlpZiAocGlkX251bWJlciA8IDApCisJdHNrID0ga3RocmVhZF9ydW4oUlRV
U0JDbWRUaHJlYWQsIHBBZCwgcEFkLT5uZXRfZGV2LT5uYW1lKTsKKworCWlmIChJU19FUlIodHNr
KSA8IDApCiAJewogCQlwcmludGsgKEtFUk5fV0FSTklORyAiJXM6IHVuYWJsZSB0byBzdGFydCBS
VFVTQkNtZCB0aHJlYWRcbiIscEFkLT5uZXRfZGV2LT5uYW1lKTsKIAkJcmV0dXJuIE5ESVNfU1RB
VFVTX0ZBSUxVUkU7CiAJfQotCXBPYmotPlJUVVNCQ21kVGhyX3BpZCA9IEdFVF9QSUQocGlkX251
bWJlcik7CisKKwlwT2JqLT5SVFVTQkNtZFRocl9waWQgPSBnZXRfcGlkKHRhc2tfcGlkKHRzaykp
OwogCXdhaXRfZm9yX2NvbXBsZXRpb24oJihwQWQtPkNtZFFDb21wbGV0ZSkpOwogCiAJcE9iai0+
VGltZXJRVGhyX3BpZD0gVEhSRUFEX1BJRF9JTklUX1ZBTFVFOwotCXBpZF9udW1iZXIgPSBrZXJu
ZWxfdGhyZWFkKFRpbWVyUVRocmVhZCwgcEFkLCBDTE9ORV9WTSk7Ci0JaWYgKHBpZF9udW1iZXIg
PCAwKQorCXRzayA9IGt0aHJlYWRfcnVuKFRpbWVyUVRocmVhZCwgcEFkLCBwQWQtPm5ldF9kZXYt
Pm5hbWUpOworCWlmIChJU19FUlIodHNrKSA8IDApCiAJewogCQlwcmludGsgKEtFUk5fV0FSTklO
RyAiJXM6IHVuYWJsZSB0byBzdGFydCBUaW1lclFUaHJlYWRcbiIscEFkLT5uZXRfZGV2LT5uYW1l
KTsKIAkJcmV0dXJuIE5ESVNfU1RBVFVTX0ZBSUxVUkU7CiAJfQotCXBPYmotPlRpbWVyUVRocl9w
aWQgPSBHRVRfUElEKHBpZF9udW1iZXIpOworCXBPYmotPlRpbWVyUVRocl9waWQgPSBnZXRfcGlk
KHRhc2tfcGlkKHRzaykpOwogCS8vIFdhaXQgZm9yIHRoZSB0aHJlYWQgdG8gc3RhcnQKIAl3YWl0
X2Zvcl9jb21wbGV0aW9uKCYocEFkLT5UaW1lclFDb21wbGV0ZSkpOwogCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvcnQyODcwL3J0X2xpbnV4LmggYi9kcml2ZXJzL3N0YWdpbmcvcnQyODcw
L3J0X2xpbnV4LmgKaW5kZXggODU5ZjljZS4uOWE4ZWQxYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3J0Mjg3MC9ydF9saW51eC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9ydDI4NzAvcnRf
bGludXguaApAQCAtNDQsNiArNDQsNyBAQAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogI2lu
Y2x1ZGUgPGxpbnV4L3ZlcnNpb24uaD4KICNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNs
dWRlIDxsaW51eC9rdGhyZWFkLmg+CiAKICNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5oPgogI2lu
Y2x1ZGUgPGxpbnV4L2luaXQuaD4K
--000e0cd2bd002f2e5004650c5b2c--
