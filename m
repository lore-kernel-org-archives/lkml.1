Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZG0XiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZG0XiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZG0XiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:38:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:61696 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZG0XiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <20090727231459.GD7142@elf.ucw.cz>
References: <20090714094629.GB2076@elf.ucw.cz>
	 <20090714221638.GA6512@elf.ucw.cz>
	 <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com>
	 <20090719212330.GI26511@elf.ucw.cz>
	 <d6200be20907192043w3f1aa2abvd0125163e6f5519c@mail.gmail.com>
	 <20090721101103.GD4133@elf.ucw.cz>
	 <d6200be20907211812l47012c00i1fc7de53db97d702@mail.gmail.com>
	 <20090723212506.GS28158@elf.ucw.cz>
	 <d6200be20907231711hdf8173avea686b63db157b93@mail.gmail.com>
	 <20090727231459.GD7142@elf.ucw.cz>
Date: Mon, 27 Jul 2009 16:38:23 -0700
Message-ID: <d6200be20907271638l42135548l28d23bd073815ec4@mail.gmail.com>
Subject: Re: HTC: touchscreen driver
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 4:14 PM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
>> >> git fetch git://android.git.kernel.org/kernel/experimental.git
>> >> android-msm-2.6.30-rc2-test
>> >> git cherry-pick 9f89902daf7a3c6fdd6b0c7494f3cc82d5e09217
>> >
>> > So I spent 10 minutes downloading patch you could have inlined... only
>> > to find out that review already pointed nosync issue (and I fixed swap
>> > independetly)...
>>
>> Sorry, I thought it was clear what it contained.
>
> Well, I guess I lost that in the mailflood.
>
>> I'm a little confused why you did not already have this though. This
>> is the same branch I pushed specifically so you could get at it a
>> month ago, and you said you got it booting back then.
>
> I already got the tree (thanks!) but I did not know that I had it, so
> I ended up downloading another copy...
>
> BTW... would you have 2.6.31-rcX (or linux-next?) working on dream by chance?

No, I have not looked at 31 yet. I did push most of our changes to the
touchscreen driver, including a stab at the official multi-touch
protocol, to the android-2.6.29 branch in the public
git://android.git.kernel.org/kernel/common.git repository though.

>
>> >> That way you will hopefully not add question marks to my name.
>> >
>> > ...and I still don't know what your name is. My terminal displays "Arve
>> > Hj#???nev##g <arve@android.com>" :-(.
>>
>> That does not look right. It displays correctly for me in the mailing
>> list archives:
>> http://lkml.org/lkml/2009/7/21/496
>>
>> gitk also works for me. git log only works if you are using a utf8
>> terminal (or have set the character set in your gitconfig).
>
> Apparently my terminals don't speak utf8. (Which is no wonder, I had
> to fall back to xterm when gnome-terminal stopped working). Web
> browser displays your name correctly, so I now know what it is, and I
> can even paste it (Arve Hjřnnevĺg). I wonder if it gets through the
> mail system undamaged. (If not, is there acceptable transcription of

It did not.

> your name to us/ascii?)

Acceptable, no, but I use "Arve Hjonnevag" for systems that only
support us-ascii.

>
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Arve Hjønnevåg
