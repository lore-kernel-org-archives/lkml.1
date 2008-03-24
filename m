Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbYCXXsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbYCXXsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYCXXsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:48:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43815
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbYCXXsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:48:20 -0400
Date: Mon, 24 Mar 2008 16:48:10 -0700 (PDT)
Message-Id: <20080324.164810.83653077.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: +
 netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch added
 to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080324163105.154a031a.akpm@linux-foundation.org>
References: <20080324161045.045ef5c8.akpm@linux-foundation.org>
	<20080324.162138.50436206.davem@davemloft.net>
	<20080324163105.154a031a.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 24 Mar 2008 16:31:05 -0700

> On Mon, 24 Mar 2008 16:21:38 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > net-2.6.26 is what is going into the linux-next tree
> 
> urgh.  I wish I had some algorithm for detecting when net-2.6.x+1 appears.
> 
> Perhaps you could create it on the day 2.6.x is released and leave it empty
> for a while.  That way I'll notice when net-2.6.x vanishes and I can switch
> to 2.6.x+1 immediately?

Sure, but in this case you were using plain "net-2.6" which is only
for bug fixes and is synced fairly rapidly to Linus, so I don't
see how this is relevant here.

net-2.6 is always just a sync mechanism, rarely generating merge
conflicts with other people, and not something people other than say
Jeff Garzik and John Linville (people who actively push to me) should
generally follow unless they want to.  It's just the same to follow
Linus's tree especially as the -rcX process winds down.

If you had been using net-2.6.24 or something like that, yeah I
could see the issue :-)
