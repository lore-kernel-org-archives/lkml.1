Return-Path: <linux-kernel-owner+w=401wt.eu-S1765448AbXLTRHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765448AbXLTRHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbXLTRHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:07:45 -0500
Received: from mx7.mail.ru ([194.67.23.27]:6898 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508AbXLTRHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:07:45 -0500
Date: Thu, 20 Dec 2007 20:09:49 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071220170949.GA1337@localhost.localdomain>
Reply-To: cbou@mail.ru
References: <20071217055123.GA2274@zarina> <20071217024139.2f81e36d@ephemeral> <20071217112416.GA25948@localhost.localdomain> <20071218021001.46783004@ephemeral> <20071219123546.GA6277@localhost.localdomain> <20071219130241.21f0b416@ephemeral> <20071219185050.GA1570@localhost.localdomain> <20071219181304.48609ecb@ephemeral> <20071220150716.GA31896@localhost.localdomain> <20071220110030.1e20ad51@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071220110030.1e20ad51@ephemeral>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 11:00:30AM -0500, Andres Salomon wrote:
> On Thu, 20 Dec 2007 18:07:16 +0300
> Anton Vorontsov <cbou@mail.ru> wrote:
> 
> > Hi Andres,
> > 
> [...]
> > 
> > Then, what the power supply subsystem is for? Just place all the
> > drivers together in driver/power/, and let them create sysfs
> > attributes by their own. You'll get a medley, not the subsystem.
> > 
> > Good luck,
> > 
> 
> 
> Ok, I'm really tired of arguing about this.

Me either, you wouldn't believe.

> I've pointed out why
> the current API is inadequate, but you seem to be resisting
> changing it.

No, you didn't point out anything. You didn't describe _why_ you
want to change the subsystem. No single reason except "flexibility"
that _no one_ is using.

> It's your subsystem, do what you like.

No, this isn't mine subsystem. I've written most of it, probably.
But now I'm just volunteering to co-maintain it (that is, the person
whom to blame if something goes wrong in power/). I'm also directly
interested in this subsystem, because I have the hardware on which
I'm using it.

But I'm not the last person you can ask to merge your changes. Whole
LKML is hearing us, and if you want to--ask David to push your
changes over me. Or Andrew. Or ask Linus at the last. They're are
much better programmers than I am, so whatever they'll do would be
the right thing. I'll just swallow it.

Though, on the current patches, please stamp my:

Nacked-by: Anton Vorontsov <cbou@mail.ru>

so the history will have written evidence that I did not agree on
the changes, so years later I could reply to the complaints: "Look,
I nacked this code, it wasn't me who checked this in!"


You have another option though: finally show up the user of the
purposed changes. Without single "flexible" word, please. Real,
existent user.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
