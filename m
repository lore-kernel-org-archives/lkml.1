Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZJBVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZJBVha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZJBVha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:37:30 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:46460 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZJBVh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NWG6LFiR3juQEVq/gqiY+yrjPsnpJrOM0K0zf1M6dyt0ihu7fSq+ZicAAghM5gcXOM
         ERSjId6jSNFVXzlSNIHrY+q7IE5q3BEcsJExO0YWJZoc/CUSQk/KjAv/2t7UT4h2NZ6I
         Xxgzs/uXee0ngLxwzMoCXCOmvi+bKK8tPbSTY=
MIME-Version: 1.0
In-Reply-To: <200910021917.31509.rjw@sisk.pl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <COE24pZSBH.A.A5C.VOTxKB@chimera>
	 <b637ec0b0910020012n57e110cbl180aa5bda318e5d5@mail.gmail.com>
	 <200910021917.31509.rjw@sisk.pl>
Date: Fri, 2 Oct 2009 23:37:32 +0200
Message-ID: <b637ec0b0910021437l5a011f13qfa4dd541607a6dfb@mail.gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Oct 2, 2009 at 7:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 02 October 2009, Fabio Comolli wrote:
>> Hi.
>> I suppose this is still valid. I had to work around it by rfkill-ing
>> the device during the suspend process and reenabling at resume time.
>
> Thanks for the update.
>
>> I can try to reproduce it with 2.6.31.1 if you want it.
>
> In fact I'm more interested in whether or not it's still present in the Linus'
> tree.
>

Well, I just tried 2.6.32-rc1-git3 and I have to say that it's mostly
useless with my eeepc. The warning didn't show up after resume but it
was impossible to reassociate with my AP and after some tentative the
screen went blank.

I was able to poweroff the netbook using the power button but I'm a
little scared to try again.

Maybe I'll try with -rc3 or something.

> Thanks,
> Rafael
>

Regards,
Fabio
