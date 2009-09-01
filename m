Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbZIAW3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbZIAW3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZIAW3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:29:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbZIAW3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:29:42 -0400
Date: Tue, 1 Sep 2009 15:29:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rdreier@cisco.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de
Subject: Re: [PATCH 1/1] introduce __cancel_delayed_work()
Message-Id: <20090901152924.d9c24ab9.akpm@linux-foundation.org>
In-Reply-To: <20090901171316.41FAB526EA5@mailhub.coreip.homeip.net>
References: <adazl9uw3w1.fsf@cisco.com>
	<20090828180015.GB19326@redhat.com>
	<ada1vmqpry7.fsf@cisco.com>
	<20090901171316.41FAB526EA5@mailhub.coreip.homeip.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 09:40:33 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > Andrew -- how do you want to handle this?  This seems to be useful for
> > the bug with IB that Oleg linked to, as well as by Dmitry in input, so
> > I'm not sure what the best way to merge all this into 2.6.32 is.
> > 
> > I could take Oleg's patch and the corresponding fix to
> > drivers/infiniband through my tree, and merge as early I as I see Linus
> > open 2.6.32.  That leaves Dmitry to wait on it (and possibly causes
> > problems in -next with tree ordering) though.  But I don't see any way
> > to get the number of cross-tree dependencies below 1... (unless maybe
> > Dmitry can take the identical workqueue patch into his tree and trust
> > git to sort it out?)
> 
> I wonder if Linus would not just take it in 31 - it is a completely
> new function with no current users (but users will surely follow) so
> introducing regression is highly unlikely... That would resolve all
> inter-tree dependencies.
> 
> Otherwise we'll have to leave our fate in the hands of git ;)

I'll try to sneak it into 2.6.31 once Linus returns, but it'll need
good timing.

Or someone else can merge it into their tree, in which case I'll
promptly forget about it ;)
