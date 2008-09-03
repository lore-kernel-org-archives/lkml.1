Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYICTcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYICTcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYICTcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:32:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbYICTcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:32:08 -0400
Date: Wed, 3 Sep 2008 12:32:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: andi@firstfloor.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] Add a SYSTEM_PANIC state
Message-Id: <20080903123202.91e8ce4d.akpm@linux-foundation.org>
In-Reply-To: <20080903191650.GV18288@one.firstfloor.org>
References: <20080902349.573187695@firstfloor.org>
	<20080902134922.9401F3E6A00@basil.firstfloor.org>
	<20080903120423.9e00557c.akpm@linux-foundation.org>
	<20080903191650.GV18288@one.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 21:16:51 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Sep 03, 2008 at 12:04:23PM -0700, Andrew Morton wrote:
> > On Tue,  2 Sep 2008 15:49:22 +0200 (CEST)
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > --- linux.orig/include/linux/kernel.h
> > > +++ linux/include/linux/kernel.h
> > > @@ -248,6 +248,7 @@ extern enum system_states {
> > >  	SYSTEM_POWER_OFF,
> > >  	SYSTEM_RESTART,
> > >  	SYSTEM_SUSPEND_DISK,
> > > +	SYSTEM_PANIC,
> > >  } system_state;
> > 
> > system_state is such a crock.  I wonder what other random code all over
> > the place is looking at system_state and will get unexpectedly broken
> > by other "unrelated" changes such as this..
> 
> >From a quick grep none.
> 
> Also I think it's a natural extension.
> 
> > 
> > 
> > It's not a heck of a lot nicer, but we could do this:
> 
> Sorry but I think it's far worse. How do you think it's
> better?
> 

For the reason which I stated and which you carefully deleted prior to
asking my reason.

Sheesh.
