Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbXJKGbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbXJKGbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbXJKGbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:31:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:26883 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbXJKGbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WY/hbit8QKkBhjYvgGTIsATbJk2mAzBEDgBDtRc/ifXGPK7VgbsTbP4pReQA4Odtva2Bq5WFhqaFZDK/3tvbqlHe+3qj1+TuTBfrEjLd7MHGCF3rxCorhuqMggju7yjl9qfquMIycBe6PZxWXvp8QxWomQiLJTj32MypO4f3m1Q=
Message-ID: <d9def9db0710102331h68e1d9b0rf3095bd9e261ec21@mail.gmail.com>
Date: Thu, 11 Oct 2007 08:31:11 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Aurelien Jarno" <aurelien@aurel32.net>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <470DBDC7.8000304@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>
	 <d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>
	 <470DBDC7.8000304@aurel32.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Aurelien Jarno <aurelien@aurel32.net> wrote:
> Markus Rechberger a écrit :
> > On 10/11/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> As such, the old and decrepit em28xx driver seems more useful to people,
> >> since at least it supports the limited set of hardware on its own.
> >
> > it does not since it's broken and feature limited. On the other side
>
> I have a device which works perfectly with it if you add the vendor and
> product ID to the list. I don't really call that broken. And it doesn't
> need a firmware.
>

Aurelien,

the device you're using is around 2 years old. You're one of the lucky
ones, I have tonns of support mails in my mail account from people who
own almost a similar device but with different videodecoders which are
not fully supported in the kernel or which worked and got broken
during the time.
It took me around 4 hours to debug such an issue last years remotly
with an enduser (which includes that noone cared to ask me if I'm fine
with such an update, neither did someone ask people who own such
devices that they should test the changes).
Please also take other devices and upcoming devices into account,
since i'm willing to spend that time and since I'm in contact with
various companies who provide several components of those devices.

> Please think that a lot of persons do not have enough knowledge to
> compile out of tree drivers, and that a lot more do not even know about
> this out of tree driver.
>

this is what all is about, the project does not depend on certain
broken drivers anymore. And people who initially disagreed without
having any solution nor contributed any code can continue to play
their game without having an impact on that driver anymore.

Markus
