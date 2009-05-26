Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbZEZUmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbZEZUmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZEZUmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:42:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755471AbZEZUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:42:32 -0400
Date: Tue, 26 May 2009 13:41:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com,
       randy.dunlap@oracle.com, cl@linux-foundation.org, linux-mm@kvack.org,
       pavel@ucw.cz, dave@linux.vnet.ibm.com, davem@davemloft.net,
       linux@dominikbrodowski.net, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][mmtom] clean up once printk routine
Message-Id: <20090526134134.bb3e1e23.akpm@linux-foundation.org>
In-Reply-To: <20090526155943.aef3ba62.minchan.kim@barrios-desktop>
References: <20090526135733.3c38f758.minchan.kim@barrios-desktop>
	<20090526155155.6871.A69D9226@jp.fujitsu.com>
	<20090526155943.aef3ba62.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 15:59:43 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, 26 May 2009 15:52:32 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > == CUT HERE ==
> > > 
> > > There are some places to be able to use printk_once instead of hard coding.
> > > 
> > > It will help code readability and maintenance.
> > > This patch doesn't change function's behavior.
> > > 
> > > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > > CC: Dominik Brodowski <linux@dominikbrodowski.net>
> > > CC: David S. Miller <davem@davemloft.net>
> > > CC: Ingo Molnar <mingo@elte.hu>
> > > ---
> > >  arch/x86/kernel/cpu/common.c  |    8 ++------
> > >  drivers/net/3c515.c           |    7 ++-----
> > >  drivers/pcmcia/pcmcia_ioctl.c |    9 +++------
> > >  3 files changed, 7 insertions(+), 17 deletions(-)
> > 
> > Please separete to three patches ;)
> 
> After I listen about things I missed, I will repost it at all once with each patch.

Yes, that would be better.  But for a trivial little patch like this I
expect we can just merge it and move on.  But please do split up these
multi-subsystem patches in future.


