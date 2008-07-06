Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYGFI2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYGFI2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 04:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYGFI2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 04:28:39 -0400
Received: from nebensachen.de ([195.34.83.29]:39519 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYGFI2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 04:28:38 -0400
X-Hashcash: 1:20:080706:joe@skyrush.com::oz+ByS8Va6w+bKjv:005QmL
X-Hashcash: 1:20:080706:andi@firstfloor.org::wt1ltCGxyAKWIC6M:0000000000000000000000000000000000000000000ejR
X-Hashcash: 1:20:080706:alan@lxorguk.ukuu.org.uk::Yw50OdlenpiJ6aym:00000000000000000000000000000000000007m3z
X-Hashcash: 1:20:080706:edwintorok@gmail.com::sVNztjjqgK40d7v6:00000000000000000000000000000000000000000DIHJ
X-Hashcash: 1:20:080706:linux-kernel@vger.kernel.org::j43T3bSGQHgBUj8A:0000000000000000000000000000000002RLW
From: Elias Oltmanns <eo@nebensachen.de>
To: Joe Peterson <joe@skyrush.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
	<871w29s5u2.fsf@basil.nowhere.org>
	<20080704221457.1f147225@lxorguk.ukuu.org.uk>
	<486E97F2.8020605@firstfloor.org>
	<20080704224441.63204bc4@lxorguk.ukuu.org.uk>
	<486E9F91.6010701@firstfloor.org>
	<20080705113434.41109492@lxorguk.ukuu.org.uk>
	<486F543D.8010409@firstfloor.org> <87y74gpkb8.fsf@denkblock.local>
	<486FD270.9030209@skyrush.com>
Date: Sun, 06 Jul 2008 10:28:26 +0200
In-Reply-To: <486FD270.9030209@skyrush.com> (Joe Peterson's message of "Sat,
	05 Jul 2008 13:58:40 -0600")
Message-ID: <87zlovxvpx.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> wrote:
> Elias Oltmanns wrote:
[...]
>> Quite frankly, I'm a bit at a loss as to how I should go about debugging
>> this and what kind of data might be useful to others to do so.
>
> If you can, please try the new patch I attached to the post:
>
> 	http://marc.info/?l=linux-kernel&m=121520229900676&w=2

Sorry, I just forgot to mention that I had already done that. It doesn't
make any difference as far as I can see (not that I'm surprised about
it).

[...]
> And also, if you can, try doing 'stty noflsh' and then the test case
> again to see if this alters behavior.  This may be good to know as well,
> even if the flush is not centrally involved in the issue.

No, that didn't make any difference either.

Regards,

Elias
