Return-Path: <linux-kernel-owner+w=401wt.eu-S935078AbXHHXGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbXHHXGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbXHHXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:06:26 -0400
Received: from mail.queued.net ([207.210.101.209]:1666 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867AbXHHXGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:06:25 -0400
X-Greylist: delayed 1898 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 19:06:25 EDT
Date: Wed, 8 Aug 2007 19:07:13 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: turn serial console suspend a boot rather than
 compile time option
Message-Id: <20070808190713.b59c9b00.dilinger@queued.net>
In-Reply-To: <20070808154130.9cc3a30e.akpm@linux-foundation.org>
References: <20070808183535.2a2c6edf.dilinger@queued.net>
	<20070808154130.9cc3a30e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 15:41:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 8 Aug 2007 18:35:35 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
[...]
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -172,6 +172,8 @@ extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
> >  extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
> >  				unsigned int interval_msec);
> >  
> > +extern int console_suspend;
> > +
> 
> That's a somewhat vague-sounding identifier.  Could we call it
> console_suspend_enabled or something?
> 

Hm, how about serial_console_suspend_enabled or enable_serial_console_suspend?  I can send an updated patch later.


-- 
Andres Salomon <dilinger@queued.net>
