Return-Path: <linux-kernel-owner+w=401wt.eu-S940725AbXGSSE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940725AbXGSSE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765652AbXGSSEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:04:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:48032 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbXGSSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:04:42 -0400
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707192000.13164.ak@suse.de>
References: <200707191154.642492000@suse.de> <200707191938.18988.ak@suse.de>
	 <1184867029.6458.40.camel@dhcp193.mvista.com>
	 <200707192000.13164.ak@suse.de>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 11:00:01 -0700
Message-Id: <1184868002.6458.43.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 20:00 +0200, Andi Kleen wrote:
> On Thursday 19 July 2007 19:43:49 Daniel Walker wrote:
> > On Thu, 2007-07-19 at 19:38 +0200, Andi Kleen wrote:
> > > On Thursday 19 July 2007 19:31:56 Daniel Walker wrote:
> > > 
> > > > >From my perspective a downside to sched_clock is that the math is
> > > > duplicated per architecture .. I think it would be a win to use the
> > > > generic functions if it's possible..
> > > 
> > > They can't be used because they're not cpu local. The whole basic 
> > > concept behind the new sched_clock is to be cpu local. 
> > 
> > Your not following me .. 
> 
> Because you don't make much sense. You're really asking me to factor
> an single multiplication and a shift (two CPU instructions!) out to share?

Yes, but I also said that was only part of the duplication. Your already
doing a re-write, there is no reason not to add this..

Daniel

