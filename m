Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYD2Dmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYD2Dmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYD2Dmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:42:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42410 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYD2Dmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:42:36 -0400
Date: Mon, 28 Apr 2008 20:42:19 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Message-ID: <20080429034219.GA1413@kroah.com>
References: <200804281239.51729.david-b@pacbell.net> <20080428134649.44cf239c.akpm@linux-foundation.org> <200804281628.14004.david-b@pacbell.net> <20080428195455.6e07cb8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428195455.6e07cb8d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 07:54:55PM -0700, Andrew Morton wrote:
> On Mon, 28 Apr 2008 16:28:13 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > > If we had a strcmp() variant which treats a \n in the first arg as a \0
> > > the above would become
> > > 
> > > 	if (sysfs_streq(buf, "high"))
> > > 		status = gpio_direction_output(gpio, 1);
> > > 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
> > > 		status = gpio_direction_output(gpio, 0);
> > > 	else if (sysfs_streq(buf, "in"))
> > > 		status = gpio_direction_input(gpio);
> > 
> > That would indeed be better.  Maybe I should whip up a sysfs
> > patch adding that, and have this depend on that patch.  (I've
> > CC'd Greg in case he has comments on that...)
> 
> Yes, it would be a standalone patch.  The sort which generates oceans of
> useful feedback ;) The sort which also generates hundreds of
> use-new-toy-to-clean-up-old-code patches for me to merge :(

Heh, sounds good to me :)

Becides, with linux-next, that merge mess is my problem now, not -mm...

thanks,

greg k-h
