Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZDNWjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZDNWjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZDNWiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:38:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:55233 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZDNWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l8tJMvevPXWnNvi5o521pOscrIoJRBWX5Q5g7sH4nTPh+Q/XfXTO6yhVRhjfd1fZUL
         UpeAFZnfPP4dUtbb5qTyymF5Pcz9Cn93p0EW3G+tL+i3R+XtFSI4xP4nZnpFLm53tQk1
         4CBKgwm0K5yxRhhzyhc3Bjj8PHNHYIZZpBXfs=
MIME-Version: 1.0
In-Reply-To: <49E39F3D.4060501@twiddle.net>
References: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>
	 <49E39F3D.4060501@twiddle.net>
Date: Tue, 14 Apr 2009 18:38:52 -0400
Message-ID: <b4198de60904141538w30e2707bx83bec5c665159eee@mail.gmail.com>
Subject: Re: alpha: half done futex implementation
From: Matt Turner <mattst88@gmail.com>
To: Richard Henderson <rth@twiddle.net>,
       Linux on Alpha processors <axp-list@redhat.com>,
       linux-kernel@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Oliver Falk <oliver@linux-kernel.at>
Content-Type: multipart/mixed; boundary=000e0cd6abb2d0677e04678b7e24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd6abb2d0677e04678b7e24
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Attached is a patch to (almost) add native futex support to Alpha.

It doesn't compile...

  CC      kernel/futex.o
kernel/futex.c: In function 'do_futex':
/usr/src/linux-radeon/glisse-drm/arch/alpha/include/asm/futex.h:47:
error: invalid 'asm': operand number out of range
{standard input}: Assembler messages:
{standard input}:3722: Error: bad expression
{standard input}:3722: Error: syntax error

I can't make much sense out of that.

I changed the %4's to %3 as we don't have a %4.

Please review.

Matt Turner

--000e0cd6abb2d0677e04678b7e24
Content-Type: application/octet-stream; 
	name="add-native-futex-support-on-alpha.patch"
Content-Disposition: attachment; 
	filename="add-native-futex-support-on-alpha.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftj6cdbc0

ZGlmZiAtLWdpdCBhL2FyY2gvYWxwaGEvaW5jbHVkZS9hc20vZnV0ZXguaCBiL2FyY2gvYWxwaGEv
aW5jbHVkZS9hc20vZnV0ZXguaAppbmRleCA2YTMzMmE5Li40NWI1NGZhIDEwMDY0NAotLS0gYS9h
cmNoL2FscGhhL2luY2x1ZGUvYXNtL2Z1dGV4LmgKKysrIGIvYXJjaC9hbHBoYS9pbmNsdWRlL2Fz
bS9mdXRleC5oCkBAIC0xLDYgKzEsMTE1IEBACi0jaWZuZGVmIF9BU01fRlVURVhfSAotI2RlZmlu
ZSBfQVNNX0ZVVEVYX0gKKyNpZm5kZWYgX0FTTV9BTFBIQV9GVVRFWF9ICisjZGVmaW5lIF9BU01f
QUxQSEFfRlVURVhfSAogCi0jaW5jbHVkZSA8YXNtLWdlbmVyaWMvZnV0ZXguaD4KKyNpZmRlZiBf
X0tFUk5FTF9fCiAKKyNpbmNsdWRlIDxsaW51eC9mdXRleC5oPgorI2luY2x1ZGUgPGxpbnV4L3Vh
Y2Nlc3MuaD4KKyNpbmNsdWRlIDxhc20vZXJybm8uaD4KKworI2RlZmluZSBfX2Z1dGV4X2F0b21p
Y19vcChpbnNuLCByZXQsIG9sZHZhbCwgdWFkZHIsIG9wYXJnKSBcCisJX19hc21fXyBfX3ZvbGF0
aWxlKAkJCQlcCisJIjE6CWxkbF9sCSUwLDAoJTMpXG4iCQkJXAorCWluc24JCQkJCQkJXAorCSIy
OglzdGxfYwklMSwwKCUzKVxuIgkJCVwKKwkiCWJlcQkJJTEsNGZcbiIJCQlcCisJIgltb3YJCSQz
MSwlMVxuIgkJCVwKKwkiMzoJLnN1YnNlY3Rpb24gMlxuIgkJCVwKKwkiNDoJYnIJCTFiXG4iCQkJ
CVwKKwkiCS5wcmV2aW91c1xuIgkJCQlcCisJIgkuc2VjdGlvbiBfX2V4X3RhYmxlLFwiYVwiXG4i
XAorCSIJLmxvbmcJMWItLlxuIgkJCQlcCisJIglsZGEJCSUwLDNiLTFiKCUyKVxuIgkJXAorCQki
LmxvbmcJMmItLlxuIgkJCQlcCisJIglsZGEJCSUwLDNiLTJiKCUyKVxuIgkJXAorCSIJLnByZXZp
b3VzXG4iCQkJCVwKKwk6CSI9JnIiIChvbGR2YWwpLCAiPSZyIihyZXQpCVwKKwk6CSJyIiAodWFk
ZHIpLCAiciIob3BhcmcpCQlcCisJOgkibWVtb3J5IikKKworc3RhdGljIGlubGluZSBpbnQgZnV0
ZXhfYXRvbWljX29wX2ludXNlciAoaW50IGVuY29kZWRfb3AsIGludCBfX3VzZXIgKnVhZGRyKQor
eworCWludCBvcCA9IChlbmNvZGVkX29wID4+IDI4KSAmIDc7CisJaW50IGNtcCA9IChlbmNvZGVk
X29wID4+IDI0KSAmIDE1OworCWludCBvcGFyZyA9IChlbmNvZGVkX29wIDw8IDgpID4+IDIwOwor
CWludCBjbXBhcmcgPSAoZW5jb2RlZF9vcCA8PCAyMCkgPj4gMjA7CisJaW50IG9sZHZhbCA9IDAs
IHJldDsKKwlpZiAoZW5jb2RlZF9vcCAmIChGVVRFWF9PUF9PUEFSR19TSElGVCA8PCAyOCkpCisJ
CW9wYXJnID0gMSA8PCBvcGFyZzsKKworCWlmICghIGFjY2Vzc19vayAoVkVSSUZZX1dSSVRFLCB1
YWRkciwgc2l6ZW9mKGludCkpKQorCQlyZXR1cm4gLUVGQVVMVDsKKworCXBhZ2VmYXVsdF9kaXNh
YmxlKCk7CisKKwlzd2l0Y2ggKG9wKSB7CisJY2FzZSBGVVRFWF9PUF9TRVQ6CisJCV9fZnV0ZXhf
YXRvbWljX29wKCJtb3YgJTMsJTEiLCByZXQsIG9sZHZhbCwgdWFkZHIsIG9wYXJnKTsKKwkJYnJl
YWs7CisJY2FzZSBGVVRFWF9PUF9BREQ6CisJCV9fZnV0ZXhfYXRvbWljX29wKCJhZGRsICUwLCUz
LCUxXG4iLCByZXQsIG9sZHZhbCwgdWFkZHIsIG9wYXJnKTsKKwkJYnJlYWs7CisJY2FzZSBGVVRF
WF9PUF9PUjoKKwkJX19mdXRleF9hdG9taWNfb3AoIm9yICUwLCUzLCUxXG4iLCByZXQsIG9sZHZh
bCwgdWFkZHIsIG9wYXJnKTsKKwkJYnJlYWs7CisJY2FzZSBGVVRFWF9PUF9BTkROOgorCQlfX2Z1
dGV4X2F0b21pY19vcCgiYW5kbm90ICUwLCUzLCUxXG4iLCByZXQsIG9sZHZhbCwgdWFkZHIsIG9w
YXJnKTsKKwkJYnJlYWs7CisJY2FzZSBGVVRFWF9PUF9YT1I6CisJCV9fZnV0ZXhfYXRvbWljX29w
KCJ4b3IgJTAsJTMsJTFcbiIsIHJldCwgb2xkdmFsLCB1YWRkciwgb3BhcmcpOworCQlicmVhazsK
KwlkZWZhdWx0OgorCQlyZXQgPSAtRU5PU1lTOworCX0KKworCXBhZ2VmYXVsdF9lbmFibGUoKTsK
KworCWlmICghcmV0KSB7CisJCXN3aXRjaCAoY21wKSB7CisJCWNhc2UgRlVURVhfT1BfQ01QX0VR
OiByZXQgPSAob2xkdmFsID09IGNtcGFyZyk7IGJyZWFrOworCQljYXNlIEZVVEVYX09QX0NNUF9O
RTogcmV0ID0gKG9sZHZhbCAhPSBjbXBhcmcpOyBicmVhazsKKwkJY2FzZSBGVVRFWF9PUF9DTVBf
TFQ6IHJldCA9IChvbGR2YWwgPCBjbXBhcmcpOyBicmVhazsKKwkJY2FzZSBGVVRFWF9PUF9DTVBf
R0U6IHJldCA9IChvbGR2YWwgPj0gY21wYXJnKTsgYnJlYWs7CisJCWNhc2UgRlVURVhfT1BfQ01Q
X0xFOiByZXQgPSAob2xkdmFsIDw9IGNtcGFyZyk7IGJyZWFrOworCQljYXNlIEZVVEVYX09QX0NN
UF9HVDogcmV0ID0gKG9sZHZhbCA+IGNtcGFyZyk7IGJyZWFrOworCQlkZWZhdWx0OiByZXQgPSAt
RU5PU1lTOworCQl9CisJfQorCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50Citm
dXRleF9hdG9taWNfY21weGNoZ19pbmF0b21pYyhpbnQgX191c2VyICp1YWRkciwgaW50IG9sZHZh
bCwgaW50IG5ld3ZhbCkKK3sKKwlpbnQgcHJldjsKKworCWlmICghYWNjZXNzX29rKFZFUklGWV9X
UklURSwgdWFkZHIsIHNpemVvZihpbnQpKSkKKwkJcmV0dXJuIC1FRkFVTFQ7CisKKwlfX2FzbV9f
IF9fdm9sYXRpbGVfXyAoCisjaWZkZWYgQ09ORklHX1NNUAorCSIJbWJcbiIKICNlbmRpZgorCSIx
OglsZGxfbAklMCwwKCUzKSAgICAgICAgIyBmdXRleF9hdG9taWNfY21weGNoZ19pbmF0b21pY1xu
IgorCSIJY21wZXEJJTAsJTMsJTBcbiIKKwkiCWJlcQkJJTAsM2ZcbiIKKwkiMjoJc3RsX2MJJTQs
MCglMilcbiIKKwkiCWJlcQkJJTQsMWJcbiIKKwkiMzoJLnN1YnNlY3Rpb24gMlxuIgorCSI0Ogli
cgkJMWJcbiIKKwkiCS5wcmV2aW91c1xuIgorCSIJLnNlY3Rpb24gX19leF90YWJsZSxcImFcIlxu
IgorCSIJLmxvbmcJMWItLlxuIgorCSIJbGRhCQklMCwzYi0xYiglMilcbiIKKwkJIi5sb25nCTJi
LS5cbiIKKwkiCWxkYQkJJTAsM2ItMmIoJTIpXG4iCisJIgkucHJldmlvdXNcbiIKKwk6ICI9JnIi
IChwcmV2KSwgIittIiAoKnVhZGRyKQorCTogInIiICh1YWRkciksICJyIiAob2xkdmFsKSwgInIi
IChuZXd2YWwpLCAiaSIgKC1FRkFVTFQpCisJOiAibWVtb3J5Iik7CisKKwlyZXR1cm4gcHJldjsK
K30KKworI2VuZGlmIC8qIF9fS0VSTkVMX18gKi8KKyNlbmRpZiAvKiBfQVNNX0FMUEhBX0ZVVEVY
X0ggKi8K
--000e0cd6abb2d0677e04678b7e24--
