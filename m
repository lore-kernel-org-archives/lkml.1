Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbXC2Esk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbXC2Esk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933983AbXC2Esk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:48:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:49081 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbXC2Esj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=HY7PUunBBNgLgfF8T9qCK96O59VsRTOLbyKXyxsw3IMIxZldoPSCG//5MMQAuTZ3uYZ9x4VEmivTs49Gbl4dYp/Gtixgz8wQ/iGwUWKUpoH9cEG/aNoVEipcxRGVSramD1bymWJ5pJu6JA+WN32AEWqHUPsEodEwfFqLrDAPwtI=
Message-ID: <86802c440703282148w29732dcfy5b41a244fad6be4e@mail.gmail.com>
Date: Wed, 28 Mar 2007 21:48:38 -0700
From: "Yinghai Lu" <yinghai.lu@amd.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64 irq: keep consistent for changing IRQ0_VECTOR from 0x20 to 0x30
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
In-Reply-To: <m1irdcdir5.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_56787_26742919.1175143718258"
References: <86802c440703052359q3242f771ne9c10752613820d3@mail.gmail.com>
	 <Pine.LNX.4.64.0703061942000.5963@woody.linux-foundation.org>
	 <m1irdcdir5.fsf@ebiederm.dsl.xmission.com>
X-Google-Sender-Auth: 819b4200fac01c86
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_56787_26742919.1175143718258
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 3/7/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> The comment fixes or some variation on them are needed.

Please check the patch about comment.

YH

------=_Part_56787_26742919.1175143718258
Content-Type: text/x-patch; name=3x_irq_20_30.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ezuq3qtf
Content-Disposition: attachment; filename="3x_irq_20_30.patch"

W1BBVENIXSB4ODZfNjQgaXJxOiBrZWVwIGNvbnNpc3RlbnQgZm9yIGNoYW5naW5nIElSUTBfVkVD
VE9SIGZyb20gMHgyMCB0byAweDMwCgpGSVJTVF9FWFRFUk5BTF9WRUNUT1IgaXMgdXNlZCBmb3Ig
SVJRX01PVkVfQ0xFQU5VUF9WRUNUT1IsIGFuZCBJUlEwIHN0YXJ0aW5nIGZyb20gRklSU1RfRVhU
RVJOQUxfVkVDVE9SICsgMHgxMC4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWku
bHVAYW1kLmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL3g4Nl82NC9rZXJuZWwvaTgyNTkuYyBiL2Fy
Y2gveDg2XzY0L2tlcm5lbC9pODI1OS5jCmluZGV4IDIxZDk1YjcuLjQ4OTQyNjYgMTAwNjQ0Ci0t
LSBhL2FyY2gveDg2XzY0L2tlcm5lbC9pODI1OS5jCisrKyBiL2FyY2gveDg2XzY0L2tlcm5lbC9p
ODI1OS5jCkBAIC00NSw3ICs0NSw3IEBACiAKIC8qCiAgKiBJU0EgUElDIG9yIGxvdyBJTy1BUElD
IHRyaWdnZXJlZCAoSU5UQS1jeWNsZSBvciBBUElDKSBpbnRlcnJ1cHRzOgotICogKHRoZXNlIGFy
ZSB1c3VhbGx5IG1hcHBlZCB0byB2ZWN0b3JzIDB4MjAtMHgyZikKKyAqICh0aGVzZSBhcmUgdXN1
YWxseSBtYXBwZWQgdG8gdmVjdG9ycyAweDMwLTB4M2YpCiAgKi8KIAogLyoKQEAgLTI5OSw3ICsy
OTksNyBAQCB2b2lkIGluaXRfODI1OUEoaW50IGF1dG9fZW9pKQogCSAqIG91dGJfcCAtIHRoaXMg
aGFzIHRvIHdvcmsgb24gYSB3aWRlIHJhbmdlIG9mIFBDIGhhcmR3YXJlLgogCSAqLwogCW91dGJf
cCgweDExLCAweDIwKTsJLyogSUNXMTogc2VsZWN0IDgyNTlBLTEgaW5pdCAqLwotCW91dGJfcChJ
UlEwX1ZFQ1RPUiwgMHgyMSk7CS8qIElDVzI6IDgyNTlBLTEgSVIwLTcgbWFwcGVkIHRvIDB4MjAt
MHgyNyAqLworCW91dGJfcChJUlEwX1ZFQ1RPUiwgMHgyMSk7CS8qIElDVzI6IDgyNTlBLTEgSVIw
LTcgbWFwcGVkIHRvIDB4MzAtMHgzNyAqLwogCW91dGJfcCgweDA0LCAweDIxKTsJLyogODI1OUEt
MSAodGhlIG1hc3RlcikgaGFzIGEgc2xhdmUgb24gSVIyICovCiAJaWYgKGF1dG9fZW9pKQogCQlv
dXRiX3AoMHgwMywgMHgyMSk7CS8qIG1hc3RlciBkb2VzIEF1dG8gRU9JICovCkBAIC0zMDcsNyAr
MzA3LDcgQEAgdm9pZCBpbml0XzgyNTlBKGludCBhdXRvX2VvaSkKIAkJb3V0Yl9wKDB4MDEsIDB4
MjEpOwkvKiBtYXN0ZXIgZXhwZWN0cyBub3JtYWwgRU9JICovCiAKIAlvdXRiX3AoMHgxMSwgMHhB
MCk7CS8qIElDVzE6IHNlbGVjdCA4MjU5QS0yIGluaXQgKi8KLQlvdXRiX3AoSVJROF9WRUNUT1Is
IDB4QTEpOwkvKiBJQ1cyOiA4MjU5QS0yIElSMC03IG1hcHBlZCB0byAweDI4LTB4MmYgKi8KKwlv
dXRiX3AoSVJROF9WRUNUT1IsIDB4QTEpOwkvKiBJQ1cyOiA4MjU5QS0yIElSMC03IG1hcHBlZCB0
byAweDM4LTB4M2YgKi8KIAlvdXRiX3AoMHgwMiwgMHhBMSk7CS8qIDgyNTlBLTIgaXMgYSBzbGF2
ZSBvbiBtYXN0ZXIncyBJUjIgKi8KIAlvdXRiX3AoMHgwMSwgMHhBMSk7CS8qIChzbGF2ZSdzIHN1
cHBvcnQgZm9yIEFFT0kgaW4gZmxhdCBtb2RlCiAJCQkJICAgIGlzIHRvIGJlIGludmVzdGlnYXRl
ZCkgKi8KZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLXg4Nl82NC9od19pcnEuaCBiL2luY2x1ZGUv
YXNtLXg4Nl82NC9od19pcnEuaAppbmRleCAyZTRiN2E1Li42MTUzYWU1IDEwMDY0NAotLS0gYS9p
bmNsdWRlL2FzbS14ODZfNjQvaHdfaXJxLmgKKysrIGIvaW5jbHVkZS9hc20teDg2XzY0L2h3X2ly
cS5oCkBAIC0zOCw3ICszOCw3IEBACiAjZGVmaW5lIElSUV9NT1ZFX0NMRUFOVVBfVkVDVE9SCUZJ
UlNUX0VYVEVSTkFMX1ZFQ1RPUgogIAogLyoKLSAqIFZlY3RvcnMgMHgyMC0weDJmIGFyZSB1c2Vk
IGZvciBJU0EgaW50ZXJydXB0cy4KKyAqIFZlY3RvcnMgMHgzMC0weDNmIGFyZSB1c2VkIGZvciBJ
U0EgaW50ZXJydXB0cy4KICAqLwogI2RlZmluZSBJUlEwX1ZFQ1RPUgkJRklSU1RfRVhURVJOQUxf
VkVDVE9SICsgMHgxMAogI2RlZmluZSBJUlExX1ZFQ1RPUgkJSVJRMF9WRUNUT1IgKyAxCg==
------=_Part_56787_26742919.1175143718258--
