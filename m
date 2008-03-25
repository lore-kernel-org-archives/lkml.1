Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYCYABc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYCYABc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 20:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYCYABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 20:01:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYCYABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 20:01:24 -0400
Date: Mon, 24 Mar 2008 17:00:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: +
 netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch added
 to -mm tree
Message-Id: <20080324170048.50fc8972.akpm@linux-foundation.org>
In-Reply-To: <20080324.164810.83653077.davem@davemloft.net>
References: <20080324161045.045ef5c8.akpm@linux-foundation.org>
	<20080324.162138.50436206.davem@davemloft.net>
	<20080324163105.154a031a.akpm@linux-foundation.org>
	<20080324.164810.83653077.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 16:48:10 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Mon, 24 Mar 2008 16:31:05 -0700
> 
> > On Mon, 24 Mar 2008 16:21:38 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> > 
> > > net-2.6.26 is what is going into the linux-next tree
> > 
> > urgh.  I wish I had some algorithm for detecting when net-2.6.x+1 appears.
> > 
> > Perhaps you could create it on the day 2.6.x is released and leave it empty
> > for a while.  That way I'll notice when net-2.6.x vanishes and I can switch
> > to 2.6.x+1 immediately?
> 
> Sure, but in this case you were using plain "net-2.6" which is only
> for bug fixes and is synced fairly rapidly to Linus, so I don't
> see how this is relevant here.

The relevance is that I should have net-2.6.26 in my lineup, but I don't
because I didn't know that it was available, and I didn't think to check.

If I _did_ have net-2.6.26 here, I'd have immediately seen that you'd
already applied this patch.

> net-2.6 is always just a sync mechanism, rarely generating merge
> conflicts with other people, and not something people other than say
> Jeff Garzik and John Linville (people who actively push to me) should
> generally follow unless they want to.  It's just the same to follow
> Linus's tree especially as the -rcX process winds down.
> 
> If you had been using net-2.6.24 or something like that, yeah I
> could see the issue :-)

I dropped net-2.6.24 when its git-fetch started failing.  But I have no
automatable way of knowing when to start picking up net-2.6.25.

