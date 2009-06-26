Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbZFZUrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbZFZUrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZFZUq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:46:58 -0400
Received: from kroah.org ([198.145.64.141]:53030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZFZUq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:46:57 -0400
Date: Fri, 26 Jun 2009 13:42:14 -0700
From: Greg KH <greg@kroah.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Guennadi Liakhovetski <lg@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LED: Reply-To: use correct name for
	/sys/devices/virtual/leds/ entries
Message-ID: <20090626204214.GA20651@kroah.com>
References: <20090624223343.GA17235@kroah.com> <1245927475.6001.38.camel@dax.rpnet.com> <20090626024636.GA18329@kroah.com> <1246010487.6003.4.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246010487.6003.4.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 11:01:27AM +0100, Richard Purdie wrote:
> On Thu, 2009-06-25 at 19:46 -0700, Greg KH wrote:
> > On Thu, Jun 25, 2009 at 11:57:55AM +0100, Richard Purdie wrote:
> > > On Wed, 2009-06-24 at 15:33 -0700, Greg KH wrote:
> > > > From: Olaf Hering <olh@suse.de>
> > > > 
> > > > This is needed to get kde-powersave to work properly on some g4
> > > > powerbooks.
> > > > 
> > > > From: Olaf Hering <olh@suse.de>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > I'm ok with this apart from:
> > > 
> > > > --- a/drivers/leds/ledtrig-default-on.c
> > > > +++ b/drivers/leds/ledtrig-default-on.c
> > > > @@ -23,7 +23,7 @@ static void defon_trig_activate(struct l
> > > >  }
> > > >  
> > > >  static struct led_trigger defon_led_trigger = {
> > > > -	.name     = "default-on",
> > > > +	.name     = "default::on",
> > > >  	.activate = defon_trig_activate,
> > > >  };
> > > 
> > > which doesn't seem to match the patch description. Why does the trigger
> > > name need to be changed?
> > 
> > I really don't know, I took this patch from the suse tree, and Olaf is
> > gone and I can't ask him :(
> > 
> > If you don't think it is needed/correct, please drop that part.  Or I
> > can redo it without it.
> 
> I'll just drop that bit. As far as I can see it would just break any
> users of that trigger for no good reason...

Thanks for dropping it, I'll go change the suse patch as well.

thanks,

greg k-h
