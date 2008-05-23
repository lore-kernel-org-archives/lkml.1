Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYEWLWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYEWLWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYEWLWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:22:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33862 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbYEWLWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:22:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] snapshot: Push BKL down into ioctl handlers
Date: Fri, 23 May 2008 13:22:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, Pavel Machek <pavel@ucw.cz>
References: <20080522222500.0f5873ff@core> <200805230309.53136.rjw@sisk.pl> <20080523120452.6feefed0@core>
In-Reply-To: <20080523120452.6feefed0@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231322.33321.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 23 of May 2008, Alan Cox wrote:
> > >  
> > > +	lock_kernel();
> > > +
> > 
> > Hm, well, I admit I'm a bit ignorant as far as the chardev locking is
> > concerned, but can you please tell me why would that be wrong if we didn't call
> > lock_kernel() here at all?
> 
> I've just been pushing the lock down. If the code already has enough
> internal locking for things like multiple ioctls in parallel then you can
> probably kill it entirely - but that needs someone who knows that driver
> well to decide and evaluate.

Thanks, I'll have a look.

ACK for the patch from me.

Thanks,
Rafael
