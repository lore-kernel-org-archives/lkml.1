Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZGWXFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZGWXFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZGWXFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:05:52 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35336 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZGWXFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a5Wifj1BXsuL1NC5Y4gnte1TJqnvvLLr5XpGdwEAeKpL16cSIO+SrtI3InDWntkPiy
         ayrooLyJWkYuB6nb/Y0QrDpnzy/AFuz4eTMRx6k/07bSCC1vvkmEKFbGFNvGp9sNEHfH
         hIXvaeLAbzh/BEZNptOPTdF+kZ5ViRTsYUiSw=
MIME-Version: 1.0
In-Reply-To: <200907231921.31121.lamarque@gmail.com>
References: <200907170301.43807.lamarque@gmail.com>
	 <200907231900.59820.lamarque@gmail.com>
	 <20090723150643.0a099d4f.akpm@linux-foundation.org>
	 <200907231921.31121.lamarque@gmail.com>
Date: Thu, 23 Jul 2009 19:05:49 -0400
Message-ID: <2a91b6e50907231605t2b805a7avfbd313a96280af29@mail.gmail.com>
Subject: Re: [PATCH] Fix for Acer Bluetooth Optical Rechargeable Mouse
From: Anthony Waters <awaters1@gmail.com>
To: Lamarque Vieira Souza <lamarque@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, marcel@holtmann.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch in the bug report[1] just undoes the part of the commit that
causes the stutter/sluggishness with my mouse so it isn't really a fix

[1] http://bugzilla.kernel.org/show_bug.cgi?id=13314

On Thu, Jul 23, 2009 at 6:21 PM, Lamarque Vieira
Souza<lamarque@gmail.com> wrote:
> Em Quinta-feira 23 Julho 2009, Andrew Morton escreveu:
>> On Thu, 23 Jul 2009 19:00:58 -0300
>>
>> Lamarque Vieira Souza <lamarque@gmail.com> wrote:
>> > Em Quinta-feira 23 Julho 2009, Andrew Morton escreveu:
>> > > On Thu, 23 Jul 2009 18:30:57 -0300
>> > >
>> > > Lamarque Vieira Souza <lamarque@gmail.com> wrote:
>> > > > Em Quinta-feira 23 Julho 2009, Andrew Morton escreveu:
>> > > > > On Fri, 17 Jul 2009 03:01:43 -0300
>> > > > >
>> > > > > Lamarque Vieira Souza <lamarque@gmail.com> wrote:
>> > > > > >     This patch works around one problem with my Acer Bluetooth
>> > > > > > Optical Rechargeable Mouse where the cursor gets stuck at
>> > > > > > screen's upper-left corner. Even my notebook's touchpad is not
>> > > > > > able to move cursor when the bluetooth mouse is connected to my
>> > > > > > Acer Ferrari 4005 notebook. Using input session instead of hid
>> > > > > > session solves this problem although the cursor still moves a
>> > > > > > little sluggishly with the bluetooth mouse, cursor moves
>> > > > > > correctly using the touchpad. My bluetooth mouse used to work
>> > > > > > well (no sluggish) until kernel 2.6.21, since then the problems
>> > > > > > are getting worse with each kernel release (it got sluggish in
>> > > > > > 2.6.22 and this this upper-left corner problem appeared in 2.6.28
>> > > > > > or 2.6.27).
>> > > >
>> > > >         By the way, I have found that bug
>> > > > http://bugzilla.kernel.org/show_bug.cgi?id=13314 is the cause of the
>> > > > sluggish in my mouse.
>> > >
>> > > (cc's added)
>> > >
>> > > OK, thanks.  Did you test Anthony's patch on your system?
>> >
>> >     Yes,  I did.
>>
>> Did it fix the bug?
>
>        It fixed one of the two problems I had with this mouse.
>
>> If so, does that mean that you think we should merge Anthony's patch
>> instead of yours?
>
>        I need both patches for my mouse to work properly. My patch fix the problem
> of cursor stucked at upper-left corner. Anthony's fix the cursor being
> sluggish (stutter). They are two different problems.
>
>> > > Also, you've determined that
>> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=comm
>> > >it;h =e4e8e37c42bdaaefcb84eeaef0dc1bc3f696f8f6 caused the problem on
>> > > your machine and that reverting it fixes things up.
>> > >
>> > > I'm all confused.
>
>
> --
> Lamarque V. Souza
> http://www.geographicguide.com/brazil.htm
> Linux User #57137 - http://counter.li.org/
>
