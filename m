Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZJVWr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZJVWr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZJVWr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:47:27 -0400
Received: from dan.rpsys.net ([93.97.175.187]:55002 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbZJVWr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:47:26 -0400
Subject: Re: spitz backlight: fix brightness limiting
From: Richard Purdie <rpurdie@rpsys.net>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
In-Reply-To: <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com>
References: <20091019213751.GC1482@ucw.cz>
	 <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Oct 2009 23:43:19 +0100
Message-Id: <1256251399.23211.164.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 04:20 +0800, Eric Miao wrote:
> It's a little bit weird it's called 'limit_mask' when I first converted it
> to a spi driver. There must be some reasons, Richard, you've got
> any ideas?

Its a historical artifact that once worked through some bitfield magic
but probably stopped working when we increased the range of values the
backlight could accept and we didn't notice the limiting problem.

I'll happily take a patch to fix that.

Cheers,

Richard


