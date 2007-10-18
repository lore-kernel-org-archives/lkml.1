Return-Path: <linux-kernel-owner+w=401wt.eu-S1765460AbXJRP0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765460AbXJRP0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763957AbXJRPZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:25:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763954AbXJRPZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:25:45 -0400
Date: Thu, 18 Oct 2007 08:25:01 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] remove netpoll receive code
Message-ID: <20071018082501.2f7023fd@freepuppy.rosehill>
In-Reply-To: <20071018000244.2513c564.akpm@linux-foundation.org>
References: <20071017132131.1992bedd@freepuppy.rosehill>
	<20071017.232838.41634977.davem@davemloft.net>
	<20071018000244.2513c564.akpm@linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 00:02:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 17 Oct 2007 23:28:38 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> 
> > From: Stephen Hemminger <shemminger@linux-foundation.org>
> > Date: Wed, 17 Oct 2007 13:21:31 -0700
> > 
> > > I propose that we take out all the whole netpoll rx path. If/when
> > > kgdb gets submitted a better and alternative receive path can be
> > > added.
> > 
> > I would like to kill the RX side handling of netpoll too,
> > but I don't think that's reasonable as kgdb is actively
> > being pushed for 2.6.25 inclusion.
> > 
> > Andrew is likely to add it to his -mm tree soon and therefore kgdb
> > will need to work properly now.
> 
> git-kgdb.patch has been in there for ages - maybe a year.  Although I
> disabled it a week or so ago due to the sheer number of rejects.  Will
> bring it back when things settle down a bit.
> 
> > The RX netpoll thing has a long precedence, it's been in the tree for
> > a long time, so we are in some ways stuck with it until we have a
> > complete replacement facility.  That means we can't yank it out first
> > and implement the replacement later.

How about I work on a better/alternative receive path for kgdb that
can be applied after kgdb is included.  Kgdb could actually be useful
for me :-)

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
