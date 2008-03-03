Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbYCCUhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbYCCUhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYCCUhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:37:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35972 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYCCUhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:37:41 -0500
Date: Mon, 3 Mar 2008 21:38:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: huggie@earth.li, linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080303203808.GH13869@elf.ucw.cz>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080302104031.GB3861@ucw.cz> <20080303204300.69cbe392@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303204300.69cbe392@mjolnir.drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-03 20:43:00, Pierre Ossman wrote:
> On Sun, 2 Mar 2008 11:40:31 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > 
> > Is mmc slow or does it just break down? Slow would be expected, but
> > breaking down should be fixed in MMC, too...
> > 
> 
> The problem is that the kernel sleeps _less_ than asked for, not more. No hardware can be expected to work if its needed delays aren't respected.
> 

Oops, that's bad. Can you perhaps create small testcase for
scheduler/timer people to play with?

Also... you may want to switch timesources. notsc fixed "wait for much
too long" for me.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
