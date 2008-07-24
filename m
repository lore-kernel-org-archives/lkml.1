Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYGXMWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYGXMWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYGXMW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:22:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYGXMW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:22:27 -0400
Subject: Re: 22bb1be4d27... breaks hal (and NM)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080724051113.fa14f7ec.akpm@linux-foundation.org>
References: <20080724115805.5466c217@mjolnir.drzeus.cx>
	 <1216899520.13587.49.camel@johannes.berg> <1216900631.7257.321.camel@twins>
	 <20080724051113.fa14f7ec.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 14:22:04 +0200
Message-Id: <1216902124.7257.325.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 05:11 -0700, Andrew Morton wrote:
> On Thu, 24 Jul 2008 13:57:11 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2008-07-24 at 13:38 +0200, Johannes Berg wrote:
> > > On Thu, 2008-07-24 at 11:58 +0200, Pierre Ossman wrote:
> > > > From commit 22bb1be4d27...:
> > > > 
> > > > "The /sys/class/net/*/wireless/ direcory is, as far as I know, not used
> > > > by anyone."
> > > > 
> > > > Can't have been much of an investigation as HAL uses these to determine
> > > > if a card is a wireless one. Without this option, you cannot get
> > > > wireless support in NetworkManager, stranding most laptops.
> > > 
> > > Bzzzzt. You suck. Go check again. Hint: try hal's git tree.
> 
> err,
> 
> a) don't be rude
> 
> b) what's in various git trees is unuseful for making decisions
>    about production kernel features.
> 
> otoh the patch seems reasonable.

> So if you've enabled CONFIG_WIRELESS_EXT_SYSFS (and it correctly has
> default y) then things should continue to work OK.  And the deprecation
> date of 2010 sounds reasonable.  In fact generous, for us...
> 
> So where's the problem?

Your two previous points, a and b.

That help text should really have mentioned current software, not future
software. And the tone of the reply.

