Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbXGBMaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbXGBMaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbXGBM35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:29:57 -0400
Received: from neon.samage.net ([85.17.153.66]:34989 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbXGBM34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:29:56 -0400
Message-ID: <57895.81.207.0.53.1183379391.squirrel@secure.samage.net>
In-Reply-To: <200707021351.57965.ak@suse.de>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
    <200707021351.57965.ak@suse.de>
Date: Mon, 2 Jul 2007 14:29:51 +0200 (CEST)
Subject: Re: blink driver power saving
From: "Indan Zupancic" <indan@nul.nu>
To: "Andi Kleen" <ak@suse.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 2394e6fd9f1e9f86011669f8146dc264
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, July 2, 2007 13:51, Andi Kleen wrote:
> On Monday 02 July 2007 13:43:23 Indan Zupancic wrote:
>> On Mon, July 2, 2007 01:59, Andi Kleen wrote:
>> > Well only those that could be already hung from user space
>> > with setleds (that was also confirmed).  Actually I thought
>> > they didn't hang completely, but just stopped reacting to
>> > the keyboard (which is actually pretty bad for every user
>> > to be able to trigger)
>>
>> Pavel's lost key events, mine stopped reacting altogether.
>
> Did you try if the network was still alive? Perhaps it was
> just a locked up keyboard.

No, it wasn't locked up, because the leds were blinking.
I think if I waited long enough it eventually reacted to other
key presses too, sometimes. At least flooding it with Ctrl+C
stopped the setleds loop long after I had any hope left.

>>
>> > Anyways, Stephen's patch just doesn't make sense:
>> > he clearly didn't understand the code at all. Before you
>> > apply it and cripple it better drop the driver completely.
>>
>> CC'ing Dmitry, as I think he doesn't like the blink driver much either. ;-)
>
> Perhaps one of you geniuses who all hate it can find a better way to
> solve the "video output dead after kexec; but need visual feedback to the user
> while crash dumping" problem. I'm waiting for your patches.

While someone's at it, perhaps USB keyboards could be made working too.
And make it generic infrastructure too so everyone can (ab)use it?
What about adopting the approach here and share the code:
http://lkml.org/lkml/2007/6/19/112

At least it works with all keyboards...

Greetings,

Indan


