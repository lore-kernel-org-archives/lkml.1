Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYDWT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYDWT1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYDWT0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:26:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:50337 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbYDWT0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WYxN9/3rv0L0LbcaMp+jLAg2w2NWsKaGFomaNG/GUNyPvFdGRn0464sfXvCt9N5gDO8aL+gYayo5/P85WnVZiTwfvyOpWtfdVboNSSqfRS6tjmftY6PDswrNt9I7Z8kIciqjGSyM23DVMSO8m0VY9n/NtILS5jilZVPEfaPAGPw=
Message-ID: <53208a5f0804231226n3cf04ea5ja3cebb5584886183@mail.gmail.com>
Date: Thu, 24 Apr 2008 04:26:46 +0900
From: "Frank Bennett" <biercenator@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
Cc: "Michael Krufky" <mkrufky@linuxtv.org>,
       "Hans Verkuil" <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       ivtv-devel@ivtvdriver.org
In-Reply-To: <20080423143454.0d50b209@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080420122736.20d60eff@the-village.bc.nu>
	 <200804201806.33464.hverkuil@xs4all.nl> <480B6AD8.9090404@linuxtv.org>
	 <20080423143454.0d50b209@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maruo,

I don't want to make your life more complicated than necessary, but
while we're on the topic of attribution ...

The real work in identifying this issue was done by Andrew Macks, the
engineer at Skype. My role in the affair consisted of complaining,
sending along a log file, recompiling the kernel, and writing an email
message.

I relayed the initial response I received from Hans Verkuil to Andrew
(via skype chat, I do not have an email address for him), to let him
know that the problem was being addressed in the kernel, and he was
glad to hear the news. But watching things unfold, I have been feeling
slightly incomfortable that only my name might end up in the chain of
correspondence, and not his.  I would just like to slip in a note here
to that effect.

Frank Bennett



On Thu, Apr 24, 2008 at 2:34 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Sun, 20 Apr 2008 12:10:00 -0400
>  Michael Krufky <mkrufky@linuxtv.org> wrote:
>
>  > Hans Verkuil wrote:
>  > > On Sunday 20 April 2008 13:27:36 Alan Cox wrote:
>  > >
>  > >> Frank Bennett reported that ivtv was causing skype to crash. With
>  > >> help from one of their developers he showed it was a kernel problem.
>  > >> VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
>  > >> that are too long and does not truncate them so corrupts a few bytes
>  > >> of the app data area.
>  > >>
>  > >> Possibly the names also want trimming but for now this should fix the
>  > >> corruption case.
>  > >>
>  > >
>  > > Ouch, nasty one.
>  > >
>  > > Mauro, can you apply this patch to the v4l-dvb master?
>  > >
>  > > Mike, this one should obviously go into a 2.6.25 dot-release, and I
>  > > think also to a 2.6.24 dot-release.
>  > >
>  > > Frank, thank you for reporting this!
>  > >
>  > >     Hans
>  > >
>  > > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>  > >
>  >
>  > Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>
>  In this case, it should be reviewed-by.
>
>  I should be sending this soon to Linus.
>
>  Cheers,
>  Mauro
>
