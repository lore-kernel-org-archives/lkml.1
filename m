Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZCFS40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZCFS40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZCFS4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:56:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43857 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZCFS4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:56:16 -0500
Date: Fri, 6 Mar 2009 19:55:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where to put new sensor drivers?
Message-ID: <20090306185521.GA1299@ucw.cz>
References: <20090301124134.GE20813@buzzloop.caiaq.de> <20090305150334.GC29699@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305150334.GC29699@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-03-05 16:03:34, Daniel Mack wrote:
> On Sun, Mar 01, 2009 at 01:41:34PM +0100, Daniel Mack wrote:
> > I wrote a driver for an I2C connected ambient light sensor and submitted
> > it to the linux-i2c list[1]. In the first place, I wasn't aware of
> > drivers/i2c/chips being deprecated and hencei, I subsequently moved it to
> > what seemed to match best in the current tree, drivers/hwmon. But as
> > Jean Delvare pointed out, this is not the place for it either because it
> > doesn't really monitor the hardware, which is true.
> > 
> > So I posted a proposal[2] patch series that adds drivers/sensors for
> > such cases (some of the drivers in the legacy folder drivers/i2c/chips
> > have the same problem than my new one has) but haven't got reply on it
> > yet, probably because linux-i2c is the wrong place to ask.
> 
> Hmm, no feedback here either? I was pointed to the 'industrial I/O'
> thread[1], but that one didn't go mainline yet, and I didn't find any
> reference of someone picking up this idea.

Well drivers/sensors sounds  sane. Or maybe drivers/senses :-). 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
