Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZFZDSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZFZDSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 23:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZFZDSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 23:18:37 -0400
Received: from kroah.org ([198.145.64.141]:59464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZFZDSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 23:18:37 -0400
Date: Thu, 25 Jun 2009 19:46:36 -0700
From: Greg KH <greg@kroah.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Guennadi Liakhovetski <lg@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LED: Reply-To: use correct name for
	/sys/devices/virtual/leds/ entries
Message-ID: <20090626024636.GA18329@kroah.com>
References: <20090624223343.GA17235@kroah.com> <1245927475.6001.38.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245927475.6001.38.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 11:57:55AM +0100, Richard Purdie wrote:
> On Wed, 2009-06-24 at 15:33 -0700, Greg KH wrote:
> > From: Olaf Hering <olh@suse.de>
> > 
> > This is needed to get kde-powersave to work properly on some g4
> > powerbooks.
> > 
> > From: Olaf Hering <olh@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> I'm ok with this apart from:
> 
> > --- a/drivers/leds/ledtrig-default-on.c
> > +++ b/drivers/leds/ledtrig-default-on.c
> > @@ -23,7 +23,7 @@ static void defon_trig_activate(struct l
> >  }
> >  
> >  static struct led_trigger defon_led_trigger = {
> > -	.name     = "default-on",
> > +	.name     = "default::on",
> >  	.activate = defon_trig_activate,
> >  };
> 
> which doesn't seem to match the patch description. Why does the trigger
> name need to be changed?

I really don't know, I took this patch from the suse tree, and Olaf is
gone and I can't ask him :(

If you don't think it is needed/correct, please drop that part.  Or I
can redo it without it.

thanks,

greg k-h
