Return-Path: <linux-kernel-owner+w=401wt.eu-S964777AbXBYUQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777AbXBYUQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXBYUQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:16:00 -0500
Received: from keil-draco.com ([216.193.185.50]:50367 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932995AbXBYUPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:15:53 -0500
From: "D. Hazelton" <dhazelton@enter.net>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Date: Sun, 25 Feb 2007 15:15:22 -0500
User-Agent: KMail/1.9.5
Cc: "Pavel Machek" <pavel@ucw.cz>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com> <20070225104211.GB2045@elf.ucw.cz> <f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
In-Reply-To: <f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702251515.22703.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 February 2007 06:54, Michael K. Edwards wrote:
> On 2/25/07, Pavel Machek <pavel@ucw.cz> wrote:
<snip>
> But a 20KLoC 3-D graphics driver that happens to #include
> <linux/whatever.h> is not thereby a "derivative work" of the kernel,
> no matter how many entrypoints are labeled EXPORT_SYMBOL_GPL or
> provided as inline functions.  And under the Lexmark standard,
> MODULE_LICENSE("GPL") with a disclaimer in the doco is by far the
> sanest way to deal with the EXPORT_SYMBOL_GPL mind games, and likely
> (IANAL, TINLA) to be endorsed by any court in the US and probably lots
> of other places too.  Especially when the graphics chip maker explains
> that keeping their driver source code closed isn't really an attempt
> to hide their knowledge under a bushel basket.  It's a defensive
> measure against having their retail margins destroyed by nitwits who
> take out all the busy-wait loops and recompile with -O9 to get another
> tenth of a frame per second, and then pretend ignorance when
> attempting to return their slagged GPU at Fry's.

At that point, Mike, you are treading on *very* thin ice. With Intel having 
released the complete source to their chipsets and with the number of totally 
free 3D drivers that don't slag GPU's...

However - if the hardware is really that fickle then why is it on the market? 
Yes, it can run hot enough to slag itself - all modern CPU's run the same 
risk. Yet people, mostly the "Power Gamers", will push a CPU beyond their 
rated spec's and have it riding the edge of thermal breakdown. Because of the 
nature of the 3D accelerator market most manufacturers (of the chips 
themselves) have already pushed their chips to that thermal edge, and some of 
the makers of the boards will even provide the end user means to push the 
chips even further.

However, even *with* some hardware manufacturers providing a way for the 
end-user to do it, pushing the componets to the edge of thermal breakdown (or 
beyond and keeping them in check through an active cooling system) is 
not "normal and expected use". As well, if the that is the argument that 
NVidia and ATI use (that they are worried about people recompiling the code 
with busy-loops stripped out) then they don't know the Open Source community 
well. In general the people that are most likely to recompile the driver with 
the busy-loops removed don't run Open Source systems - they run Windows. 
Those people are called "competetive gamers" and 99% of the games they play 
are only available for Windows.

What I'm trying to say is: Just like the "It gives away too much information 
on our IP" claim, the "People will recompile it with code needed to keep it 
from destroying itself" claim is bunk. Even moreso if their code is 
documented well enough that the purpose of the busy-wait loop is clear.

DRH
