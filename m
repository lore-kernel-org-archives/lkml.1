Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXAXKZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXAXKZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 05:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbXAXKY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 05:24:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:56003 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXAXKY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 05:24:59 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070124095157.GA21346@elte.hu>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <20070124095157.GA21346@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 02:23:40 -0800
Message-Id: <1169634220.19471.197.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 10:51 +0100, Ingo Molnar wrote:

> please read what i wrote: in the first section above i am talking about 
> Thomas' -hrt tree and its track record. Thomas' tree is more than a year 
> old and has an excellent track record. In the last sentence i was 
> talking about this latest iteration of his -hrt tree, which i released 
> as part of -rt yesterday. (but which i have tested internally longer 
> than that, prior release.)
> 
> > Since this new release has a fair amount of new code it's not totally 
> > fair to says "it's been in -rt for a while".
> 
> Thomas' -hrt tree has been in -rt for over a year.

Ok. The history is well known to me.

> > If stability is a question, -rt10 does currently compile for my test 
> > config, due to this new HRT introduction. [...]
> 
> isnt your test config ARM? If it's x86 or x86_64 then please send me a 
> bugreport about it. rt10 wont compile on non-i686 and non-x86_64 because 
> their clockevents drivers have not been updated yet (but should be 
> trivial). In any case, this is an -rt internal matter that has no 
> relevance on the -mm submission, i'm not sure why you are bringing it 
> up.

No, the test config I was talking about is SMP i386 (which is what I
usually use). All tho I've sent you ARM and PowerPC code in the past.

> > My queue has always been 90% clean up, some of that is moving code 
> > around. [...]
> 
> in the -rt tree i'm tracking the high-res code that has been started by 
> Thomas in mid-2005. In the past 1.5 years, 90%+ of the bugfixes to 
> high-res timers issues in -rt came from Thomas and this has been about 
> the 10th major iteration to his codebase. If you have cleanups to his 
> code then please work with Thomas to get your changes into his tree.

My code is for clocksouces/timekeeping which has been unrelated to HRT
up until recently. In my original email I suggested that the two tree's
be merged ,or placed on top of each other, which I still think is a good
idea.

Daniel

