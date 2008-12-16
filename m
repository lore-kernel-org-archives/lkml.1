Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752115AbYLQNJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbYLQNJp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 08:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYLQNJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 08:09:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45401 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYLQNJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 08:09:30 -0500
Date: Tue, 16 Dec 2008 22:10:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: euphoria@inbox.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: losing a menuconfig session to a typo
Message-ID: <20081216211009.GA2041@ucw.cz>
References: <CCCA86B6E10.000005AEeuphoria@inbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CCCA86B6E10.000005AEeuphoria@inbox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-12-15 13:03:28, euphoria@inbox.com wrote:
> It's easy to accidentally lose a menuconfig session.  Scenarios start with a
> user being accustomed to hitting [right-arrow][return] to exit from a typical
> menu.  Perhaps the user prefers his underutilized numeric keypad over adding to
> the beating [escape] takes.  Scenarios finish with the user accidentally
> issuing [right-arrow][return] to "Do you wish to save? <Yes> <No>".  I only
> lost a quick change, but it's easy to imagine how a few hours of menuconfig
> time might go away.  "It'll just take a few minutes to whip my distro's kernel
> into shape."  Yeah right.  Four hours of guesswork and research later, you're
> tired, thinking about the make command to follow, [right-arrow][return] as
> usual, wait! no! damndamndamn!, yer snookered.
> 
> There are a variety of simple ways to address this.  First, change the menu.
> Swapping the order of the <Yes> and <No> would be begging for even more
> trouble.  However, the <Yes>/<No> decision could be made a <Yes>/<Maybe>/<No>
> decision.  This leaves <Yes>, the predominant choice, in place.  <Maybe>, in
> the disputed position, could simply present the same menu.  Someone might even
> have a little well-deserved fun with <Maybe> menus.  This doesn't
seem all that

Too ugly to live. But maybe periodically saving config to
.config.autosave once in 5 minutes...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
