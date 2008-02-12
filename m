Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbYBLP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbYBLP3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbYBLP3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:29:05 -0500
Received: from ns.suse.de ([195.135.220.2]:60152 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956AbYBLP3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:29:04 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
From: Andi Kleen <andi@firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org>
	<y0mhcgf4ig1.fsf@ton.toronto.redhat.com>
	<20080211162141.GA31434@elte.hu>
	<20080211171039.GA20446@one.firstfloor.org>
	<20080211230335.GA16102@elte.hu>
	<20080212100327.GA30873@one.firstfloor.org>
	<20080212112747.GA1569@elte.hu>
	<20080212121903.GA419@one.firstfloor.org>
	<20080212123839.GA15360@elte.hu>
	<20080212135027.GA1343@one.firstfloor.org>
	<20080212151611.GB3078@elte.hu>
Date: Tue, 12 Feb 2008 16:28:58 +0100
In-Reply-To: <20080212151611.GB3078@elte.hu> (Ingo Molnar's message of "Tue\, 12 Feb 2008 16\:16\:11 +0100")
Message-ID: <p733ary2nyd.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Andi Kleen <andi@firstfloor.org> wrote:
>
>> On Tue, Feb 12, 2008 at 01:38:39PM +0100, Ingo Molnar wrote:
>> > So unless i forgot about something (please yell if so), it seems to 
>> > me kgdb is now pretty ready for an upstream merge.
>> 
>> I don't know -- I have not reread everything. Please don't consider my 
>> comments as approval of the code base. [...]
>
> well, it does not take a mindreader to conclude that nothing we do could 
> possibly result in you "concluding" that kgdb would be ready for a merge 
> ;-)
>
> for me it suffices that you've run out of technical arguments and are 
> resorting to non-technical name-calling:
>
>> [...] I still think it does quite a lot of dubious and ugly things 
>> overall [...]

Let's put it like this: the amount of problems I found by reading
only about 20% of the kgdb patch justifies the statement above. Also
contrary to your repeated claims many of those are not fixed yet
as far as I can see.

Also every time I dig into something new problems raise their
head -- e.g. see earlier exchange with Jason about the likely
bogus recursion check.

Overall that's not a sign of a clean merge ready code base.

-Andi
