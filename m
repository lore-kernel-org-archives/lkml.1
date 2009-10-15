Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbZJOOtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbZJOOtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761948AbZJOOtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:49:22 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:61844 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761902AbZJOOtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=hCkOcEKV+qa5bTqyhJBQYcuXJHyu5/vZJ/Lqp8x74RYVKbUuleRT1xlm8evuh1AJOV
         2dzLVW7d8VYL53w1mu/4x+LQsns9f/XT7V6Zcw063jSu2U7wy1kLUCduoxO+W0ZuP9VR
         4rojWuZHdOFc1Av7Edhiz6HoglAiTuyLWz1ZQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Thu, 15 Oct 2009 16:47:48 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc5-01839-gebb8e1d; KDE/4.3.1; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910141728.21491.bzolnier@gmail.com> <43e72e890910140955n295ef8d1m185592af63bc895b@mail.gmail.com>
In-Reply-To: <43e72e890910140955n295ef8d1m185592af63bc895b@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200910151647.49050.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009 18:55:23 Luis R. Rodriguez wrote:
> On Wed, Oct 14, 2009 at 8:28 AM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Wednesday 14 October 2009 16:56:05 John W. Linville wrote:
> >> On Wed, Oct 14, 2009 at 04:52:40PM +0200, Bartlomiej Zolnierkiewicz wrote:
> >> > On Wednesday 14 October 2009 16:09:24 John W. Linville wrote:
> >> > > On Tue, Oct 13, 2009 at 11:57:57PM +0200, Bartlomiej Zolnierkiewicz wrote:
> >> > >
> >> > > > Several months later (after all current users are happy with the improved
> >> > > > drivers) the old drivers will be removed from staging..
> >> > >
> >> > > I _really_ hope this isn't the standard.  By that measure, nothing
> >> > > will ever leave staging as _someone_ will always have some use case
> >> > > that makes the other driver better for them.
> >> >
> >> > Doesn't seem to be the case with all other drivers except wireless ones
> >> > and the only real reason why wireless ones are so special is because of:
> >> >
> >> > "But then there's the users, who bitch about everything and simply do
> >> > not understand what it is at stake.
> >> >
> >> > And all this is becoming way too messy for us to handle.
> >> >
> >> > Personally all I see around me is people bitching and complaining, and
> >> > no code being ported."
> >> >
> >> > attitude which pretty much explains the problem..
> >> >
> >> > Please adjust the process to fix the problem yourself or if you do not
> >> > want to do it just make the room for people who do.
> >>
> >> Alright Bartlomiej, you've had your say.  Perhaps you should go about
> >> your business now.
> >>
> >> John
> >>
> >> P.S. For the record, the "But then there's the users..." quote is
> >> from someone else...
> >
> > ..but you're still fine with its content, right?
> >
> > I also wonder who is really taking advantage of who here (your other mail)..
> >
> > You're holding users as hostages to pressure vendors to fund your projects
> > and try to lure outside developers with the lovely perspective of doing
> > the hardest parts of said projects.
> >
> > I don't have a have a problem with it personally as long as people accept
> > the competition..  but instead of working on _their_ projects they go around
> > screaming at everybody who does not want to spin inside the great process
> > designed by them..
> 
> I hear fishing in Poland is great this time of year.

It got quite cold this week so I thought that I would try to fish
the commit that broke Atheros AR9285 in Linus' tree (works in 2.6.31)
and make recent kernels finally work on my laptop..

Seems like there are two regressions actually:

- later one making association/authentication impossible

- earlier one making transfers stall

There is also a ton of unrelated and related (mac80211) problems in
between so the whole experience to trace regressions down is a real
hell (I went through like 40 kernels already)..

Oh, there is also an ath9k slab corruption already in 2.6.31 (I got
it debugged initially though)..

However today it got a bit warmer and the snow is almost gone so
I think that I'm going to take your advice after using the shortcut
solution for my wireless problems..

I'll just plug that cheap rt3070 stick laying around and modprobe
that crappy rt2870sta..
