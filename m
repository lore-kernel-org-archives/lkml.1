Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbYEFASO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbYEFASO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbYEFAR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:17:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbYEFAR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:17:57 -0400
Date: Mon, 5 May 2008 17:16:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, mingo@elte.hu, andi@lisas.de,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: Linux 2.6.26-rc1
Message-Id: <20080505171657.64386de7.akpm@linux-foundation.org>
In-Reply-To: <20080505.165501.62584352.davem@davemloft.net>
References: <20080505053935.GA15734@rhlx01.hs-esslingen.de>
	<20080505073030.GI3350@elte.hu>
	<20080506095122.860796f6.sfr@canb.auug.org.au>
	<20080505.165501.62584352.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 16:55:01 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 6 May 2008 09:51:22 +1000
> 
> > I (and I assume Andrew) have been carrying them since then but noone took
> > them up.  I guess (as Andrew pointed out to me) I should have pushed them.
> 
> So what should I do now?
>
> I have Ingo's IRDA PNP fixes in my net-2.6 tree and that's already
> publicly visible, so I'd need to add revert changesets if people want
> me to remove it.

Uncharted territory here.

As we discussed last week, I won't carry these patches because they're
already upstream.  It turns out that "upstream" in this case is linux-next
itself, which is an unexpected place for patches to be mastered.

So I suggest that Stephen send patches such as this into Linus sooner
rather than later.  Because nobody else will.

Well.  They _might_.  In this case Len could merge the patch in which case
Stephen would drop it and the fix would dawdle around in the acpi tree for
a while.

Ho hum, hopefully this isn't a common case.  Often Linus or I will just do
a maintainer bypass on things like this, but my ability to do that is now
much reduced because a) I can't merge the patch and b) when I _do_ try to
do that, it's "huh, we already fixed it".

So... I hereby appoint Stephen random-build-fix-monkey.
