Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbYAIVSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbYAIVSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYAIVSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:18:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48197 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbYAIVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:18:31 -0500
Date: Wed, 9 Jan 2008 22:21:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, ananth@in.ibm.com,
       akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, mhiramat@redhat.com, davem@davemloft.net,
       hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080109212103.GB15612@one.firstfloor.org>
References: <20080108063334.GA29385@in.ibm.com> <p73zlvgowwn.fsf@bingen.suse.de> <1199833842.3914.33.camel@dyn9047018096.beaverton.ibm.com> <20080108232841.GD2117@one.firstfloor.org> <1199910240.4162.31.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199910240.4162.31.camel@dyn9047018096.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 12:24:00PM -0800, Jim Keniston wrote:
> On Wed, 2008-01-09 at 00:28 +0100, Andi Kleen wrote:
> > > I have no problem with that, but if we want to make it buildable as a
> > > module, the call to get_kprobe() needs to be replaced with some other
> > > gcc-inline-defeating mechanism, or we need to export get_probe().  I
> > 
> > It's still unclear where noinline does not work (do you have details on that? 
> > It sounds a little dubious) ...
> 
> Here's a simplified version of a module we've used to gauge kprobes
> performance.  On my system (i386, 2.6.23-rc8 at the moment, gcc version
> 4.1.2), the module calls the (empty) probed function (probeme) niter
> times, but reports zero probe hits -- indicating probeme was inlined
> even though it was declared noinline.

Yes indeed looks like a gcc bug. Have you reported it?

-Andi
