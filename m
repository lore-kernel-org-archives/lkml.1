Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbXIYQTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbXIYQTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXIYQTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:19:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbXIYQTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:19:05 -0400
Date: Tue, 25 Sep 2007 09:18:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac: Driver model & phylib update
Message-Id: <20070925091824.ffbd0386.akpm@linux-foundation.org>
In-Reply-To: <20070925131817.GA28402@linux-mips.org>
References: <Pine.LNX.4.64N.0709191811040.24627@blysk.ds.pg.gda.pl>
	<20070921124409.7f3d122b.akpm@linux-foundation.org>
	<20070925131817.GA28402@linux-mips.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 14:18:17 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:

> On Fri, Sep 21, 2007 at 12:44:09PM -0700, Andrew Morton wrote:
> 
> > >  A driver model and phylib update.
> > 
> > akpm:/usr/src/25> diffstat patches/git-net.patch | tail -n 1
> >  1013 files changed, 187667 insertions(+), 23587 deletions(-)
> > 
> > Sorry, but raising networking patches against Linus's crufty
> > old mainline tree just isn't viable at present.
> 
> Out of curiosity:
> 
> [ralf@denk linux-queue]$ git diff $(git merge-base master v2.6.23-rc8-mm1)..v2.6.23-rc8-mm1 | wc -cl
> 1046669 31900996
> [ralf@denk linux-queue]$ git diff $(git merge-base master v2.6.23-rc8-mm1)..v2.6.23-rc8-mm1 | diffstat | tail -1
>  6049 files changed, 573635 insertions(+), 207630 deletions(-)

A few years ago I thought it might slow down soon.

> [ralf@denk linux-queue]$ 
> 
> We're all a little too productive ;-)

s/prod/destr/
