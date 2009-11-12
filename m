Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbZKLBAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbZKLBAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbZKLBAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:00:09 -0500
Received: from ppp59-167-189-244.static.internode.on.net ([59.167.189.244]:38636
	"EHLO isinu.rimspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690AbZKLBAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:00:08 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2009 20:00:06 EST
From: Daniel Pittman <daniel@rimspace.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
       Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF4526B.4060101@zytor.com>
	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
	<20091108173708.GF1372@ucw.cz>
	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>
	<20091108181016.GB32364@elf.ucw.cz>
	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
	<20091108193618.GB4186@elf.ucw.cz>
	<40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>
	<20091108195158.GD4186@elf.ucw.cz>
	<20091108200852.7f2cf092@lxorguk.ukuu.org.uk>
	<20091110052711.GA15338@1wt.eu> <4AF9020C.90108@zytor.com>
	<4AF9435F.2070103@redhat.com>
	<20091110105642.215804e0@lxorguk.ukuu.org.uk>
	<4AF99E04.8080704@zytor.com>
	<20091110172454.3c4481f2@lxorguk.ukuu.org.uk>
	<4AF9B5AB.5010800@zytor.com>
Date: Thu, 12 Nov 2009 11:51:55 +1100
In-Reply-To: <4AF9B5AB.5010800@zytor.com> (H. Peter Anvin's message of "Tue,
	10 Nov 2009 10:49:15 -0800")
Message-ID: <87zl6sva38.fsf@rimspace.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
> On 11/10/2009 09:24 AM, Alan Cox wrote:
>>>
>>> In the short term, yes, of course.  However, if we're going to do
>>> emulation, we might as well do it right.
>> 
>> Why is using KVM doing it right ? It sounds like its doing it slowly,
>> and hideously memory inefficiently. You are solving an uninteresting
>> general case problem when you just need two tiny fixups (or perhaps 3 if
>> you want to fix up early x86-64 prefetch)
>
> Why do we only need "two tiny fixups"?  Where do we draw the line in
> terms of ISA compatibility?  One could easily argue that the Right
> Thing[TM] is to be able to process any optional instruction -- otherwise
> one has a very difficult place to draw a line.
>
> Consider SSE3, for example.  Why should the same concept not apply to
> SSE3 instructions as to CMOV?

FWIW, the issue of the binary-only flashplayer.so came up later in the thread,
but to add my few cents:

When flash 10 was released the binary only 64-bit version generated
instructions from the LAHF set unconditionally, in part because Windows chose
to emulate those on the very few x86-64 platforms that didn't do them in
hardware.

At that time it would have been very nice from a "user support" point of view
to be able to add LAHF emulation to support the software.  Yes, it is ugly,
binary-only code, but it is reasonably popular...

        Daniel

...in the end, in fact, popular enough to have at least a couple of people
I know purchase a new CPU that did implement it, just for flash on Linux.
-- 
✣ Daniel Pittman            ✉ daniel@rimspace.net            ☎ +61 401 155 707
               ♽ made with 100 percent post-consumer electrons
