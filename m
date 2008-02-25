Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYBYHXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYBYHXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYBYHXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:23:13 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:20600 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYBYHXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=JQaTJNn0Id7P3LKOINpAwUUAVlm2skyBNfO704qVA459Xr4bLzdsp4WXyuxE2t63+tBs8PkOYyqM36Oc9fGqPhHiEvXTmc9PzHr0IlpyD/4x5U5CphgtGXLg0pkORSbJIDV2yzVJu0orzhVJ7o+RVxfEZnujwquzYD1TQhgpd8M=
Message-ID: <86802c440802242323p58d0e234q9b6f33449c8ebaf8@mail.gmail.com>
Date: Sun, 24 Feb 2008 23:23:09 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.26-git0: IDE oops during boot
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Nish Aravamudan" <nish.aravamudan@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       ananth@in.ibm.com, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <86802c440802242305o7cfce4d1h6444aab01304cb21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6718_18203860.1203924189797"
References: <20080206105334.GA3664@elf.ucw.cz>
	 <200802112035.39462.bzolnier@gmail.com>
	 <47B16113.1060807@linux.vnet.ibm.com>
	 <200802140000.10639.bzolnier@gmail.com>
	 <47B40DF2.10009@linux.vnet.ibm.com>
	 <86802c440802140228q5f6a606cyee01c711fd349571@mail.gmail.com>
	 <47B57436.5020806@linux.vnet.ibm.com>
	 <86802c440802242305o7cfce4d1h6444aab01304cb21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6718_18203860.1203924189797
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Feb 24, 2008 at 11:05 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, Feb 15, 2008 at 3:15 AM, Kamalesh Babulal
>
> <kamalesh@linux.vnet.ibm.com> wrote:
>  >
>  >
>
> >  Thanks for pointing the patch, I do not have the SES config option enabled,
>  >  then too i tried your patch, but that does not solve the panic. The kernel
>  >  panic's with the same panic message as before. I have attached the .config
>  >  file which i am using, please let me know if i am missing out/getting wrong
>  >  any option in the configuration.
>
>  can you try x86.git#testing?
>
>  http://people.redhat.com/mingo/x86.git/README
>

and try attached patch.

YH

------=_Part_6718_18203860.1203924189797
Content-Type: text/x-patch; name=fix_intel_numa.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fd2po0bj0
Content-Disposition: attachment; filename=fix_intel_numa.patch

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9zZXR1cF82NC5jIGIvYXJjaC94ODYva2VybmVs
L3NldHVwXzY0LmMKaW5kZXggNmZkODA0Zi4uZjBkNmE4MCAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a2VybmVsL3NldHVwXzY0LmMKKysrIGIvYXJjaC94ODYva2VybmVsL3NldHVwXzY0LmMKQEAgLTgw
MSw3ICs4MDEsNyBAQCBzdGF0aWMgdm9pZCBfX2NwdWluaXQgc3JhdF9kZXRlY3Rfbm9kZSh2b2lk
KQogCS8qIERvbid0IGRvIHRoZSBmdW5reSBmYWxsYmFjayBoZXVyaXN0aWNzIHRoZSBBTUQgdmVy
c2lvbiBlbXBsb3lzCiAJICAgZm9yIG5vdy4gKi8KIAlub2RlID0gYXBpY2lkX3RvX25vZGVbYXBp
Y2lkXTsKLQlpZiAobm9kZSA9PSBOVU1BX05PX05PREUpCisJaWYgKG5vZGUgPT0gTlVNQV9OT19O
T0RFIHx8ICFub2RlX29ubGluZShub2RlKSkKIAkJbm9kZSA9IGZpcnN0X25vZGUobm9kZV9vbmxp
bmVfbWFwKTsKIAludW1hX3NldF9ub2RlKGNwdSwgbm9kZSk7CiAK
------=_Part_6718_18203860.1203924189797--
