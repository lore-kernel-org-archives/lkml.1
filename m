Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbYHOPvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbYHOPvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbYHOPuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:50:46 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:63820 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620AbYHOPuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=ZBPKUvdEwllfQ6fbeWhBxhw9aj38+UEwB60THF00RzCebzvDNiBqXsrgtLFMma86nz
         mZtQZS/tC/kAPJGA15wf3JlZx07q2rfeQVlMgNvNstdACruCh4U/w28fG30vJEcKzzRu
         pGWHecWjtVQXNEjBsZ2+EiXZyAnADr1WFo/X8=
Message-ID: <19f34abd0808150850v5ae5a1aneaa3e5182e0032c@mail.gmail.com>
Date: Fri, 15 Aug 2008 17:50:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not allocated
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080815162848.08ff793c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_73716_23249777.1218815443956"
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
	 <19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
	 <20080815162848.08ff793c@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_73716_23249777.1218815443956
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Aug 15, 2008 at 5:28 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> ida_remove called for id=112 which is not allocated.
>> ida_remove called for id=67 which is not allocated.
>> ida_remove called for id=191 which is not allocated.
>> ida_remove called for id=23 which is not allocated.
>>
>> ..and with no backtrace, so I guess it means "not harmful". Sorry for the noise.
>
> Thats definitely not good and wants digging into further.
>

Okay!

I've attached my program. On 2.6.27-rc3 the message appears at least a
couple of times per second, so you should have no trouble in
reproducing it. On the 2.6.25 I get it maybe once a minute.

Compile with: gcc -std=gnu99


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_73716_23249777.1218815443956
Content-Type: text/x-csrc; name=mknod.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjwz3c8f0
Content-Disposition: attachment; filename=mknod.c

I2luY2x1ZGUgPHN5cy9tbWFuLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8c3lz
L3R5cGVzLmg+CgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRl
IDxzdGRsaWIuaD4KI2luY2x1ZGUgPHRpbWUuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKI2lmZGVm
IENPTkZJR19MT0dHSU5HCnN0YXRpYyBGSUxFICpsb2dmaWxlOwojZW5kaWYKCnN0YXRpYyBjb25z
dCBjaGFyICpkZXZuYW1lID0gIi90bXAvZGV2IjsKCnN0YXRpYyB2b2lkIGRvX29uZShtb2RlX3Qg
bW9kZSwgdW5zaWduZWQgaW50IG1haiwgdW5zaWduZWQgaW50IG1pbikKewojaWYgQ09ORklHX0xP
R0dJTkcKCWZwcmludGYobG9nZmlsZSwgIiVkLCAlZFxuIiwgbWFqLCBtaW4pOwoJZmZsdXNoKGxv
Z2ZpbGUpOwoJZnN5bmMoZmlsZW5vKGxvZ2ZpbGUpKTsKI2VuZGlmCgoJaWYgKG1rbm9kKGRldm5h
bWUsIG1vZGUgfCAwNjQ0LCBtYWtlZGV2KG1haiwgbWluKSkgPT0gLTEpCgkJcmV0dXJuOwoKCWlu
dCBmZCA9IG9wZW4oZGV2bmFtZSwgT19SRE9OTFksIDA2NDQpOwoJaWYgKGZkID09IC0xKQoJCWdv
dG8gcmV0X21rbm9kOwoKCWNoYXIgKnB0ciA9IG1tYXAoTlVMTCwgZ2V0cGFnZXNpemUoKSwgUFJP
VF9SRUFELCBNQVBfU0hBUkVEIHwgTUFQX0FOT05ZTU9VUywgZmQsIDApOwoJaWYgKHB0ciA9PSBN
QVBfRkFJTEVEKQoJCWdvdG8gcmV0X29wZW47CgoJbXVubWFwKHB0ciwgZ2V0cGFnZXNpemUoKSk7
CgpyZXRfb3BlbjoKCWNsb3NlKGZkKTsKcmV0X21rbm9kOgoJdW5saW5rKGRldm5hbWUpOwp9Cgpz
dGF0aWMgdm9pZCBkb19ib3RoKHVuc2lnbmVkIGludCBtYWosIHVuc2lnbmVkIGludCBtaW4pCnsK
CWRvX29uZShTX0lGQ0hSLCBtYWosIG1pbik7Cglkb19vbmUoU19JRkJMSywgbWFqLCBtaW4pOwp9
CgpzdGF0aWMgaW50IGJsYWNrbGlzdGVkKHVuc2lnbmVkIGludCBtYWosIHVuc2lnbmVkIGludCBt
aW4pCnsKCS8qIFdhdGNoZG9nOyB3aWxsIGtpbGwgdGhlIHN5c3RlbSBhbnl3YXkgKi8KCWlmICht
YWogPT0gMTApIHsKCQlpZiAobWluID09IDEzMCkKCQkJcmV0dXJuIDE7CgkJaWYgKG1pbiA+PSAy
MTIgJiYgbWluIDw9IDIxNSkKCQkJcmV0dXJuIDE7Cgl9CgoJcmV0dXJuIDA7Cn0KCmludAptYWlu
KGludCBhcmdjLCBjaGFyICphcmd2W10pCnsKI2lmZGVmIENPTkZJR19MT0dHSU5HCglsb2dmaWxl
ID0gZm9wZW4oIm1rbm9kLWxvZ2ZpbGUudHh0IiwgInciKTsKCWlmICghbG9nZmlsZSkKCQlleGl0
KEVYSVRfRkFJTFVSRSk7CiNlbmRpZgoKCXVubGluayhkZXZuYW1lKTsKCi8vIFhYWAojaWZuZGVm
IENPTkZJR19SQU5ET01JWkUKCXNyYW5kKHRpbWUoTlVMTCkpOwoJc3JhbmQoZ2V0cGlkKCkgKiBy
YW5kKCkpOwoKCXdoaWxlICgxKSB7CgkJdW5zaWduZWQgaW50IGkgPSByYW5kKCkgJSAyNTY7CgkJ
dW5zaWduZWQgaW50IGogPSByYW5kKCkgJSAyNTY7CgoJCWlmIChibGFja2xpc3RlZChpLCBqKSkK
CQkJY29udGludWU7CgoJCWRvX2JvdGgoaSwgaik7Cgl9CiNlbHNlCglmb3IgKHVuc2lnbmVkIGlu
dCBpID0gMDsgaSA8IDEyODsgKytpKSB7CgkJcHJpbnRmKCJtYWo6ICVkXG4iLCBpKTsKCgkJZm9y
ICh1bnNpZ25lZCBpbnQgaiA9IDA7IGogPCAxMjg7ICsraikgewoJCQlpZiAoYmxhY2tsaXN0ZWQo
aSwgaikpCgkJCQljb250aW51ZTsKCgkJCWRvX2JvdGgoaSwgaik7CgkJfQoJfQoJZG9pdChTX0lG
Q0hSLCAxMCwgMTMwKTsKI2VuZGlmCgojaWZkZWYgQ09ORklHX0xPR0dJTkcKCWZjbG9zZShsb2dm
aWxlKTsKI2VuZGlmCglyZXR1cm4gRVhJVF9TVUNDRVNTOwp9Cg==
------=_Part_73716_23249777.1218815443956--
