Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbXGVWtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbXGVWtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbXGVWtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:49:45 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20002 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbXGVWto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=om+aZuQLd2jbyZiyT1dUB/+WVsTJSRcT3ELut+Gl5T00mXwR9bh3TgWrOOV/QAdFpsWc9aGIihlx8k3riF2xUmyiMIj2spwyteGWRg5qYtPAY1nqPQra00iQcKNWs+VrkSoblyZx4mb4E8gpETQ5bn055AFWTV7fHjfwCDIP96c=
Message-ID: <f56c1ba00707221549k768d7df9ke983160e634f4fe3@mail.gmail.com>
Date: Sun, 22 Jul 2007 18:49:43 -0400
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: voyager_{thread,cat}.c compile warnings
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       J.E.J.Bottomley@HansenPartnership.com
In-Reply-To: <f56c1ba00707220833m267491afg277a028e6c103e31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_104686_5051441.1185144583452"
References: <46A282B2.8070501@googlemail.com>
	 <f56c1ba00707220833m267491afg277a028e6c103e31@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_104686_5051441.1185144583452
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

2007/7/22, C=E9dric Augonnet <cedric.augonnet@gmail.com>:
> Hi,
>
> 2007/7/21, Gabriel C <nix.or.die@googlemail.com>:
> > Hi,
> >
> > I noticed this warnings on current git:
> >
> >
> > ...
> >
> > arch/i386/mach-voyager/voyager_thread.c: In function 'thread':
> > arch/i386/mach-voyager/voyager_thread.c:113: warning: no return stateme=
nt in function returning non-void
> >
> > ...
> >
> > I think return 0; is missing on line 112 here.
> >
>
> I guess there is no use in always returning 0, simply not returning anyth=
ing and
> putting a void type might be cleaner, especially as this function
> seems to never
> return.
>
> >
> > arch/i386/mach-voyager/voyager_cat.c: In function 'voyager_cat_init':
> > arch/i386/mach-voyager/voyager_cat.c:685: warning: comparison is always=
 false due to limited range of data type
> > arch/i386/mach-voyager/voyager_cat.c:755: warning: comparison is always=
 false due to limited range of data type
> >
>
> Hum perhaps it does not like the comparision of a __u16 and an unsigned i=
nt ?
>
> I enclose some dummy patch that should perhaps solve these issues,
> could not test it as i don't have the hardware... just my 2 cents.
> Don't know if casting is an
> acceptable workaround though.
>
> >
> >
> > Regards,
> >
> > Gabriel C
> >
>
> Cheers,
> C=E9dric
>
>

(forgot to cc the maintainer, sorry ...)

------=_Part_104686_5051441.1185144583452
Content-Type: text/x-diff; name="voyager.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="voyager.patch"
X-Attachment-Id: f_f4g4gtep

U3VibWl0dGVkIGJ5OiBDZWRyaWMgQXVnb25uZXQgPGNlZHJpYy5hdWdvbm5ldEBlbnMtbHlvbi5v
cmc+Ci0tLQpkaWZmIC11ck4gYS9hcmNoL2kzODYvbWFjaC12b3lhZ2VyL3ZveWFnZXJfY2F0LmMg
Yi9hcmNoL2kzODYvbWFjaC12b3lhZ2VyL3ZveWFnZXJfY2F0LmMKLS0tIC9ob21lL2dvbm5ldC90
bXAvbGludXgtMi42LjIyL2FyY2gvaTM4Ni9tYWNoLXZveWFnZXIvdm95YWdlcl9jYXQuYwkyMDA3
LTA3LTIwIDExOjUwOjE3LjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjIyL2FyY2gvaTM4
Ni9tYWNoLXZveWFnZXIvdm95YWdlcl9jYXQuYwkyMDA3LTA3LTIyIDExOjI0OjM0LjAwMDAwMDAw
MCAtMDQwMApAQCAtNjgyLDcgKzY4Miw3IEBACiAJCQlvdXRiKFZPWUFHRVJfQ0FUX0VORCwgQ0FU
X0NNRCk7CiAJCQljb250aW51ZTsKIAkJfQotCQlpZihlcHJvbV9zaXplID4gc2l6ZW9mKGVwcm9t
X2J1ZikpIHsKKwkJaWYoKHVuc2lnbmVkKWVwcm9tX3NpemUgPiBzaXplb2YoZXByb21fYnVmKSkg
ewogCQkJcHJpbnRrKCIqKldBUk5JTkcqKjogVm95YWdlciBpbnN1ZmZpY2llbnQgc2l6ZSB0byBy
ZWFkIEVQUk9NIGRhdGEsIG1vZHVsZSAweCV4LiAgTmVlZCAlZFxuIiwgaSwgZXByb21fc2l6ZSk7
CiAJCQlvdXRiKFZPWUFHRVJfQ0FUX0VORCwgQ0FUX0NNRCk7CiAJCQljb250aW51ZTsKQEAgLTc1
Miw3ICs3NTIsNyBAQAogCQkJb3V0YihWT1lBR0VSX0NBVF9FTkQsIENBVF9DTUQpOwogCQkJY29u
dGludWU7CiAJCX0KLQkJaWYoZXByb21fc2l6ZSA+IHNpemVvZihlcHJvbV9idWYpKSB7CisJCWlm
KCh1bnNpZ25lZCllcHJvbV9zaXplID4gc2l6ZW9mKGVwcm9tX2J1ZikpIHsKIAkJCXByaW50aygi
KipXQVJOSU5HKio6IFZveWFnZXIgaW5zdWZmaWNpZW50IHNpemUgdG8gcmVhZCBFUFJPTSBkYXRh
LCBtb2R1bGUgMHgleC4gIE5lZWQgJWRcbiIsIGksIGVwcm9tX3NpemUpOwogCQkJb3V0YihWT1lB
R0VSX0NBVF9FTkQsIENBVF9DTUQpOwogCQkJY29udGludWU7CmRpZmYgLXVyTiBhL2FyY2gvaTM4
Ni9tYWNoLXZveWFnZXIvdm95YWdlcl90aHJlYWQuYyBiL2FyY2gvaTM4Ni9tYWNoLXZveWFnZXIv
dm95YWdlcl90aHJlYWQuYwotLS0gL2hvbWUvZ29ubmV0L3RtcC9saW51eC0yLjYuMjIvYXJjaC9p
Mzg2L21hY2gtdm95YWdlci92b3lhZ2VyX3RocmVhZC5jCTIwMDctMDctMjAgMTE6NTA6MTcuMDAw
MDAwMDAwIC0wNDAwCisrKyBsaW51eC0yLjYuMjIvYXJjaC9pMzg2L21hY2gtdm95YWdlci92b3lh
Z2VyX3RocmVhZC5jCTIwMDctMDctMjIgMTE6Mjc6MTMuMDAwMDAwMDAwIC0wNDAwCkBAIC05Miw3
ICs5Miw3IEBACiAJfQogfQogCi1zdGF0aWMgaW50CitzdGF0aWMgdm9pZAogdGhyZWFkKHZvaWQg
KnVudXNlZCkKIHsKIAlwcmludGsoS0VSTl9OT1RJQ0UgIlZveWFnZXIgc3RhcnRpbmcgbW9uaXRv
ciB0aHJlYWRcbiIpOwo=
------=_Part_104686_5051441.1185144583452--
