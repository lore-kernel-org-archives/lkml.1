Return-Path: <linux-kernel-owner+w=401wt.eu-S1764993AbXFRX7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764993AbXFRX7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbXFRX71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:59:27 -0400
Received: from dvhart.com ([64.146.134.43]:45387 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbXFRX70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:59:26 -0400
Message-ID: <46771C5D.10809@mbligh.org>
Date: Mon, 18 Jun 2007 16:59:25 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Natalie Protasevich <protasnb@gmail.com>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>	 <200706172053.41806.bzolnier@gmail.com>	 <20070617115258.1f55b29d.akpm@linux-foundation.org>	 <200706172349.08813.bzolnier@gmail.com>	 <4675C083.6080409@s5r6.in-berlin.de>	 <20070617220927.99ebc1ee.akpm@linux-foundation.org>	 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>	 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>	 <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
In-Reply-To: <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Natalie Protasevich wrote:
> On 6/18/07, Martin Bligh <mbligh@mbligh.org> wrote:
>> >> > So if you make changes to random-driver.c you can do `git-log
>> >> > random-driver.c|grep Tested-by" to find people who can test
>> >> > your changes for you.
>> >>
>> >> You would'nt even need to search in GIT.  Maybie even when ever a
>> >> patchset is being proposed a mail could be sent to appropriate
>> >> hardware/or feature pseudo-auto-generated mailing-list?
>> >>
>> >> On lkml I mostly try to follow patches/bugs associated with hardware I
>> >> use.  Why not try to automate the process and get more testers in?
>> >>
>> >
>> > I think this is an excellent point. One data point could be a field in
>> > bugzilla to input the hardware information. Simple query can select
>> > common hardware and platform. So far it's not working when hardware is
>> > just mentioned in the text part.
>>
>> if it's free text it'll be useless for search ... I suppose we could
>> do drop-downs for architecture at least? Not sure much beyond that
>> would work ... *possibly* the common drivers, but I don't think
>> we'd get enough coverage for it to be of use.
>
> How about several buckets for model/BIOS version/chipset etc., at
> least optional, and some will be relevant some not for particular
> cases. But at least people will make an attempt to collect such data
> from their system, boards, etc.

Mmm. the problem is that either they're:

1. free text, in which case they're useless, as everyone types
mis-spelled random crud into them. However, free-text search
through the comment fields might work out.

2. Drop downs, in which case someone has to manage the lists
etc, they're horribly crowded with lots of options. trying to
do that for model/BIOS version/chipset would be a nightmare.

If they're mandatory, they're a pain in the butt, and often
irrelevant ... if they're optional, nobody will fill them in.
Either way, they clutter the interface ;-(

Sorry to be a wet blanket, but I've seen those sort of things
before, and they just don't seem to work, especially in the
environment we're in with such a massive diversity of hardware.

If we can come up with some very clear, tightly constrained
choices, that's a decent possibility. Nothing other than
kernel architecture (i386 / x86_64 / ia64) or whatever springs
to mind, but perhaps I'm being unimaginative.

Nothing complicated ever seems to work ... even the simple
stuff is difficult ;-(

M.
