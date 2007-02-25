Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXBYKnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXBYKnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXBYKnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:43:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40351 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbXBYKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:43:48 -0500
Date: Sun, 25 Feb 2007 11:43:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Advice on backlight support
Message-ID: <20070225104345.GG2045@elf.ucw.cz>
References: <20070221160213.GK4641@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221160213.GK4641@enneenne.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'd like to add backlight support for input devices since my custom
> board has a backlighted mini keyboard.
> 
> It could be acceptable to move the code from drivers/video/backlight/
> to drivers/backlight/ renaming the "Backlight & LCD" name into
> "Backlight" and adding two new entries "LCD" and, maybe, "Input" (or
> something like that?).

Either that or using led class...

...keyboard backlight actually has selectable level in many cases, so
I'm not sure how possible it is to do with led class...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
