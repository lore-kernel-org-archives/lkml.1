Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYKOStr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYKOStr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 13:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYKOStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 13:49:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50601 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYKOStj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 13:49:39 -0500
Date: Sat, 15 Nov 2008 19:51:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Fix locking for WM8350
Message-ID: <20081115185119.GA19900@elf.ucw.cz>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081115173110.GD1523@ucw.cz> <20081115175050.GB12466@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081115175050.GB12466@opensource.wolfsonmicro.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-11-15 17:50:50, Mark Brown wrote:
> On Sat, Nov 15, 2008 at 06:31:10PM +0100, Pavel Machek wrote:
> 
> > Unfortunately, now you write to value w/o locking -> races
> > possible. Maybe you need to make value atomic_t?
> 
> Yes, that'd be safer though I'd be surprised to see systems that could
> trigger it.

Yes, they are uncommon. They exist; SPARC, IIRC. Plus you need
barriers on anything SMP... Just use atomic_t.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
