Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYG2TUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYG2TUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYG2TUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:20:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:26348 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYG2TUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=PiKcvPjHDvw0U1q6SOkDtcwF8z8bS6PIgFhD/SXh1bvl/LEXSMKEcGbM0ZspdP3Q8R
         0Pjgaygq3Pwa8Kae/H8mXjlhG3TRC6vJkGmbiMCdHoeIUqzTFkDWdZy3bWnc+sqzY+il
         YPUxC5d2VBjvjO+1b2oUZZTOhigFZwVEA3cNg=
Message-ID: <86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
Date: Tue, 29 Jul 2008 12:20:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Mike Travis" <travis@sgi.com>
In-Reply-To: <86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_33028_20138175.1217359201565"
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	 <86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_33028_20138175.1217359201565
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Jul 29, 2008 at 11:35 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Jul 29, 2008 at 9:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>> Hi Ingo, Thomas,
>>
>> Hit this on 2.6.27-rc1
>>
>> (The kernel bug is at line 356 (Its 357 as I applied a debug patch to
>> print out the irq) (Full dmesg and .config attached)
>
> can you boot with "debug apic=verbose pci=routeirq"?

please try attached patch

YH

------=_Part_33028_20138175.1217359201565
Content-Type: text/x-patch; name=nr_irqs.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fj8vvgu50
Content-Disposition: attachment; filename=nr_irqs.patch

W1BBVENIXSB4ODY6IDY0Yml0IHN1cHBvcnQgbW9yZSB0aGFuIDI1NiBpcnEKCmJlY2F1c2UgNjRi
aXQgYWxsb3cgc2FtZSB2ZWN0b3IgZm9yIGRpZmZlcmVudCBjcHUgdG8gc2VydmUgZGlmZmVyZW50
IGlycQoKYWxzbyBjaGFuZ2UgbmV4dCBpbiBpcnFfcGluX2xpc3QgZnJvbSBzaG9ydCB0byBuZXh0
LiBiZWNhdXNlIGZvciA0MDk2IE5SX0lSUVMKaXMgMl4oNSsxMikrMjI0LgoKbmVlZCB0byBjcmVh
dGUgdGhhdCBhcnJheSBkeW5hbWljYWxseSBsYXRlcgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBM
dSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKLS0tCiBhcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY182
NC5jICB8ICAgIDMgKystCiBpbmNsdWRlL2FzbS14ODYvaXJxX3ZlY3RvcnMuaCB8ICAgIDYgKysr
KystCiAyIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCklu
ZGV4OiBsaW51eC0yLjYvaW5jbHVkZS9hc20teDg2L2lycV92ZWN0b3JzLmgKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42Lm9yaWcvaW5jbHVkZS9hc20teDg2L2lycV92ZWN0b3JzLmgKKysrIGxpbnV4
LTIuNi9pbmNsdWRlL2FzbS14ODYvaXJxX3ZlY3RvcnMuaApAQCAtMTEzLDkgKzExMywxMyBAQAog
CiAjIGlmIGRlZmluZWQoQ09ORklHX1g4Nl9JT19BUElDKSB8fCBkZWZpbmVkKENPTkZJR19QQVJB
VklSVCkgfHwgZGVmaW5lZChDT05GSUdfWDg2X1ZJU1dTKQogCisjaWZkZWYgQ09ORklHX1g4Nl82
NAorIyAgZGVmaW5lIE5SX0lSUVMJCSgzMiAqIE5SX0NQVVMgKyAyMjQpCisjZWxzZQogIyAgZGVm
aW5lIE5SX0lSUVMJCTIyNAorI2VuZGlmCiAKLSMgIGlmICgyMjQgPj0gMzIgKiBOUl9DUFVTKQor
IyAgaWYgKE5SX0lSUVMgPj0gMzIgKiBOUl9DUFVTKQogIyAgIGRlZmluZSBOUl9JUlFfVkVDVE9S
UwlOUl9JUlFTCiAjICBlbHNlCiAjICAgZGVmaW5lIE5SX0lSUV9WRUNUT1JTCSgzMiAqIE5SX0NQ
VVMpCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2lvX2FwaWNfNjQuYwo9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY182NC5jCisrKyBs
aW51eC0yLjYvYXJjaC94ODYva2VybmVsL2lvX2FwaWNfNjQuYwpAQCAtMTQwLDcgKzE0MCw4IEBA
IERFQ0xBUkVfQklUTUFQKG1wX2J1c19ub3RfcGNpLCBNQVhfTVBfQlUKICAqLwogCiBzdGF0aWMg
c3RydWN0IGlycV9waW5fbGlzdCB7Ci0Jc2hvcnQgYXBpYywgcGluLCBuZXh0OworCXNob3J0IGFw
aWMsIHBpbjsKKwlpbnQgbmV4dDsKIH0gaXJxXzJfcGluW1BJTl9NQVBfU0laRV07CiAKIHN0cnVj
dCBpb19hcGljIHsK
------=_Part_33028_20138175.1217359201565--
