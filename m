Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYHaAQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYHaAQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 20:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYHaAQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 20:16:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:64509 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbYHaAQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 20:16:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=Uv4GP4s7HykBriQdC1cmTQxFCAnFoFUyfBHv+5Etj8Z+Q0tjF/UYojv1nwmiCp5nvR
         aCWEdetNbwnEZMAlgxo48m/VMChHyImUMWkroqYBJcyyzP79f28U5xWpzxN6FeBhcjAx
         Jq2YecjMngfhdGZPYOXLsVQWzZMdlsdug/Xos=
Message-ID: <86802c440808301716j46674ab7i8f36d57fb9ed38c1@mail.gmail.com>
Date: Sat, 30 Aug 2008 17:16:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <368766.37978.qm@web82106.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_18238_29942010.1220141781514"
References: <368766.37978.qm@web82106.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_18238_29942010.1220141781514
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> So I decided to try applying the patches against the tree as it was
> before bef69ea0...:
>
> =================================
> $ git checkout -f HEAD^
> Note: moving to "HEAD^" which isn't a local branch
> If you want to create a new branch from this checkout, you may do so
> (now or later) by using -b with the checkout command again. Example:
>  git checkout -b <new_branch_name>
> HEAD is now at 00aeb42... Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
>
> $ git apply --verbose --check ../split_e820_reserve.patch
> Checking patch arch/x86/kernel/e820.c...
> Checking patch arch/x86/pci/i386.c...
> Checking patch include/asm-x86/e820.h...
>
> $ git apply --verbose ../split_e820_reserve.patch
> Checking patch arch/x86/kernel/e820.c...
> Checking patch arch/x86/pci/i386.c...
> Checking patch include/asm-x86/e820.h...
> Applied patch arch/x86/kernel/e820.c cleanly.
> Applied patch arch/x86/pci/i386.c cleanly.
> Applied patch include/asm-x86/e820.h cleanly.
>
> $ git apply --verbose --check ../split_e820_reserve_xx1.patch
> Checking patch arch/x86/kernel/e820.c...
> Checking patch include/linux/ioport.h...
> Checking patch kernel/resource.c...

please use split_e820_reserve_xx2.patch instead...

Thanks

YH

------=_Part_18238_29942010.1220141781514
Content-Type: text/x-patch; name=split_e820_reserve_xx2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkiwuont0
Content-Disposition: attachment; filename=split_e820_reserve_xx2.patch

RnJvbTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgpTdWJqZWN0OiBbUEFUQ0hd
IHg4Njogc3BsaXQgZTgyMCByZXNlcnZlZCBlbnRyaWVzIHJlY29yZCB0byBsYXRlIHY0IC0gZml4
IHY2Cgp0cnkgdG8gaW5zZXJ0X3Jlc291cmNlIHNlY29uZCB0aW1lLCBieSBleHBhbmQgdGhlIHJl
c291cmNlLi4uCgpmb3IgY2FzZTogZTgyMCByZXNlcnZlZCBlbnRyeSBpcyBwYXJ0aWFsbHkgb3Zl
cmxhcHBlZCB3aXRoIGJhciByZXMuLi4KCmhvcGUgaXQgd2lsbCBuZXZlciBoYXBwZW4KCnYyOiBh
Y2NvcmRpbmcgdG8gTGludXMsIGFkZCBpbnNlcnRfcmVzb3VyY2VfZXhwYW5kX3RvX2ZpdCwgYW5k
IGNoYW5nZQoJX19pbnNlcnRfcmVzb3VyY2UgdG8gc3RhdGljIHdpdGhvdXQgbG9jawoKdjM6IHVz
ZSByZXNlcnZlX3JlZ2lvbl93aXRoX3NwbGl0KCkgaW5zdGVhZCB0byBoYW5kIG92ZXJsYXBwaW5n
Cgl3aXRoIHRlc3QgY2FzZSBieSBleHRlbmQgMHhlMDAwMDAwMCAtIDB4ZWZmZmZmZiB0byAweGRk
ODAwMDAwIC0KCWdldAoJCWUwMDAwMDAwLWVmZmZmZmZmIDogUENJIE1NQ09ORklHIDAKCQkJIGUw
MDAwMDAwLWVmZmZmZmZmIDogcmVzZXJ2ZWQKCWluIC9wcm9jL2lvbWVtCglnZXQKCQlmb3VuZCBj
b25mbGljdCBmb3IgcmVzZXJ2ZWQgW2RkODAwMDAwLCBlZmZmZmZmZl0sIHRyeSB0byByZXNlcnZl
IHdpdGggc3BsaXQKCQkgICAgX19yZXNlcnZlX3JlZ2lvbl93aXRoX3NwbGl0OiAoUENJIEJ1cyAj
ODApIFtkZDAwMDAwMCwgZGRmZmZmZmZdLCByZXM6IChyZXNlcnZlZCkgW2RkODAwMDAwLCBlZmZm
ZmZmZl0KCQkgICAgX19yZXNlcnZlX3JlZ2lvbl93aXRoX3NwbGl0OiAoUENJIEJ1cyAjMDApIFtk
ZTAwMDAwMCwgZGZmZmZmZmZdLCByZXM6IChyZXNlcnZlZCkgW2RlMDAwMDAwLCBlZmZmZmZmZl0K
CQlpbml0Y2FsbCBwY2lfc3Vic3lzX2luaXQrMHgwLzB4MTIxIHJldHVybmVkIDAgYWZ0ZXIgMzgx
IG1zZWNzCglpbiBkbWVzZwoKdjQ6IHRha2Ugb3V0IF9faW5zZXJ0X3Jlc291cmNlIGFuZCBpbnNl
cnRfcmVzb3VyY2VfZXhwYW5kX3RvX2ZpdCA6IExpbnVzIGFscmVhZHkgY2hlY2sgaW4uCiAgICB1
c2UgcmVzZXJ2ZV9yZWdpb25fd2l0aF9zcGxpdCBhdCB0aGUgZmlyc3QgcG9pbnQKICAgIHVzZSBj
b25zdCBjaGFyICpuYW1lCgp2NTogZml4IGNoZWNraW5nIG9uIG92ZXJsYXBwaW5nCgp2Njogb25s
eSByZXNlcnZlIGNvbW1vbiBhcmVhIGluIGNvbmZsaWN0CglzbyBnb3Qgc3RoIGluIC9wcm9jL2lv
bWVtCgkJZDgwMDAwMDAtZGZmZmZmZmYgOiBQQ0kgQnVzICMwMAoJCSAgZGMwMDAwMDAtZGZmZmZm
ZmYgOiBHQVJUCgkJICAgIGRjMDAwMDAwLWRmZmZmZmZmIDogcmVzZXJ2ZWQKCQllMDAwMDAwMC1l
ZmZmZmZmZiA6IFBDSSBNTUNPTkZJRyAwCgkJICBlMDAwMDAwMC1lZmZmZmZmZiA6IHJlc2VydmVk
Cgl3aGVuIHdlIGhhdmUgYmlnIHJhbmdlIGluIGU4MjAKCQkwMDAwMDAwMGRjMDAwMDAwLTAwMDAw
MDAwZjAwMDAwMDAgKHJlc2VydmVkKQoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5r
ZXJuZWxAZ21haWwuY29tPgoKLS0tCiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICAgMiAtCiBp
bmNsdWRlL2xpbnV4L2lvcG9ydC5oIHwgICAgMyArKwoga2VybmVsL3Jlc291cmNlLmMgICAgICB8
ICAgNjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQog
MyBmaWxlcyBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKSW5kZXg6
IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIu
Ni5vcmlnL2FyY2gveDg2L2tlcm5lbC9lODIwLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJu
ZWwvZTgyMC5jCkBAIC0xMzIwLDcgKzEzMjAsNyBAQCB2b2lkIF9faW5pdCBlODIwX3Jlc2VydmVf
cmVzb3VyY2VzX2xhdGUoCiAJcmVzID0gZTgyMF9yZXM7CiAJZm9yIChpID0gMDsgaSA8IGU4MjAu
bnJfbWFwOyBpKyspIHsKIAkJaWYgKCFyZXMtPnBhcmVudCAmJiByZXMtPmVuZCkKLQkJCWluc2Vy
dF9yZXNvdXJjZSgmaW9tZW1fcmVzb3VyY2UsIHJlcyk7CisJCQlyZXNlcnZlX3JlZ2lvbl93aXRo
X3NwbGl0KCZpb21lbV9yZXNvdXJjZSwgcmVzLT5zdGFydCwgcmVzLT5lbmQsIHJlcy0+bmFtZSk7
CiAJCXJlcysrOwogCX0KIH0KSW5kZXg6IGxpbnV4LTIuNi9pbmNsdWRlL2xpbnV4L2lvcG9ydC5o
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2luY2x1ZGUvbGludXgvaW9wb3J0LmgKKysr
IGxpbnV4LTIuNi9pbmNsdWRlL2xpbnV4L2lvcG9ydC5oCkBAIC0xMDgsNiArMTA4LDkgQEAgZXh0
ZXJuIHN0cnVjdCByZXNvdXJjZSBpb21lbV9yZXNvdXJjZTsKIAogZXh0ZXJuIGludCByZXF1ZXN0
X3Jlc291cmNlKHN0cnVjdCByZXNvdXJjZSAqcm9vdCwgc3RydWN0IHJlc291cmNlICpuZXcpOwog
ZXh0ZXJuIGludCByZWxlYXNlX3Jlc291cmNlKHN0cnVjdCByZXNvdXJjZSAqbmV3KTsKK2V4dGVy
biB2b2lkIHJlc2VydmVfcmVnaW9uX3dpdGhfc3BsaXQoc3RydWN0IHJlc291cmNlICpyb290LAor
CQkJICAgICByZXNvdXJjZV9zaXplX3Qgc3RhcnQsIHJlc291cmNlX3NpemVfdCBlbmQsCisJCQkg
ICAgIGNvbnN0IGNoYXIgKm5hbWUpOwogZXh0ZXJuIGludCBpbnNlcnRfcmVzb3VyY2Uoc3RydWN0
IHJlc291cmNlICpwYXJlbnQsIHN0cnVjdCByZXNvdXJjZSAqbmV3KTsKIGV4dGVybiB2b2lkIGlu
c2VydF9yZXNvdXJjZV9leHBhbmRfdG9fZml0KHN0cnVjdCByZXNvdXJjZSAqcm9vdCwgc3RydWN0
IHJlc291cmNlICpuZXcpOwogZXh0ZXJuIGludCBhbGxvY2F0ZV9yZXNvdXJjZShzdHJ1Y3QgcmVz
b3VyY2UgKnJvb3QsIHN0cnVjdCByZXNvdXJjZSAqbmV3LApJbmRleDogbGludXgtMi42L2tlcm5l
bC9yZXNvdXJjZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2tlcm5lbC9yZXNvdXJj
ZS5jCisrKyBsaW51eC0yLjYva2VybmVsL3Jlc291cmNlLmMKQEAgLTUxMiwxMCArNTEyLDc3IEBA
IGludCBhZGp1c3RfcmVzb3VyY2Uoc3RydWN0IHJlc291cmNlICpyZXMKIAlyZXN1bHQgPSAwOwog
CiAgb3V0OgotCXdyaXRlX3VubG9jaygmcmVzb3VyY2VfbG9jayk7CiAJcmV0dXJuIHJlc3VsdDsK
IH0KIAorc3RhdGljIHZvaWQgX19pbml0IF9fcmVzZXJ2ZV9yZWdpb25fd2l0aF9zcGxpdChzdHJ1
Y3QgcmVzb3VyY2UgKnJvb3QsCisJCXJlc291cmNlX3NpemVfdCBzdGFydCwgcmVzb3VyY2Vfc2l6
ZV90IGVuZCwKKwkJY29uc3QgY2hhciAqbmFtZSkKK3sKKwlzdHJ1Y3QgcmVzb3VyY2UgKnBhcmVu
dCA9IHJvb3Q7CisJc3RydWN0IHJlc291cmNlICpjb25mbGljdDsKKwlzdHJ1Y3QgcmVzb3VyY2Ug
KnJlcyA9IGt6YWxsb2Moc2l6ZW9mKCpyZXMpLCBHRlBfS0VSTkVMKTsKKworCWlmICghcmVzKQor
CQlyZXR1cm47CisKKwlyZXMtPm5hbWUgPSBuYW1lOworCXJlcy0+c3RhcnQgPSBzdGFydDsKKwly
ZXMtPmVuZCA9IGVuZDsKKwlyZXMtPmZsYWdzID0gSU9SRVNPVVJDRV9CVVNZOworCisJZm9yICg7
OykgeworCQljb25mbGljdCA9IF9fcmVxdWVzdF9yZXNvdXJjZShwYXJlbnQsIHJlcyk7CisJCWlm
ICghY29uZmxpY3QpCisJCQlicmVhazsKKwkJaWYgKGNvbmZsaWN0ICE9IHBhcmVudCkgeworCQkJ
cGFyZW50ID0gY29uZmxpY3Q7CisJCQlpZiAoIShjb25mbGljdC0+ZmxhZ3MgJiBJT1JFU09VUkNF
X0JVU1kpKQorCQkJCWNvbnRpbnVlOworCQl9CisKKwkJLyogVWhodWgsIHRoYXQgZGlkbid0IHdv
cmsgb3V0Li4gKi8KKwkJa2ZyZWUocmVzKTsKKwkJcmVzID0gTlVMTDsKKwkJYnJlYWs7CisJfQor
CisJaWYgKCFyZXMpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgIiAgICBfX3Jlc2VydmVfcmVnaW9u
X3dpdGhfc3BsaXQ6ICglcykgWyVsbHgsICVsbHhdLCByZXM6ICglcykgWyVsbHgsICVsbHhdXG4i
LAorCQkJIGNvbmZsaWN0LT5uYW1lLCBjb25mbGljdC0+c3RhcnQsIGNvbmZsaWN0LT5lbmQsCisJ
CQkgbmFtZSwgc3RhcnQsIGVuZCk7CisKKwkJLyogZmFpbGVkLCBzcGxpdCBhbmQgdHJ5IGFnYWlu
ICovCisKKwkJLyogY29uZmxpY3QgY292ZXJyZWQgd2hvbGUgYXJlYSAqLworCQlpZiAoY29uZmxp
Y3QtPnN0YXJ0IDw9IHN0YXJ0ICYmIGNvbmZsaWN0LT5lbmQgPj0gZW5kKQorCQkJcmV0dXJuOwor
CisJCWlmIChjb25mbGljdC0+c3RhcnQgPiBzdGFydCkKKwkJCV9fcmVzZXJ2ZV9yZWdpb25fd2l0
aF9zcGxpdChyb290LCBzdGFydCwgY29uZmxpY3QtPnN0YXJ0LTEsIG5hbWUpOworCQlpZiAoIShj
b25mbGljdC0+ZmxhZ3MgJiBJT1JFU09VUkNFX0JVU1kpKSB7CisJCQlyZXNvdXJjZV9zaXplX3Qg
Y29tbW9uX3N0YXJ0LCBjb21tb25fZW5kOworCisJCQljb21tb25fc3RhcnQgPSBtYXgoY29uZmxp
Y3QtPnN0YXJ0LCBzdGFydCk7CisJCQljb21tb25fZW5kID0gbWluKGNvbmZsaWN0LT5lbmQsIGVu
ZCk7CisJCQlpZiAoY29tbW9uX3N0YXJ0IDwgY29tbW9uX2VuZCkKKwkJCQlfX3Jlc2VydmVfcmVn
aW9uX3dpdGhfc3BsaXQocm9vdCwgY29tbW9uX3N0YXJ0LCBjb21tb25fZW5kLCBuYW1lKTsKKwkJ
fQorCQlpZiAoY29uZmxpY3QtPmVuZCA8IGVuZCkKKwkJCV9fcmVzZXJ2ZV9yZWdpb25fd2l0aF9z
cGxpdChyb290LCBjb25mbGljdC0+ZW5kKzEsIGVuZCwgbmFtZSk7CisJfQorCit9CisKK3ZvaWQg
cmVzZXJ2ZV9yZWdpb25fd2l0aF9zcGxpdChzdHJ1Y3QgcmVzb3VyY2UgKnJvb3QsCisJCXJlc291
cmNlX3NpemVfdCBzdGFydCwgcmVzb3VyY2Vfc2l6ZV90IGVuZCwKKwkJY29uc3QgY2hhciAqbmFt
ZSkKK3sKKwl3cml0ZV9sb2NrKCZyZXNvdXJjZV9sb2NrKTsKKwlfX3Jlc2VydmVfcmVnaW9uX3dp
dGhfc3BsaXQocm9vdCwgc3RhcnQsIGVuZCwgbmFtZSk7CisJd3JpdGVfdW5sb2NrKCZyZXNvdXJj
ZV9sb2NrKTsKK30KKwogRVhQT1JUX1NZTUJPTChhZGp1c3RfcmVzb3VyY2UpOwogCiAvKioK
------=_Part_18238_29942010.1220141781514--
