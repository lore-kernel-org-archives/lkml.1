Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZJWFU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZJWFU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 01:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZJWFUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 01:20:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53717 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZJWFUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 01:20:55 -0400
Date: Fri, 23 Oct 2009 07:20:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Eric Miao <eric.y.miao@gmail.com>, Andrew Morton <akpm@osdl.org>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Subject: Re: spitz backlight: fix brightness limiting
Message-ID: <20091023052052.GA15499@elf.ucw.cz>
References: <20091019213751.GC1482@ucw.cz>
 <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com>
 <1256251399.23211.164.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256251399.23211.164.camel@dax.rpnet.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-22 23:43:19, Richard Purdie wrote:
> On Thu, 2009-10-22 at 04:20 +0800, Eric Miao wrote:
> > It's a little bit weird it's called 'limit_mask' when I first converted it
> > to a spi driver. There must be some reasons, Richard, you've got
> > any ideas?
> 
> Its a historical artifact that once worked through some bitfield magic
> but probably stopped working when we increased the range of values the
> backlight could accept and we didn't notice the limiting problem.
> 
> I'll happily take a patch to fix that.

Patch is available in the parent post. For now, I just fix it so that
it does not turn backlight off when it should not. I'll submit
limit_mask -> limit as separate patch, ok?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
