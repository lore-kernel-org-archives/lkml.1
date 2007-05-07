Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbXEGOQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbXEGOQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXEGOQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:16:28 -0400
Received: from mail.z-net.ru ([89.113.80.10]:1271 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbXEGOQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:16:27 -0400
Date: Mon, 7 May 2007 18:16:15 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 5/8] APM emulation driver for class batteries
Message-ID: <20070507141615.GB10858@zarina>
Reply-To: cbou@mail.ru
References: <20070503213237.GE20067@zarina> <20070507140148.GC3868@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070507140148.GC3868@ucw.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 02:01:48PM +0000, Pavel Machek wrote:
> Hi!
> 
> > Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> > ---
> >  drivers/power/Kconfig     |    7 ++
> >  drivers/power/Makefile    |    1 +
> >  drivers/power/apm_power.c |  249 +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 257 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/power/apm_power.c
> > 
> 
> > +#ifdef current
> > +#undef current /* it expands to get_current() */
> > +#endif
> 
> Uff, now that's a dirty hack. Can you rename your variables? current
> -> I?

Thanks, will try to cook something.

> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
> 

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
