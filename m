Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbXLPT7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbXLPT7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXLPT7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:59:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:8463 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbXLPT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vbIlNQEvYT7XDZkfnHZy0EG5O2r4szs+nPtLuN1tZUpJkd6f6zDh6UKC+DQhau03+CBMVNm2Jahnf8uoi740la0ozuT5Sre4RSFc4rOw2iO1eGvJ4RYME6t9oLs+lLuqpZaI1eXoeV0I0/6ns989b6kfKYyCuZaakXw78oNTvPw=
Message-ID: <82e4877d0712161159r2572dbbfi15159c66e4b7e33b@mail.gmail.com>
Date: Sun, 16 Dec 2007 14:59:41 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: devzero@web.de
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Cc: Matt.Domsch@dell.com, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <49448787@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49448787@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 16, 2007 2:11 PM,  <devzero@web.de> wrote:
> some of them
> http://forums.suselinuxsupport.de/lofiversion/index.php/t61581.html
> http://suseforums.net/index.php?showtopic=1302
> http://forums.suselinuxsupport.de/lofiversion/index.php/t3157.html
> http://www.linuxforums.org/forum/installation/73984-cant-boot-past-loading-kernel-fedora-4-a.html
> http://ubuntuforums.org/archive/index.php/t-146180.html
> http://ubuntuforums.org/showthread.php?t=450630
> http://www.linuxquestions.org/questions/linux-software-2/grub-freezes-before-uncompressing-kernel-464619/
>
> not sure if really all of them are the edd problem i have, but i`m quite sure for some of those.
> can provide more links if somebody likes.

None of them seemed like they were determined as EDD problems - some
even did not work with edd=skipmbr.
But that is not the point. Problem is not widely known, likely happens
with very old BIOSes and people who use those systems should be
knowing more than simply booting back to Win98.
And if those people are smart enough to figure out the right place to
ask - they will likely get suggestions to do edd=off like some of the
above links that you posted prove - without the message.

Why tax other people with a warning/hang etc. in printk when the
problem is very unlikely on their systems?

>
> > Adding 3 printks for each such obscure problem would make it even more
> i wouldn`t call that problem obscure.
> i have seen this problem more than 5 times since that code is in linux. so it`s at least enough to discuss about even if no other person thinks it`s necessary :)  just the fact that it`s not been discussed often (here or elsewhere) doesn`t mean, that it exist or that users come across that. it`s more that type of "mhh, let`s try linux instead of windows. oh, doesn`t boot. ok, let`s stay with windows then...". you don`t expect people like those posting the right question to the right forum, do you?

So you think those people with such low tech knowledge will figure out
the right mailing list, make sense of the output of EDD message and
then post the question? Or that they will figure out how to specify
the edd=off to kernel command line? In that use case - not doing EDD
on their boxes like I said would be the most useful thing to do. A
message or 3 is useless in this case.

>
> > If there are known chipsets / BIOSes that have this problem - applying
> > quirks - something like this quirk for pmtmr [1]- (if they work this
> > early) or even special casing them with forced edd=off may be the right and more useful thing to do.
> mhh. i`m unsure. ok, i`m no kernel-hacker but there are so many variants of bios/hardware out there so blacklisting certain bios versions may be never more than half of a solution.

We have no data though to say this is a widespread problem. And the
type of people you are caterign to in your patch need further hand
holding to keep their system running Linux anyway.
(Hey my modem won't work, the resolution is too low etc. let's go back
to Windows.)

But yeah whatever - if you cut it down to one printk line and remove
the hang word that would at least be bearable :)

Parag
