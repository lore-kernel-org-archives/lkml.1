Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZLWRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZLWRaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZLWRaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:30:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbZLWRaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:30:18 -0500
Date: Wed, 23 Dec 2009 09:29:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
In-Reply-To: <4B3250BC.50203@gmail.com>
Message-ID: <alpine.LFD.2.00.0912230922290.6879@localhost.localdomain>
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <4B3248F9.5030504@gmail.com>
 <20091223171052.GI20539@basil.fritz.box> <4B3250BC.50203@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Dec 2009, Gregory Haskins wrote:
> > 
> > And upstream submission is not always like this!
> 
> I would think the process would come to a grinding halt if it were ;)

Well, in all honesty, if it had been non-virtualized drivers I would just 
have pulled. The pull request all looked sane, the diffstat looked clean 
and non-intrusive, and I had no problems with any of that.

But the virtualization people always argue about the fifty-eleven 
different ways of doing things, and unlike real drivers - where the actual 
hardware places constraints on what the heck is going on - virtualization 
people seem to revel in making new interfaces weekly, and tend to be only 
incidentally limited by hardware (ie hardware interfaces may limit some 
_details_, but seldom any higher-level arguments).

So when I see another virtualization interface, I want the virtualization 
people to just argue it out amongst themselves. Thanks to the virtue of me 
personally not caring one whit about virtualization, I can stand back and 
just watch the fireworks.

Which is not to say that I enjoy it (I like the occasional flame-fest, but 
in order to like them I need to _care_ enough to get fired up about 
them!).

So I just don't want the in-fighting to take place in my tree, so I'd 
rather see the fighting die out _before_ I actually pull.

You people are all crazy.

		Linus
