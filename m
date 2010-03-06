Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0CFA20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 19:28:26 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46779 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751014Ab0CFA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 19:28:25 -0500
Date: Sat, 6 Mar 2010 03:28:23 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-ID: <20100306002823.GA22095@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
 <20100205203236.GC1475@oksana.dev.rtsoft.ru>
 <fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com>
 <20100209191620.GA24539@oksana.dev.rtsoft.ru>
 <20100305120015.a2008f46.akpm@linux-foundation.org>
 <fa686aa41003051228w38579483yd4e95bb8eacf40f7@mail.gmail.com>
 <20100305123527.d6d68e56.akpm@linux-foundation.org>
 <fa686aa41003051547u1f499902w1d3efc614a9b20b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa41003051547u1f499902w1d3efc614a9b20b6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 04:47:06PM -0700, Grant Likely wrote:
[...]
> >> I'm not really very comfortable with the whole
> >> approach being taken.  And, while I acked the first patch in the
> >> series, that patch isn't needed by anything except patches 2, 3 & 4.

But you didn't answer my replies, ie were sitting silent like for
a month? So you didn't give my any chance to make them comfortable
to you.

Is there any punishment ready for that? ;-) I see one: apply
these patches, and rework this stuff as you like when you have some
time? Or tell me your idea, and I'll do the rework for you, in
2.6.35.

But in the meantime, these patches can be nicely used to support
I2C/SPI GPIO controllers.

> >> Also, the OF stuff is a moving target at the moment with all the
> >> rework is being undertaken.  I'd rather let this series sit out for
> >> another merge cycle so that the underlying OF stuff can settle down.
> >
> > OK, please take it up on-list?
> 
> Okay.  I'm making this reply on list.
> 
> Anton, as I've stated before, I'm not thrilled with the approach.

Again, great timing for telling that, I must say. Yes, you said
it once with some minor arguments (doubts and questions), to which
I replied long ago. Then nothing.

> Combine that with the changes being made to drivers/of right now and
> the addition device tree to ARM and other architectures, my preference
> is to let this patch series lie fallow for one more merge cycle so
> that things can settle out in the OF infrastructure code.

How exactly OF rework affects these patches? And why some rework
should be used as an excuse for not adding a hardware support?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
