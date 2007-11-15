Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbXKORWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbXKORWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXKORWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:22:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:14148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbXKORWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:22:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,421,1188802800"; 
   d="scan'208";a="205426731"
Date: Thu, 15 Nov 2007 09:22:21 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071115172221.GA24837@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <473A678C.2020507@googlemail.com> <473A76FA.4050701@googlemail.com> <20071114202959.GA21049@linux.intel.com> <20071114124008.095f307d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114124008.095f307d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:40:08PM -0800, Andrew Morton wrote:
> On Wed, 14 Nov 2007 12:29:59 -0800 mark gross <mgross@linux.intel.com> wrote:
> 
> > > > [  102.366932]  =======================
> > > > [  108.552031] printk: 31 messages suppressed.
> > > 
> > > 
> > > All this BUG / WARNINGS are caused by *-qos* patches. Reverting this 3 patches makes the BUGs go away :
> > > 
> > > latencyc-use-qos-infrastructure.patch
> > > pm-qos-infrastructure-and-interface.patch
> > > pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
> > > 
> > > 
> > > Gabriel
> > > 
> > > 
> > This looks like the same issue Rafael saw.
> > 
> > Try the patch in the following post:
> > 
> > http://marc.info/?l=linux-kernel&m=119265627228498&w=2
> > 
> 
> Well that's not very good.  _I_ can go fishing in my lkml archives for random
> patches but not everyone is set up to do that.  And the diff to which you
> refer gets 100% rejects against rc2-mm1 anyway.
> 
> Please prepare a tested, changelogged patch against rc2-mm1 asap.  

I'm sorry for not being clear, this patch is already in your tree from a
few weeks ago.  I was pointing Gabriel at the fix from back then.

--mgross
