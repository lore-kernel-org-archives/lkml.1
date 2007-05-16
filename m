Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbXEPQv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbXEPQv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbXEPQvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:51:19 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:35601 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXEPQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:51:18 -0400
Date: Wed, 16 May 2007 19:51:07 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-ID: <20070516165107.GA13190@localdomain>
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy> <20070513182035.GA10207@infradead.org> <20070515082311.GA6816@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515082311.GA6816@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:23:11AM +0000, Pavel Machek wrote:
> On Sun 2007-05-13 19:20:35, Christoph Hellwig wrote:
> > On Sun, May 13, 2007 at 09:23:52AM -0700, Stephen Hemminger wrote:
> > > On Sun, 13 May 2007 16:25:17 +0300
> > > Dan Aloni <da-x@monatomic.org> wrote:
> > > 
> > > > Kernel developers might find it useful for quickly getting out from some 
> > > > rough debugging scenarios.
> > > > 
> > > > Signed-off-by: Dan Aloni <da-x@monatomic.org>
> > > > 
> > > 
> > > There is already the modprobe blacklist ability in user space.
> > 
> > doesn't really help if hotplug loads a broken module before you're getting
> > a login prompt.  So while this is a bit of a hack I'm all in favour of this.
> > (Especially as I got hit by this issue again yesterday)
> 
> It is quite a bick hack. Unknown kernel parameters are passed to init,
> can we just make modprobe parse that?

We can, and then we also have to patch busybox's own fork of modprobe
and every other code out there that does the same thing (not so much, 
but still).

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
