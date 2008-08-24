Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYHXS6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYHXS6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 14:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYHXS6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 14:58:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbYHXS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 14:58:42 -0400
Date: Sun, 24 Aug 2008 11:58:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <19f34abd0808241143t6f5239d7o679135e9e974fe63@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808241152370.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>  <alpine.LFD.1.10.0808241050180.3363@nehalem.linux-foundation.org> <19f34abd0808241143t6f5239d7o679135e9e974fe63@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Aug 2008, Vegard Nossum wrote:
> 
> I haven't really used the hlists before, so my first instinct was to
> do what is obvious.

I do agree that the hlist versions aren't very nice in this regard. The 
regular lists are much better at moving lists around.

> Other than that, I guess open-coding list ops is also not very good 
> programming practice? :-)

Agreed. It would be better if the people who use hlists most (I think that 
would be networking) would think about this.

> But... feel free to submit your own patch. Oh, what am I saying.

Silly boy. Next you'll ask me to _test_ any patches I send out.

Anyway, I think your patch is likely fine, I just thought it looked a bit 
odd to have a loop to move a list from one head pointer to another.

But regardless, it would need some testing. Daniel?

			Linus
