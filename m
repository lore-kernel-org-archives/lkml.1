Return-Path: <linux-kernel-owner+w=401wt.eu-S1762919AbZJOTHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919AbZJOTHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbZJOTHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:07:54 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43488 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761500AbZJOTHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kCzUMZOhaFHd5XtHmW096eL9p1P2Zy6VvvQhN1D3jkOECpwcM0j5XCJS5A0IyHBsDs
         qQhTxAoE/Y2Y0NzOY0e4eQ7qxkOtmPZlIIKxOaAZum0s/iCHyl7lx9rcWk7lRfIKOQC0
         vTSW0ZEnyPiYt8nBvm7feNIUvLr0TTMqCfZuE=
MIME-Version: 1.0
In-Reply-To: <200910151647.49050.bzolnier@gmail.com>
References: <4AD46380.9020308@pardus.org.tr> <200910141728.21491.bzolnier@gmail.com> 
	<43e72e890910140955n295ef8d1m185592af63bc895b@mail.gmail.com> 
	<200910151647.49050.bzolnier@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 15 Oct 2009 12:06:55 -0700
Message-ID: <43e72e890910151206y59353608p5065f72eebd72ab@mail.gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 7:47 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Wednesday 14 October 2009 18:55:23 Luis R. Rodriguez wrote:
>
>> I hear fishing in Poland is great this time of year.
>
> It got quite cold this week so I thought that I would try to fish
> the commit that broke Atheros AR9285 in Linus' tree (works in 2.6.31)
> and make recent kernels finally work on my laptop..
>
> Seems like there are two regressions actually:
>
> - later one making association/authentication impossible

And you reported this when and where?

> - earlier one making transfers stall

And you reported this when and where?

Curious how the issues you mention now spreading across sound and
wireless do not get fixed or seriously addressed. Have you considered
your tactics are perhaps not the best?

Have you tested newer kernels for ar9285? If there are regressions
obviously they should be fixed but without proper attention to the
issues they obviously cannot be fixed.

> There is also a ton of unrelated and related (mac80211) problems in
> between so the whole experience to trace regressions down is a real
> hell (I went through like 40 kernels already)..

I do agree there has been a hell of a lot of changes on
mac80211/cfg80211 over the last few kernels and you can argue whether
or not this has been a good thing -- personally I think it has had its
negative impact on users on older kernels but I do value the new
changes and most major changes have gone in right after the merge
window without opposition. When there are issues I at least do believe
we are attentive enough to help users and solve them on wireless and
contrary to staging you will at least have a larger group of members
working on the same wireless subsystem rather than addressing pigeon
hole solutions.

If you don't voice your own opinions and provide constructive
criticism instead of pointless and side tracked rants you are not
going to accomplish shit. So if you want to want to work on staging --
go at it -- but don't moan and bitch about how wireless proper is
being treated if you are not willing to man up and do something about
it.

> Oh, there is also an ath9k slab corruption already in 2.6.31 (I got
> it debugged initially though)..

We track reported ath9k bugs here:

http://wireless.kernel.org/en/users/Drivers/ath9k/bugs

When there is a bug report we follow up on it.

> However today it got a bit warmer and the snow is almost gone so
> I think that I'm going to take your advice after using the shortcut
> solution for my wireless problems..
>
> I'll just plug that cheap rt3070 stick laying around and modprobe
> that crappy rt2870sta..

Good luck with that buddy.

  Luis
