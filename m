Return-Path: <linux-kernel-owner+w=401wt.eu-S932289Ab0ANVIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0ANVIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220Ab0ANVIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:08:13 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54805 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab0ANVIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:08:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w65goeiiK28/lY4Lu2T6nn7YDFBSrMOLoiQIPieTKSRj6ZwPrSDiSfcUJ7W+mjywhj
         xvSgXdeQ2efgFvy8JRBl1rMjPf6lJZaSWn88MvIUmCZG0ujt5Ya737BnsfauMwkVgIWt
         PJfc94E5/lEawroqWp3RInRdHyd8gB6qxVmj8=
MIME-Version: 1.0
In-Reply-To: <45a44e481001041614i35ceef84q5f12a068e2f0b97b@mail.gmail.com>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
	 <20091216103423.GE1377@ucw.cz>
	 <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz>
	 <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
	 <20100104224817.GA21695@elf.ucw.cz>
	 <45a44e481001041614i35ceef84q5f12a068e2f0b97b@mail.gmail.com>
Date: Thu, 14 Jan 2010 22:08:07 +0100
Message-ID: <ca2dc2821001141308s5a552447yb887f619231f449@mail.gmail.com>
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 1:14 AM, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> On Tue, Jan 5, 2010 at 6:48 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>> Ok, but I guess you should cc auxdisplay people in future.
>
> Hi Pavel,
>
> I just looked at the drivers/auxdisplay directory and got a bit
> confused. The reason I got confused is because auxdisplay is actually
> an fbdev driver but it is outside of the drivers/video directory. It
> looks like there has only been 1 commit and that was for the Samsung
> KS0108 controller. It also sort of uses platform support but the way
> it is abstracted is odd to my thinking. The controller is ks0108, so
> in my mind that would be the code that would be platform independent,
> and then that would use a board specific IO driver to push data (eg:
> parport or gpio or usb). I think in the long term it would probably
> make sense to write a cleaner approach with a drivers/video/ks0108.c
> which is cleanly platform independent (and back within fbdev proper)
> and then a board specific driver in the appropriate location that
> handles the IO.

I wrote long ago the driver(s) and people that reviewed it thought it
was better to keep it outside. I think that if someone else is going
to need ks0108, then I agree: we should write a independent driver.

It should not be hard, it is an easy controller to play with and the
code is already there. I would try to do it; however, I am not sure if
I would be the most appropriate person to code such generic driver, as
I know almost nothing about all drivers/video/* stuff and the ways of
making it truly generic for future video/ users. Still, I will help
gladly.

>
> Thanks,
> jaya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
