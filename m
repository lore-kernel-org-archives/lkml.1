Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYAWPyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYAWPyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYAWPyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:54:32 -0500
Received: from waste.org ([66.93.16.53]:34886 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYAWPyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:54:32 -0500
Subject: Re: Rescheduling interrupts
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?Q?S=2E=C3=87a=C4=9Flar?= Onur <caglar@pardus.org.tr>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <p73fxwoncs4.fsf@crumb.suse.de>
References: <200801220119.42312.caglar@pardus.org.tr>
	 <200801221455.16814.caglar@pardus.org.tr> <20080122152333.GB19590@elte.hu>
	 <200801221755.56470.caglar@pardus.org.tr> <20080122160557.GA31831@elte.hu>
	 <1201021429.14436.45.camel@cinder.waste.org>
	 <20080122192744.GB3218@elte.hu>  <p73fxwoncs4.fsf@crumb.suse.de>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 09:52:36 -0600
Message-Id: <1201103556.14436.109.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 09:53 +0100, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > that would probably be the case if it's multiple sockets - but for 
> > multiple cores exactly the opposite is true: the sooner _both_ cores 
> > finish processing, the deeper power use the CPU can reach. 
> 
> That's only true on setups where the cores don't have 
> separate sleep states. But that's not generally true anymore.
> e.g. AMD Fam10h has completely separate power planes for
> the cores and I believe newer Intel CPUs can also let their 
> cores go to at least some sleep states independently (although
> the deepest sleep modi still require all cores idle) 

I think we can expect everyone to rapidly evolve towards full
independence of core power states. In fact, it wouldn't surprise me if
we eventually get to the point of shutting down individual functional
units like the FPU.

-- 
Mathematics is the supreme nostalgia of our time.

