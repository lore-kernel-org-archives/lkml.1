Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbYHQMbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbYHQMbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYHQMaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:30:55 -0400
Received: from saeurebad.de ([85.214.36.134]:37569 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYHQMay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:30:54 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave, write_trylock_irqsave
References: <20080816095951.GA19926@martell.zuzino.mipt.ru>
	<20080816134600.GC20652@elte.hu>
	<20080816210439.GB5151@martell.zuzino.mipt.ru>
	<87pro8psk1.fsf@skyscraper.fehenstaub.lan>
	<20080817093114.GA21303@elte.hu>
Date: Sun, 17 Aug 2008 14:30:30 +0200
In-Reply-To: <20080817093114.GA21303@elte.hu> (Ingo Molnar's message of "Sun,
	17 Aug 2008 11:31:15 +0200")
Message-ID: <871w0nygbd.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> >> (but it would also be hugely invasive, with not much upside with 
>> >> tons of downside like years of migration fallout and having to 
>> >> rewrite hundreds of kernel hacking books ;-) )
>> >
>> > I want my money back for scheduler chapter from "Understanding the 
>> > Linux Kernel"!
>> 
>> I agree that this argument of Ingo's is not a very good one... ;)
>
> i see the smiley, but still - there's a huge difference between the 
> "pain" caused by a much better scheduler [ hey, did you expect me to say 
> anything else? ;-) ] and a rather arbitrary value->pointer parametering 
> change to a core API that is used _everywhere_.

I just meant the thing about the books.  What you said about the
invasive manner, the migration costs and the missing upside I fully
agree with.

	Hannes
