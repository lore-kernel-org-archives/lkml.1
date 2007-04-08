Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbXDHM4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbXDHM4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 08:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbXDHM4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 08:56:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3534 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149AbXDHM4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 08:56:47 -0400
Date: Sun, 8 Apr 2007 12:56:36 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Message-ID: <20070408125636.GB4404@ucw.cz>
References: <200704072320.40238.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704072320.40238.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Some time ago we discussed the possibility of simplifying the swsusp's approach
> towards tracking the swap pages allocated by it for saving the image (so that
> they can be freed if there's an error).
> 
> I think we can get back to it now, as it is a nice optimization that should
> allow us to use less memory (almost always) and improve performance a bit.
> 

Well, I do not think you can measure the difference, but...

>  kernel/power/power.h  |   27 +---------
>  kernel/power/swap.c   |   18 +-----
>  kernel/power/swsusp.c |  135 ++++++++++++++++++++++++++------------------------
>  kernel/power/user.c   |   22 +-------
>  4 files changed, 85 insertions(+), 117 deletions(-)

....as it removes code... I think we can do that. But it is 2.6.23+
material.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
