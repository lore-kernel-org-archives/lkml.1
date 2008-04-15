Return-Path: <linux-kernel-owner+w=401wt.eu-S1763268AbYDOJxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763268AbYDOJxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbYDOJxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:53:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40937 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbYDOJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:53:33 -0400
Date: Tue, 15 Apr 2008 11:53:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] Clocklib: add generic framework for managing clocks.
Message-ID: <20080415095332.GB32652@atrey.karlin.mff.cuni.cz>
References: <20080413144138.GA31665@doriath.ww600.siemens.net> <20080413144312.GA1943@doriath.ww600.siemens.net> <20080414231330.b72cd746.akpm@linux-foundation.org> <20080415093451.GA6377@doriath.ww600.siemens.net> <20080415024743.51aeac8c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415024743.51aeac8c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 15 Apr 2008 13:34:51 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > On Mon, Apr 14, 2008 at 11:13:30PM -0700, Andrew Morton wrote:
> > > On Sun, 13 Apr 2008 18:43:12 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > > 
> > > > +#define FUNC_TO_CLK(func)	&(&(struct clk_function) func)->clk
> > > 
> > > scratched my head for a while, was unable to work out what this does.
> > > It is unused, so I think it can be zapped?
> > 
> > It take clk_function and returns pointer to the contained struct clk.
> 
> Then why does it cast a clk_function to a clk_function?
> 
> The innermost `&' hurts my brain.

Hmm, is that obfuscated way of writing

&(func.clk)

?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
