Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYBXH4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYBXH4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYBXHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:55:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4543 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751724AbYBXHzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:55:38 -0500
Date: Sat, 23 Feb 2008 21:49:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <liml@rtr.ca>
Cc: Anders Eriksson <aeriksson@fastmail.fm>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang
Message-ID: <20080223204900.GA4340@ucw.cz>
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <47BF0DCD.4060400@garzik.org> <20080222185645.9DD9C93C12F@tippex.mynet.homeunix.org> <47BF3DE3.4000100@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BF3DE3.4000100@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So that's using the old IDE drivers.
> And the network and USB are sharing IRQ#11 with each 
> other.
> 
> If you are going to be using newer kernels like this 
> (2.6.23+),
> then you might consider shifting those drives over to 
> libata drivers.

Yes, that will probably fix it for him, but but... maybe we should fix
that regression?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
