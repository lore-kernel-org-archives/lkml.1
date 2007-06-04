Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbXFDOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbXFDOtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXFDOt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:49:26 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:41649 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbXFDOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=lfriZTRN/AYeR9GHQheK9wi1JbizQ1KmUCkkPCxL0bgmYKJ8DeyljKG+p729P3HGJBdSnhNnkY9K+95hWxURjB37UIJx67eREbtNc7kvEHOnRyngUhZHEHWUdlZD8X7RoQxyKcvCpHycZN1QJwBYjnWTF2sozLn/SNRvSnRUg6s=
Message-ID: <25ae38200706040749o1eb3b7bbs64a09e6c2e4d7331@mail.gmail.com>
Date: Mon, 4 Jun 2007 07:49:24 -0700
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: Patch related with Fork Bombing Atack
Cc: Nix <nix@esperi.org.uk>, "Jens Axboe" <jens.axboe@oracle.com>,
       security@kernel.org, linux-kernel@vger.kernel.org,
       "Kedar Sovani" <kedar@dreamzgroup.com>
In-Reply-To: <200706032129.29088.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2711_6169995.1180968564312"
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
	 <20070601073020.GL32105@kernel.dk> <87odjw8wxq.fsf@hades.wkstn.nix>
	 <200706032129.29088.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2711_6169995.1180968564312
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello All
            I am forwarding one improved patch related with Fork
Bombing Attack. This patch prints a message (only once) which alerts
administrator/root user about fork bombing attack. I created this
patch to implement my idea of informing administrator about fork
bombing attack on his machine only once.
    This patch overcomes all drawbacks of my previous patch related
with fork bombing attack and helps administrator. added comments will
definitely help developers.

Regards
Anand


On 6/3/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> On Sunday 03 June 2007 19:01:21 Nix wrote:
> > On 1 Jun 2007, Jens Axboe told this:
> > > I think Anand is assuming that because syslog may coalesce identical
> > > messages into "repeated foo times" in the messages file, that it's not a
> > > dos. That is of course wrong.
> >
> > Not all syslog daemons do that, anyway. (syslog-ng doesn't, for one.)
>
> That syslog-ng doesn't coalesce repeated messages into a single line doesn't
> make a difference. The printk_ratelimit stuff is supposed to make it very
> hard to DOS a system by flooding syslog, but that doesn't mean its
> impossible.
>
> The point of this discussion was that having a part of the kernel log a
> message about a fork-bomb was a very large whole that could be used to DOS a
> system by flooding the syslog. (In fact, IIRC, the printk_ratelimit (and
> somebody, please correct me if I'm wrong) stuff uses a ring buffer and
> seriously spamming syslog, like the patch that spawned this thread would have
> done, could cause you to lose potentially important messages)
>
> DRH
>

------=_Part_2711_6169995.1180968564312
Content-Type: application/octet-stream; name=fork.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2jt6tiw
Content-Disposition: attachment; filename="fork.patch"

SW5kZXg6IHJvb3QvRGVza3RvcC9hMS9saW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0y
LjYuMTcva2VybmVsL2ZvcmsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSByb290Lm9yaWcvRGVza3RvcC9hMS9s
aW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0yLjYuMTcva2VybmVsL2ZvcmsuYwkyMDA3
LTA2LTA0IDE3OjQ2OjAzLjAwMDAwMDAwMCArMDUzMAorKysgcm9vdC9EZXNrdG9wL2ExL2xpbnV4
LTIuNi4xNy50YXIuYnoyX0ZJTEVTL2xpbnV4LTIuNi4xNy9rZXJuZWwvZm9yay5jCTIwMDctMDYt
MDQgMTc6NDc6MTQuMDAwMDAwMDAwICswNTMwCkBAIC05NTcsNyArOTU3LDE5IEBACiAKIAlyZXR2
YWwgPSAtRUFHQUlOOwogCQorCS8qCisJICogZm9sbG93aW5nIGNvZGUgcHJpbnRzIGEgbWVzc2Fn
ZSB3aGljaCBhbGVydHMgYWRtaW5pc3RyYXRvci9yb290IAkJICogdXNlciBhYm91dCBmb3JrIGJv
bWJpbmcgQXR0YWNrCisJICovCisJaWYgKChhdG9taWNfcmVhZCgmcC0+dXNlci0+cHJvY2Vzc2Vz
KSA+PSAocC0+c2lnbmFsLT5ybGltCVtSTElNSVRfTlBST0NdLnJsaW1fY3VyIC0gMSkpICYmIChh
dG9taWNfcmVhZCgmcC0+dXNlci0+cHJvY2Vzc2VzKSA8IHAtPnNpZ25hbC0+cmxpbVtSTElNSVRf
TlBST0NdLnJsaW1fY3VyKSkgeworICAgICAgICAJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4p
ICYmICFjYXBhYmxlKENBUF9TWVNfUkVTT1VSQ0UpICYmIHAtPnVzZXIgIT0gJnJvb3RfdXNlcikg
eworICAgICAgICAJCXByaW50ayhLRVJOX0NSSVQiVXNlciB3aXRoIHVpZCAlZCBpcyBjcm9zc2lu
ZyBpdHMgUHJvY2VzcyBsaW1pdFxuIixwLT51c2VyLT51aWQpOworICAgICAgICAJfQorCX0KIAor
CS8qCisJICogZm9sbG93aW5nIGNvZGUgZG9lcyBub3QgYWxsb3cgTm9uIFJvb3QgVXNlciB0byBj
cm9zcyBpdHMgcHJvY2VzcyAKKwkgKiBsaW1pdCBhbmQgaXQgcHJldmVudHMgRm9yayBCb21iaW5n
IEF0dGFjay4KKwkgKi8KIAlpZiAoYXRvbWljX3JlYWQoJnAtPnVzZXItPnByb2Nlc3NlcykgPj0g
cC0+c2lnbmFsLT5ybGltW1JMSU1JVF9OUFJPQ10ucmxpbV9jdXIpIAogCQlpZiAoIWNhcGFibGUo
Q0FQX1NZU19BRE1JTikgJiYgIWNhcGFibGUoQ0FQX1NZU19SRVNPVVJDRSkgJiYKIAkJCQlwLT51
c2VyICE9ICZyb290X3VzZXIpIAo=
------=_Part_2711_6169995.1180968564312--
