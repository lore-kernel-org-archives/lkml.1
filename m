Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbXJENPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbXJENPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbXJENPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:15:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2168 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754615AbXJENPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:15:44 -0400
Date: Fri, 5 Oct 2007 13:15:31 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Bernardo Innocenti <bernie@codewiz.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Andres Solomon <dilinger@queued.net>,
       OLPC Development <devel@laptop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] GEODE: decouple sleep/resume from powerdown/powerup
Message-ID: <20071005131530.GC7397@ucw.cz>
References: <1190589101921-git-send-email-bernie@codewiz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190589101921-git-send-email-bernie@codewiz.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch merges the fb_powerup and fb_powerdown hooks in a single
> operation fb_power with an additional "state" parameter ranging
> from 0 (running) to 3 (poweroff).

No, please don't. Having int with 0/3 being valid specifying what to
do is evil.

enum is less evil, but what's wrong about having 3 functions?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
