Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYI3Xj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYI3Xj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYI3XjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:39:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51034 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753514AbYI3XjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:39:00 -0400
Date: Wed, 1 Oct 2008 01:19:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: carbonated beverage <ramune@net-ronin.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
Message-ID: <20080930231952.GB15903@ucw.cz>
References: <20080925060244.GA18945@net-ronin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925060244.GA18945@net-ronin.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I just upgraded from 2.6.25.17 to 2.6.26.5 on my Thinkpad Z61t, and found
> the brightness keys will cause the X server to die.  When using the
> brightness up/down keys, the screen will go blank -- Control+Alt+F# will
> still switch to a different virtual console, but switching back will not
> restore the video state.
> 
> After killing the window manager, I was able to bring up X again without
> a problem -- but using the brightness keys still causes it to go blank
> again within X, while the brightness does get changed correctly on the
> console.
> 
> There were no kernel messages, but this appeared in the Xorg log:

Yes, I had similar problems... for me it blanked screen on closing
lid. Problem disappeared after upgrading X...

> .config attached -- is this a known issue?  In the meantime, I'm starting
> a bisection to figure out where the problem crops up.

For me CONFIG_ACPI_VIDEO never really worked...


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
