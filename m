Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZJPRPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZJPRPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZJPRPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:15:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33615 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZJPRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=BZX2eBYNRJTGOtWvDz9IK6dEjwZk8GCGQVIzLssigj2MLg/deeHu4OII7lwYhU7D2d
         8IoUCCCFRtr+uOmFRrgCtps+7yZI8NLaViVDKO3usNINoaFvxsf5uJ4/Sd4xIuFnR2ar
         tL74kWX4HQiewtu8TC40Uuc2dZVimtWjns77k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Fri, 16 Oct 2009 19:13:43 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910151647.49050.bzolnier@gmail.com> <43e72e890910151206y59353608p5065f72eebd72ab@mail.gmail.com>
In-Reply-To: <43e72e890910151206y59353608p5065f72eebd72ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910161913.44109.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009 21:06:55 Luis R. Rodriguez wrote:
> On Thu, Oct 15, 2009 at 7:47 AM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Wednesday 14 October 2009 18:55:23 Luis R. Rodriguez wrote:
> >
> >> I hear fishing in Poland is great this time of year.
> >
> > It got quite cold this week so I thought that I would try to fish
> > the commit that broke Atheros AR9285 in Linus' tree (works in 2.6.31)
> > and make recent kernels finally work on my laptop..
> >
> > Seems like there are two regressions actually:
> >
> > - later one making association/authentication impossible
> 
> And you reported this when and where?
> 
> > - earlier one making transfers stall
> 
> And you reported this when and where?
> 
> Curious how the issues you mention now spreading across sound and
> wireless do not get fixed or seriously addressed. Have you considered
> your tactics are perhaps not the best?

Please look closely at chosen examples and you'll see a lot of insight
telling you that users' experience is not granted by having clean code
or by having features which are not consider crucial instead of reliable
basic functionality.

I'm pretty sure that if you try F12 w/ AR9285 you will be able to reproduce
and fix at least some of above mentioned problems.  I just used the occasion
to raise them and make people aware of bugs before they hit users in final
2.6.32.

I'm not as much interested in fixing existing problems as in seeing why
they happened in the first place and how the process can be improved to
prevent them / making tracking of them easy for non-developers (so more
people can contribute to the project and developers have more time to
add new features).  I also don't have time to care about every single
Linux bug that I encounter (I hit quite a lot of them), bug-reporting
is a thankless and very time consuming work.

This is in no means trying to implicit that you're doing bad job.  Quite
the contrary -- I think that your work on Atheros support is much needed.

The point is that there is a lot of room for in release management process
of wireless/networking (it has been more-or-less unchanged for a long time
while other subsystems, i.e. x86, are constantly looking into improvements).

This is not something that you can change alone so please do not hesitate
to give feedback about this to your upstream maintainers so they are aware
of the need for improvements.
