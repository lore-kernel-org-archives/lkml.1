Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZKGQsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZKGQsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 11:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZKGQsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 11:48:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60840 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZKGQsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 11:48:38 -0500
Date: Sat, 7 Nov 2009 17:48:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>
Subject: Re: [patch] added brightness feature to lcd class.
Message-ID: <20091107164830.GA1586@ucw.cz>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com> <20091105192725.GE1392@ucw.cz> <90b950fc0911070443s57d2ec5ehcb5c9cf9edcf8d8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90b950fc0911070443s57d2ec5ehcb5c9cf9edcf8d8c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-11-07 21:43:50, InKi Dae wrote:
> Thank you for your comments.
> 
> using backlight is good way in case of TFT-LCD Panel.
> because TFT-LCD Panel needs backlight device to light up.
> 
> but AMOLED LCD Panel doesn't need backlight device because lighting up itself.

I know. So what?

User wants to set brightness. Why should userspace know/care if it is
TFT or AMOLED?

I have this script:

#!/bin/bash
echo $1 > /sys/class/backlight/*/brightness 

why should I have to rewrite it just because you decided amoled is
special?

Kernel is expected to provide hw abstraction...

									Pavel

									
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
