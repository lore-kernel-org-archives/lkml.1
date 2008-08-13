Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYHMNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYHMNGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYHMNGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:06:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2506 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbYHMNGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:06:09 -0400
Date: Wed, 13 Aug 2008 15:05:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: Milan Plzik <milan.plzik@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Timer unstability on when using C2 and deeper sleep states (Dell Latitude XT)
Message-ID: <20080813130558.GE6995@ucw.cz>
References: <1218566008.13866.41.camel@localhost> <1218625125.4304.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218625125.4304.7.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>   I apologize for replying on my own mail (and also for top-posting, but
> this information is global update, not exactly fitting any of topics
> mentioned below).
> 
>   After playing for a longer while I found out that the system ends
> sometimes in state where, in order to do anything useful, I need to
> press keys on keyboard. Otherwise, the system just stalls and does
> nothing. I have no idea why does this happen (especially when I know

I have seen it before with NOHZ problems. Try nohz=off, highres=off ?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
