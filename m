Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZLAUgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZLAUgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbZLAUgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:36:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40066 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLAUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:36:46 -0500
Date: Tue, 1 Dec 2009 21:36:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: divide by zero in termios when setting bluetooth
Message-ID: <20091201203642.GA2431@elf.ucw.cz>
References: <20091201151315.GC2262@elf.ucw.cz>
 <20091201155244.0523d9c9@lxorguk.ukuu.org.uk>
 <20091201160151.GD2262@elf.ucw.cz>
 <20091201190010.317d5b29@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201190010.317d5b29@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-12-01 19:00:10, Alan Cox wrote:
> > > +	/* Should never happen */
> > > +	WARN_ON(1);
> > >  	return 0;
> > 
> > Does this mean WARN_ON() on user error? Maybe printk(KERN_ERR) with
> > explanation would be better?
> 
> It shouldn't be possible to cause that case user error or otherwise.

You are right, I did not notice for() loop above. I actually tested
the change now, and it seems to fix the problem.

ACK.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
