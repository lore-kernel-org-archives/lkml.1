Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbZKET1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbZKET1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbZKET1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:27:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58088 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZKET13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:27:29 -0500
Date: Thu, 5 Nov 2009 20:27:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>
Subject: Re: [patch] added brightness feature to lcd class.
Message-ID: <20091105192725.GE1392@ucw.cz>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-02 17:50:02, InKi Dae wrote:
> This patch adds brightness feature to lcd class.
> (kernel/driver/video/backlight/lcd.c)
> 
> In the past, most of the lcd panels for embedded system was TFT-LCD
> Panel needing backlight device.
> But now AMOLED LCD Panel appeared so we should consider brightness
> control for AMOLED Panel.
> 
> For the time being, I used backlight fake driver for brightness
> control of AMOLED LCD Panel.
> But this way is not good, so I propose to add brightness feature to lcd class.
>

Why is it 'not good'? Using backlight driver seems like way to go to
me.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
