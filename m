Return-Path: <linux-kernel-owner+w=401wt.eu-S935418AbYDQKBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935418AbYDQKBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934214AbYDQJgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:36:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934563AbYDQJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:36:52 -0400
Date: Thu, 17 Apr 2008 02:36:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417023603.672d1032.akpm@linux-foundation.org>
In-Reply-To: <20080417093025.GA17389@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 11:30:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > By keeping all this code out of -mm you haven't solved any of the 
> > > > merge/integration problems which we had in 2.6.24-rcX.  They're 
> > > > all still there.  All you did was to push them out of the 
> > > > two-month integrate-and-test period and put them into the 2.6.25 
> > > > merge window instead.
> > > 
> > > ... hm, i think there's really no problem here at all: most of the 
> > > merge problems you cited were due to clearly out-of-tree patches 
> > > that sit in x86.git/testing for the convenience of our testers and 
> > > contributors, that we have no intention to push upstream.
> > 
> > Are those out-of-tree patches also in linux-next? [...]
> 
> yes they are.
> 
> > [...]  The page-flags and prctl changes are there.  And those are 
> > planned for 2.6.26, aren't they?
> 
> you mean kmemcheck? Yes, that's planned. We've been working 4 months 
> non-stop on kmemcheck to make it mergeable and usable, it's at version 7 
> right now, and it caught a handful of real bugs already (such as 
> 63a7138671c - unfortunately not credited in the log to kmemcheck). But 
> because it touches SLUB (because it has to - and they are acked by 
> Pekka) i never had the chance to move it into the for-akpm branch.

Does it really really really need to consume one of our few remaining page
flags?  We'll be in a mess when we run out.

> i guess this will all sort itself out when you rebase -mm to linux-next. 
> Stephen Rothwell is doing an excellent job of resolving interactions 
> between trees.

Yep I expect it'll help in several ways.  (That's why I suggested it!)
