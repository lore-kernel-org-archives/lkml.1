Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYHANkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYHANkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYHANjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:39:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:38336 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbYHANjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Xcn9vgrT4spHd5gx6HD0QnXANHcYgWRvO46DLaLY8rMPXXtxTUMTis2xJ4nVRSShDn
         gFxkujkJ45QfCznevZb97gsnYRU0PY7f5cs4d4g7HIsxjj5jlpPscE2fJ+nR1Q59R1zm
         rv2EhNTNazufvn603MI0NJ8qFEjgGzf1+MOXI=
Message-ID: <520f0cf10808010639y4c1a19a7kff429827d26dc8e9@mail.gmail.com>
Date: Fri, 1 Aug 2008 15:39:51 +0200
From: "John Kacur" <jkacur@gmail.com>
To: rt-users <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
Subject: [PATCH] rt Kconfig.preempt fixes
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_15899_10687555.1217597991272"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_15899_10687555.1217597991272
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is a non-critical patch, that makes configuring an rt kernel a
little nicer.
Comments are welcome of course.

Signed-off-by: John Kacur <jkacur at gmail dot com>

This patch makes the following changes.
1. Hides the visibility of PREEMPT_SOFTIRQS and PREEMPT_HARDIRQS if PREEMPT_RT
(Complete Preemption) is choosen, since these values are then set (selected) to
be "y".

2. Changes the PREEMPT_HARDIRQS to depend on PREEMPT_SOFTIRQS instead of
forcing PREEMPT_SOFTIRQS to y if PREEMPT_HARDIRQS is choosen. (this is somewhat
an abuse of select)

3. Minor spelling fix. (tat to that)

------=_Part_15899_10687555.1217597991272
Content-Type: text/x-patch; name=threaded-irqs-kconfig-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjcubj150
Content-Disposition: attachment; filename=threaded-irqs-kconfig-fix.patch

U2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyIGF0IGdtYWlsIGRvdCBjb20+CgpUaGlz
IHBhdGNoIG1ha2VzIHRoZSBmb2xsb3dpbmcgY2hhbmdlcy4KMS4gSGlkZXMgdGhlIHZpc2liaWxp
dHkgb2YgUFJFRU1QVF9TT0ZUSVJRUyBhbmQgUFJFRU1QVF9IQVJESVJRUyBpZiBQUkVFTVBUX1JU
CihDb21wbGV0ZSBQcmVlbXB0aW9uKSBpcyBjaG9vc2VuLCBzaW5jZSB0aGVzZSB2YWx1ZXMgYXJl
IHRoZW4gc2V0IChzZWxlY3RlZCkgdG8KYmUgInkiLgoKMi4gQ2hhbmdlcyB0aGUgUFJFRU1QVF9I
QVJESVJRUyB0byBkZXBlbmQgb24gUFJFRU1QVF9TT0ZUSVJRUyBpbnN0ZWFkIG9mCmZvcmNpbmcg
UFJFRU1QVF9TT0ZUSVJRUyB0byB5IGlmIFBSRUVNUFRfSEFSRElSUVMgaXMgY2hvb3Nlbi4gKHRo
aXMgaXMgc29tZXdoYXQKYW4gYWJ1c2Ugb2Ygc2VsZWN0KQoKMy4gTWlub3Igc3BlbGxpbmcgZml4
LiAodGF0IHRvIHRoYXQpCgpJbmRleDogbGludXgtMi42LjI2LXJ0MS9rZXJuZWwvS2NvbmZpZy5w
cmVlbXB0Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yNi1ydDEub3JpZy9rZXJuZWwvS2NvbmZp
Zy5wcmVlbXB0CisrKyBsaW51eC0yLjYuMjYtcnQxL2tlcm5lbC9LY29uZmlnLnByZWVtcHQKQEAg
LTg4LDggKzg4LDEwIEBAIGNvbmZpZyBQUkVFTVBUCiAKIGNvbmZpZyBQUkVFTVBUX1NPRlRJUlFT
CiAJYm9vbCAiVGhyZWFkIFNvZnRpcnFzIgorIyBUaGUgZm9sbG93aW5nIGxpbmUgbWFrZXMgUFJF
RU1QVF9TT0ZUSVJRUyBpbnZpc2libGUgaWYgUFJFRU1QVF9SVCBpcyB5CisjIEhvd2V2ZXIsIFBS
RUVNUFRfUlQgc3RpbGwgc2V0cyAoc2VsZWN0cykgdGhlIHZhbHVlIG9mIFBSRUVNUFRfU09GVElS
UVMgdG8geQorCWRlcGVuZHMgb24gUFJFRU1QVF9SVCAhPSB5CiAJZGVmYXVsdCBuCi0jCWRlcGVu
ZHMgb24gUFJFRU1QVAogCWhlbHAKIAkgIFRoaXMgb3B0aW9uIHJlZHVjZXMgdGhlIGxhdGVuY3kg
b2YgdGhlIGtlcm5lbCBieSAndGhyZWFkaW5nJwogICAgICAgICAgIHNvZnQgaW50ZXJydXB0cy4g
VGhpcyBtZWFucyB0aGF0IGFsbCBzb2Z0aXJxcyB3aWxsIGV4ZWN1dGUKQEAgLTEwNCw5ICsxMDYs
MTIgQEAgY29uZmlnIFBSRUVNUFRfU09GVElSUVMKIAogY29uZmlnIFBSRUVNUFRfSEFSRElSUVMK
IAlib29sICJUaHJlYWQgSGFyZGlycXMiCisjIFRoZSBmb2xsb3dpbmcgbGluZSBtYWtlcyBQUkVF
TVBUX0hBUkRJUlFTIGludmlzaWJsZSBpZiBQUkVFTVBUX1JUIGlzIHkKKyMgSG93ZXZlciwgUFJF
RU1QVF9SVCBzdGlsbCBzZXRzIChzZWxlY3RzKSB0aGUgdmFsdWUgb2YgUFJFRU1QVF9IQVJESVJR
UyB0byB5CisJZGVwZW5kcyBvbiBQUkVFTVBUX1JUICE9IHkKIAlkZWZhdWx0IG4KIAlkZXBlbmRz
IG9uICFHRU5FUklDX0hBUkRJUlFTX05PX19ET19JUlEKLQlzZWxlY3QgUFJFRU1QVF9TT0ZUSVJR
UworCWRlcGVuZHMgb24gUFJFRU1QVF9TT0ZUSVJRUwogCWhlbHAKIAkgIFRoaXMgb3B0aW9uIHJl
ZHVjZXMgdGhlIGxhdGVuY3kgb2YgdGhlIGtlcm5lbCBieSAndGhyZWFkaW5nJwogICAgICAgICAg
IGhhcmRpcnFzLiBUaGlzIG1lYW5zIHRoYXQgYWxsIChvciBzZWxlY3RlZCkgaGFyZGlycXMgd2ls
bCBydW4KQEAgLTE0MSw3ICsxNDYsNyBAQCBjb25maWcgUFJFRU1QVF9SQ1VfQk9PU1QKIAlkZWZh
dWx0IHkgaWYgUFJFRU1QVF9SVAogCWhlbHAKIAkgIFRoaXMgb3B0aW9uIHBlcm1pdHMgcHJpb3Jp
dHkgYm9vc3Rpbmcgb2YgUkNVIHJlYWQtc2lkZSBjcml0aWNhbAotCSAgc2VjdGlvbnMgdGF0IGhh
dmUgYmVlbiBwcmVlbXB0ZWQgYW5kIGEgUlQgcHJvY2VzcyBpcyB3YWl0aW5nCisJICBzZWN0aW9u
cyB0aGF0IGhhdmUgYmVlbiBwcmVlbXB0ZWQgYW5kIGEgUlQgcHJvY2VzcyBpcyB3YWl0aW5nCiAJ
ICBvbiBhIHN5bmNocm9uaXplX3JjdS4KIAogCSAgQW4gUkNVIHRocmVhZCBpcyBhbHNvIGNyZWF0
ZWQgdGhhdCBwZXJpb2RpY2FsbHkgd2FrZXMgdXAgYW5kCg==
------=_Part_15899_10687555.1217597991272--
