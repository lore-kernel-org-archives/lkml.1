Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYJaH43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYJaH43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYJaHzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:55:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47321 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYJaHzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:55:45 -0400
Date: Fri, 31 Oct 2008 08:57:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081031075705.GA32689@elf.ucw.cz>
References: <200810281744.52587.elendil@planet.nl> <20081030195031.GA22805@elf.ucw.cz> <200810310104.25932.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810310104.25932.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-10-31 01:04:25, Frans Pop wrote:
> On Thursday 30 October 2008, Pavel Machek wrote:
> > Try "nohz=off highres=off"...
> 
> Oh, I have no doubt that that could help. The point is though that I don't 
> think I should have to use such parameters.
> 
> I think we've already established that disabling hires timers helps, so, 
> unless this will provide some additional tracing info to the developers, 
> I think I'll skip this suggestion.
> 
> 2.6 28-rc2 is a regression against 2.6.27 because hires is broken. I don't 
> think I'll want to permanently add random boot parameters to work around 
> that regression.

Well, you could probably narrow it down to "nohz=off", because I
believe it is probably nohz and not highres that makes problems.

Anyway, if this does not get fixed soon, you should cc rjw so this
gets on the regression list.

You can probably debug this with git bisect if no other ideas
surface...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
