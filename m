Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbZGJBpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbZGJBpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZGJBpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:45:35 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:53741 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZGJBpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:45:33 -0400
Message-ID: <4A569D36.3060707@davidnewall.com>
Date: Fri, 10 Jul 2009 11:15:26 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <20090709171501.GA2991@infradead.org> <4A5659A0.2030202@davidnewall.com> (sfid-20090709_234303_323994_088E73F9) <200907100023.48039.Martin@lichtvoll.de>
In-Reply-To: <200907100023.48039.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Am Donnerstag 09 Juli 2009 schrieb David Newall:
>   
>> What I don't understand is how anybody could be satisfied with the
>> status quo. We cannot leave vfat unchanged, for that will perpetuate a
>> pool of victims to be sued, and Linux loses credibility every time that
>> happens. Something *must* change.
>>
>> What is especially attractive about Andrew's position (he said this
>> more eloquently than me) is that developing a solution to avoid the
>> patent will impact Microsoft revenues; and that will be most
>> instructive to them. That's almost sufficient reason by itself!
>>     
>
> Pardon me, but I just don't get how adapting software to software patents 
> will contribute into solving the problems they cause.

As Andrew said, if we work around a patent without losing function we
destroy the economic value of that patent.  Nobody would pay licence
fees for a patent if there was a good work around.  As patent holders
attack us, we devalue their patents.  Eventually (probably quickly)
they'll learn not to attack us.


> Instead of 
> implementing a feature like long name + short name support straight 
> forwardly and simply one has to invent utterly complex, error prone and 
> ugly work-arounds that actually even limit the functionality. Actually I 
> do not envy Tridge for doing that job.
>   

It's not a given that working around a patent will result in something
ugly, error-prone or complex, nor that it will limit function.  But it
is true that we have to work around them.  We can't permit Linux to
violate patents (nor can we permit a serious claim of such.)  That would
cause no end of legal trouble, and would drive vendors away.  Since vfat
violates Microsoft's patent, or at least they seriously claim it does,
we have to do something.  We really have no choice.

> To me it seems that Microsoft has won if it can get Linux kernel 
> developers to cripple the upstream vanilla kernel in order to avoid 
> software patents.

It's still not certain that we have to cripple Linux to work around the
long filename patent.  Granted it looks sad, but Andrew is still working
on it.  If it turns out that we do have to cripple Linux, well sometimes
we win, sometimes we lose; but if don't at least try we always lose. 
When we work around a patent without losing function we win big, and
Andrew said that has already happened for other patents.

> To me it seems challenging the FAT standard by a modern replacement would 
> still be the best way to go.

Perhaps, but FAT is entrenched everywhere so I doubt that challenge
would even be noticed.

> Microsoft sued only TomTom regarding FAT patents upto now. Why? If they 
> acted like SCO they would have gone against IBM, big Linux distributors 
> like Novell and especially against several companies at once. I think this 
> might be cause that Microsoft just knows that their software patent claim 
> would break down if really tested. I do think that Microsoft does not want 
> those FAT patents to be tested in court. Cause I think they know they 
> would not stand a chance.
>   

I think you're right that Microsoft does not want their patent tested in
court, but as they have more money than anyone, they could keep a patent
case in court forever, costing both them and those they sue more and
more money.  If the other party keeps fighting they stand a real chance
of running out of money (and thus out of business); or they could
settle, as Tom Tom did.

> Accepting such a patch IMHO would help Microsoft to get away with seeding 
> fear, uncertainity and doubt and not having the software patent tested and 
> be made void. Actively adapting to software patents gives them a place to 
> be, gives those who support them your energy.
>   
This is wrong.  Doing nothing is what helps Microsoft.

Working around their patent forces Microsoft to sue someone or else
tacitly accept that their patent has been bypassed.  If they sue, and
assuming the patent really has been bypassed, the courts can very
quickly determine that there is no violation, and then it becomes
explicit that the patent has been beaten.  Either way Microsoft would lose.


> Actually I think just ignoring them would be better.
This is also wrong.  Microsoft have sued Tom Tom, and they won't stop
there.  They'll keep picking businesses to sue; and each time they do
they'll win; and each time they win, Linux's reputation becomes
tarnished.  Eventually the manufacturers that build on Linux will move
to some other platform, which would be a disaster for us.

> And I think its not the job of the upstream kernel to protect companies 
> that can not stand a patent trial or do not like to stand it. Its open-
> source. They can remove parts of it.
>   
They can remove parts, and it's odd that Tom Tom didn't do that.  Surely
8.3 filenames would have met their needs, and perhaps they will meet our
needs, too, in which case Alan's suggestion would be appropriate, namely
that we use long filenames where they already exist, but create new
files with 8.3 only.  I could live with that, and I suspect Andrew
could, too.  But I think he'll look for a better solution until he
satisfies himself that none is there to be found.  I hope he find one.

> Shall Microsoft attack IBM or other big companies. Shall Microsoft attack 
> big Linux distributors. Shall they attack the upstream Linux kernel
>   

IBM?  Of course they would, and then Microsoft and IBM would
cross-licence their patents.  They've probably already done this.

Big Linux distributors?  I don't see Red Hat or Novel fighting, should
Microsoft sue.  They'd know the score, and either settle or remove the
function.

The upstream kernel developers?  I don't know.  They would if they felt
they needed to, but the truth is that they can do just as well by
attacking manufacturers who build on Linux, such as Tom Tom.  How many
more Tom Toms do you think it would take to drive manufacturers away
from Linux?  I don't think the number is large.
