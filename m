Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0CGBru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 20:47:50 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:52322 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753856Ab0CGBrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 20:47:49 -0500
Date: Sun, 7 Mar 2010 04:47:46 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-ID: <20100307014746.GA28667@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com>
 <20100209191620.GA24539@oksana.dev.rtsoft.ru>
 <20100305120015.a2008f46.akpm@linux-foundation.org>
 <fa686aa41003051228w38579483yd4e95bb8eacf40f7@mail.gmail.com>
 <20100305123527.d6d68e56.akpm@linux-foundation.org>
 <fa686aa41003051547u1f499902w1d3efc614a9b20b6@mail.gmail.com>
 <20100306002823.GA22095@oksana.dev.rtsoft.ru>
 <fa686aa41003051954y3ea8ebebxa915efb74c58dcbb@mail.gmail.com>
 <20100306050536.GA20539@oksana.dev.rtsoft.ru>
 <fa686aa41003060843s5b8dfc28p65541056121c4502@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa41003060843s5b8dfc28p65541056121c4502@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 09:43:20AM -0700, Grant Likely wrote:
> > On Fri, Mar 05, 2010 at 08:54:56PM -0700, Grant Likely wrote:
> > And of course the part of the OF rework, which was first posted
> > for *review* on Feb 03, is a completely different story?
> >
> >  48 files changed, 317 insertions(+), 575 deletions(-)
> 
> Completely uncontroversial changes with zero functional behaviour
> change.  There was no uncertainty about these ones and they were
> posted almost a week earlier.

The patches simply touch too many things, so I'd say that the
possible breakage impact is on par with the OF GPIO stuff.

[...]
> > That's a non-argument, what is "lower impact"? Do I touch any
> > hot paths? And if nothing has changed, David (again, the gpiolib
> > maintainer) is happy with the notifiers approach, why would you
> > care?
> 
> Adding unneeded notifier infrastructure is churn I don't want to see.

You could reply to my answers earlier and I would change and
repost the patches in a jiffy, since I am interested in these
patches.

But you're obviously not interested in this support since you
didn't answer my replies. I'll explain. If you were interested
in some support you could give some chance to make patches
comfortable to you, and then you could even test them, and
maybe defend their inclusion.

Look at what an interested person does:

http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg00895.html

Note that that was v2 with my comments fixed, and that was
just seconds before 2.6.33 merge window closed. See?
Someone with a direct interest! I gave my comments, they
were fixed, and I felt grateful and responsible for pushing
the support upstream.

But you're not interested in the support, so I don't see
why you block it without any good technical reason.

And note that not only I'm interested in this support, the
I2C/SPI GPIO controllers issue was brought on ml several
times by many people.

[...]
> > I don't get it. Why is it a problem to change your patches that
> > ought to be queued for 2.6.*35*?
> 
> It's not, and they are going to be queued for 2.6.35.  In fact, I
> didn't posted them this week to avoid adding confusion to the merge
> window.  The issues isn't changing my patches.

Then why you mentioned OF rework as some reason to block
these patches?

> It is that I don't
> like the notifier approach, and I intend to prove that it can be done
> in a better way.

No doubt that you have some better ideas (not to mention that
notifiers was your idea as well :-).

Here are some technical arguments:

1. You can implement your new ideas on top of the current solution.
   Or I can happily do that for you.
2. The patches don't change any API, instead they just build
   a bridge between GPIOLIB and OF GPIO infrastructure.
   So it's just a matter *taste* how to build that bridge.
   It's an internal issue of how GPIOLIB and OF GPIO interact.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
