Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZI3TiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZI3TiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbZI3TiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:38:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:24124 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbZI3TiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=GlNrj9+p8Agnf7Q4xqWGDDnZORCjuPta8yVRwYSuH0SRWYwKEr4QicqejWYjESjTvY
         any+1OzHjYzvfSlZnNZLHwk7k3wk0GKTUcvfIMV4R4PizhW9Q9JzJeFVR+7jeor+tWT6
         tLcPgwoHkIgH0O/ixufgRiM9S2H4aVdq1nZsY=
Date: Wed, 30 Sep 2009 21:38:09 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andy <genanr@emsphone.com>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: How can I download a git commit as a diff patch?
Message-ID: <20090930213809.71c2a8e8@varda>
In-Reply-To: <20090930190014.GA22161@csclub.uwaterloo.ca>
References: <20090930154410.GA31502@thumper2>
	<20090930085500.a5856301.rdunlap@xenotime.net>
	<20090930190014.GA22161@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 30 Sep 2009 15:00:14 -0400

 CCing git@vger.kernel.org ??

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) escribió:

> On Wed, Sep 30, 2009 at 08:55:00AM -0700, Randy Dunlap wrote:
> > On Wed, 30 Sep 2009 10:44:10 -0500 Andy wrote:
> > 
> > > I just want to down a particular git commit as a patch, not a git commit or
> > > anything.  Yes, I can see the diffs on the web, but unless I am missing
> > > something all are in unless html formats for me.  And cut and past from the
> > > web page does not help either because some lines get mangled.  Is there some
> > > site, or git itself, that would allow be to get the git commit as a simple
> > > patch?
> > 
> > Look at the commitdiff using the web interface, then click on "raw" near
> > the upper left corner.
> 
> Of course some git diff's are not in a format that patch will like as
> far as I can tell.
> 
> For example commit 6cdee2f96a97f6da26bd3759c3f8823332fbb438 which has
> stuff like:
> diff --cc drivers/net/ixp2000/ixpdev.c
> index 588b44d,92fb823..1272434
> --- a/drivers/net/ixp2000/ixpdev.c
> +++ b/drivers/net/ixp2000/ixpdev.c
> @@@ -67,9 -68,9 +68,9 @@@ static int ixpdev_xmit(struct sk_buff *
>         ip->tx_queue_entries++;
>         if (ip->tx_queue_entries == TX_BUF_COUNT_PER_CHAN)
>                 netif_stop_queue(dev);
> -       local_irq_enable();
> +       local_irq_restore(flags);
> 
>  -      return 0;
>  +      return NETDEV_TX_OK;
>   }
> 
> 
> 
> Ehm, what does that mean?  patch doesn't like it.
> 
> Do git merges cause weird diffs?
> 
