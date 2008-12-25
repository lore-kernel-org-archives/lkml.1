Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbYLYAdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbYLYAdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 19:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLYAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 19:32:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:52162 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYLYAcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 19:32:54 -0500
Subject: Re: Lock-up on PPC64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: malc@pulsesoft.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <871vvy77v4.fsf@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
	 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
	 <20081223234513.GA8730@deepthought>   <871vvy77v4.fsf@linmac.oyster.ru>
Content-Type: text/plain
Date: Thu, 25 Dec 2008 11:32:43 +1100
Message-Id: <1230165163.7292.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-24 at 03:08 +0300, malc@pulsesoft.com wrote:
> Ken Moffat <zarniwhoop@ntlworld.com> writes:
> 
> > On Tue, Dec 23, 2008 at 06:04:45AM +0300, malc@pulsesoft.com wrote:
> >> 
> >> I don't know where to get PPC64 capable memtest, even if it exists the
> >> probability of two different machines exhibiting almost the same
> >> behaviour is rather slim. Netconsole doesn't catch anything. In fact
> >> i just had slightly different situation where after ssh connection was
> >> killed i was able to reconnect and look at dmesg there - nothing.
> >> 
> >  If you wanted to, you could get memtester from
> > http://pyropus.ca/software/memtester/ - not as convenient as
> > memtest86 etc (it's just a userspace task, so it can't test all the
> > memory), but it did work on ppc64 last time I tried it (nearly 2
> > years ago).
> >
> 
> Thanks for the reference, but i'm sure, now more than ever, that bad
> memory has nothing to do with it, all signs are there that kernel is
> confused by the way signals are (mis)used by Mono.

It shouldn't be but I agree with you, it smells bad. Can you report that
again on the linuxppc-dev@ozlabs.org mailing list ? Along with
instructions to d/l, install & run the minimum repro-case ? I'll try to
give it a go on different ppc64 machines as soon as I'm over my upcoming
xmas hangover :-) If it appears to be ps3 specific, we can work with
Geoff Levand (PS3 maintainer for Sony) to try to identify the root cause
and fix it.

Cheers,
Ben.


