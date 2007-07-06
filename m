Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbXGFJLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbXGFJLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXGFJLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:11:06 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:35295 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbXGFJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:11:06 -0400
To: oliver@neukum.org
CC: miklos@szeredi.hu, rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz,
       benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-reply-to: <200707060951.47555.oliver@neukum.org> (message from Oliver
	Neukum on Fri, 6 Jul 2007 09:51:47 +0200)
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707060940.23248.rjw@sisk.pl> <E1I6iPL-0003Hj-00@dorka.pomaz.szeredi.hu> <200707060951.47555.oliver@neukum.org>
Message-Id: <E1I6jot-0003U1-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 11:09:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Moreover, if FUSE implements syncing, then the sync from within the freezer
> > > will almost certainly deadlock.
> > 
> > Rafael, think positively: by the time fuse implements sync(), the
> > freezer will be long gone ;)
> 
> Now you are entering really dangerous territory.
> If you can implement a meaningfull sync method, you must have dirty
> pages in the page cache. That means you are in the page freeing path
> of the vm. Then we are in real trouble. Don't even think about it.

VM induced deadlocks are real nasty.  I have thought about them a lot
already.  Suspend shouldn't introduce any big surprises.

Miklos
