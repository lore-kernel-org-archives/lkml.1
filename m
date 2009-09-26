Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZIZLwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZIZLwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 07:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZIZLwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 07:52:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56423 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZIZLwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 07:52:42 -0400
Date: Sat, 26 Sep 2009 13:44:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, arve@android.com,
       swetland@google.com
Subject: Re: Staging: dream: fix build errorsg
Message-ID: <20090926114408.GC3105@ucw.cz>
References: <20090911212751.GA25544@elf.ucw.cz> <20090916174803.GA28689@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916174803.GA28689@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-16 10:48:03, Greg KH wrote:
> On Fri, Sep 11, 2009 at 11:27:52PM +0200, Pavel Machek wrote:
> > 
> > Fix compilation of gpio_* input drivers on -next kernel. Adds needed
> > headers and removes unprotected wakelock/earlysuspend dependencies.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/staging/dream/gpio_event.c  |    3 
> >  drivers/staging/dream/gpio_input.c  |    7 -
> >  drivers/staging/dream/gpio_matrix.c |    8 -
> >  include/linux/gpio_event.h          |  154 ++++++++++++++++++++++++++++++++++++
> 
> This adds a file outside of the staging tree, so I'm going to drop it,
> sorry.

Ok, whats the preffered solution here? Create staging/include/linux
and add gcc -I magic so it gets used?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
