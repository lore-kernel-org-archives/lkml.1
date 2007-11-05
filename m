Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbXKEXuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbXKEXuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXKEXus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:50:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57515 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXKEXur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:50:47 -0500
Message-ID: <472FAB4C.9040303@zytor.com>
Date: Mon, 05 Nov 2007 15:46:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Roland Dreier <rdreier@cisco.com>, Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
References: <20071103234826.GA26654@uranus.ravnborg.org> <20071105104129.GB3662@infradead.org> <20071105171740.GA29481@uranus.ravnborg.org> <adafxzkbcid.fsf@cisco.com> <20071105214937.GA31496@uranus.ravnborg.org>
In-Reply-To: <20071105214937.GA31496@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Nov 05, 2007 at 01:36:42PM -0800, Roland Dreier wrote:
>>  > Like this:
>>  > $ make ARCH=foo
>>  > Makefile:201: *** "ERROR: ARCH (foo) does not exist".  Stop.
>>
>> Seems sane, but maybe it would be worth putting in a special case
>> check for someone using i386 or x86_64 for ARCH, and tell them to
>> switch to x86?
> 
> Will do so if my patchset gets applied. Need to redo it but
> that will be later this week and then I hope for a bit more
> feedback from the x86 guys.

The patchset has looked good to me, and I believe it would be better to 
take this particular breakage sooner rather than later.

I haven't spoken up actively mostly because I wanted to look at the user 
comments as they have been coming in.

The issue with "make allyesconfig" concerns me, although the same 
situation already exists with any multiple-choice configuration.  What I 
guess we really want is to be able to specify a few specific choices.

	-hpa
