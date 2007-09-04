Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXIDITs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXIDITs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXIDITk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:19:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbXIDITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:19:39 -0400
Date: Tue, 4 Sep 2007 01:18:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: davidel@xmailserver.org, rdunlap@xenotime.net, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       drepper@redhat.com, stable@kernel.org, hch@lst.de,
       jengelh@computergmbh.de, corbet@lwn.net
Subject: Re: [PATCH] Revised timerfd() interface
Message-Id: <20070904011800.762523a4.akpm@linux-foundation.org>
In-Reply-To: <46DD116C.4040301@gmx.net>
References: <20070825064114.107820@gmx.net>
	<Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
	<46DD116C.4040301@gmx.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 04 Sep 2007 10:03:56 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> Davide,
> 
> >> Davide -- ping!  Can you please offer your comments about this change, and
> >> also thoughts on Jon's and my comments about a more radical API change
> >> later  in this thread.
> > 
> > IMO the complexity of the resulting API (and resulting patch), and the ABI 
> > change, is not justified by the added value.
> 
> Neither of the proposed APIs (either my multiplexed version of timerfd()
> or Jon's/my idea of using three system calls (like POSIX timers), or
> the notion of timerfd() integrated with POSIX timers) is more
> complicated than the existing POSIX timers API.
> 
> The ABI change doesn't really matter, since timerfd() was broken in 2.6.22
> anyway.
> 
> Both previous APIs provided the features I have described provide:
> 
> * the ability to fetch the old timer value when applying
>   a new setting
> 
> * the ability to non-destructively fetch the amount of time remaining
>   on a timer.
> 
> This is clearly useful for timers -- but you have not explained why
> you think this is not necessary for timerfd timers.

<wakes up>

I'd have thought that the existing stuff would be near-useless without the
capabilities which you describe?


