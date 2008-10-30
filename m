Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbYJ3X3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbYJ3X3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYJ3X2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:28:53 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:3950 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755180AbYJ3X2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:28:52 -0400
Date: Fri, 31 Oct 2008 02:28:51 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [PATCH 1/3] powerpc: Add mmc-spi-slot bindings
Message-ID: <20081030232851.GA24768@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru> <20081030195630.GA13640@oksana.dev.rtsoft.ru> <fa686aa40810301337p21ac8785gb74b12904bbd08e7@mail.gmail.com> <20081030230253.GA11765@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081030230253.GA11765@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 02:02:53AM +0300, Anton Vorontsov wrote:
[...]
> It's pretty trivial to implement (of_get_named_gpio() -- could be just
> factored out of of_get_gpio()).
> 
> Though,
> 
> 1. The idea is quite extreme. It needs discussion, and furthermore,
>    we need to define when do we use gpios = <> and when something-gpio =
>    <>; We need to be consistent, and to be consistent, the rules should
>    be clear and written.
> 
> 2. We should think about it very very carefully. Do we want to lose the
>    track of gpios? For example, there are quite defined rules when (and
>    in what properties) you may encounter memory addresses, when and
>    where you can encounter interrupt specifiers. We do the same for
>    gpios, and so far it works great. We need to think about any possible
>    drawbacks of the scheme you purpose (we would never know where to
>    expect gpios - it isn't a problem per se, but maybe it could lead
>    to some problem in future? I don't know.)
> 
> Quite honestly I don't like the idea... maybe I just used to
> interrupts = <>, reg = <>, ranges = <>, interrupt-map = <> and so
> forth, and now my subconsciousness tells me "it's wrong to do
> something-interrupt = <> stuff." ;-)

Btw, not that I hate this new scheme, sometimes the scheme is even
inevitable. For example when we have gpios with two or more ellipsis:
gpios = <... ...>.

But this should be a separate discussion, really.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
