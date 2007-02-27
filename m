Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbXB0OMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbXB0OMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbXB0OMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:12:49 -0500
Received: from [212.12.190.16] ([212.12.190.16]:32896 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751616AbXB0OMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:12:48 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Tue, 27 Feb 2007 17:15:31 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702271715.31184.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Feb 27, 2007 at 01:28:32PM +0300, Evgeniy Polyakov wrote:
> > Obviously there are bugs, it is simply how things work.
> > And debugging state machine code has exactly the same complexity as
> > debugging multi-threading code - if not less...
>
> Evgeniy,
>
> I think what you are not hearing, and what everyone else is saying
> (INCLUDING Linus),

Excluding possibly many others.

> is that for most programmers, state machines are
> much, much harder to program, understand, and debug compared to
> multi-threaded code.

That's why you introduce an infrastructure that hides all the nitty-gritty 
plumbing, and makes it easy to use.

> You may disagree (were you a MacOS 9 programmer
> in another life?), and it may not even be true for you if you happen
> to be one of those folks more at home with Scheme continuations, for
> example.

Personal attacks are really rather unhelpful/unscientific.

> But it is true that for most kernel programmers, threaded
> programming is much easier to understand, and we need to engineer the
> kernel for what will be maintainable for the majority of the kernel
> development community.

What's probably true is that, for a kernel to stay competitive you need two 
distinct traits:

1. Stability
2. Performance

And you can't get that, by arguing that the kernel development community 
doesn't have the brains to code for performance, which I dearly doubt.

So, instead of using intimidating language to force one's opinion thru, 
especially when it comes from those in control, why not have a democratic 
vote?


Thanks!

--
Al

