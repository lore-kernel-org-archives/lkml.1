Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbYHSUQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbYHSUQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYHSUQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:16:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376AbYHSUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:16:19 -0400
Date: Tue, 19 Aug 2008 13:15:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: rmk+lkml@arm.linux.org.uk, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, david-b@pacbell.net,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [BUG] rtc uie emulation deadlocks
Message-Id: <20080819131546.51dea318.akpm@linux-foundation.org>
In-Reply-To: <915094.18966.qm@web82205.mail.mud.yahoo.com>
References: <20080819005320.00075dba.akpm@linux-foundation.org>
	<915094.18966.qm@web82205.mail.mud.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 10:12:04 -0700 (PDT)
David Brownell <david-b@pacbell.net> wrote:

> 
> --- Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 11 Aug 2008 14:43:39 +0100 Russell King
> > <rmk+lkml@arm.linux.org.uk> wrote:
> > 
> > > The locking looks a rather random in there, so I'm not going to try to
> > > create a patch.
> > > 
> > 
> > Looks like this was caused by
> > 
> > commit 5ad31a575157147b43fa84ef1e21471661653878
> > Author: David Brownell <david-b@pacbell.net>
> > Date:   Wed Jul 23 21:30:33 2008 -0700
> > 
> >     rtc: remove BKL for ioctl()
> 
> I'm sure I saw someone else's fixup patch for that a couple weeks ago.
> (Looks).  Yes:
> 
> http://groups.google.com/group/rtc-linux/browse_thread/thread/ad65b883739f8c92#

argh, so a fix for a serious regression has been languishing in the
backwaters of the rtc list for two weeks.

Guys, please: regressions are serious, top-priority emergencies.  We
drop everything and run around with our hair on fire when we hear about
one (don't we?).  Please, if you have a report of a regression or a fix
for one, Cc: everyone in the world on it.

I'd prefer not to go fishing through HTML to piece that patch together,
but as my hair is on fire I guess I'd better do so.

