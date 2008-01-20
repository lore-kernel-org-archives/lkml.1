Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbYATFio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbYATFio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYATFig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:38:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45139 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYATFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:38:35 -0500
Date: Sun, 20 Jan 2008 06:42:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Celeron Core
Message-ID: <20080120054202.GA19861@one.firstfloor.org>
References: <p73prvyalfl.fsf@bingen.suse.de> <1200702477.25782.41.camel@cinder.waste.org> <20080119011506.GA23798@one.firstfloor.org> <1200715842.25782.95.camel@cinder.waste.org> <20080119042750.GA24481@one.firstfloor.org> <1200717635.25782.107.camel@cinder.waste.org> <20080119045415.GA27628@one.firstfloor.org> <4792CF9A.2030601@davidnewall.com> <20080120051338.GA19784@one.firstfloor.org> <4792DADD.70504@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792DADD.70504@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 03:53:41PM +1030, David Newall wrote:
> Andi Kleen wrote:
> >> Isn't it the case that an idle machine will use
> >> less power when throttled than when not?
> >>     
> >
> > No that is not the case (not even on old CPUs) 
> >   
> Then why would it run cooler?  

Ok for one more (but last) time:

Throttling just lowers the short term heat spikes to prevent
short term damage to the silicon.  For that it focusses on lowering 
the absolute temperature at a given point.  That only applies
when the CPU is busy.

But for total power consumption (or rather more concretly conserving
your battery) you don't care about absolute temperature at a given point
(as long as it is not high enough that it destroys the CPU)
you care about how much power is consumed (and heat generated from that) 
averaged out over a longer time.

And for most typical workloads (not running endless loops; significant
idle time) throttling makes no difference and in fact often (especially
on laptop CPUs with deeper sleep modi like the original reported
had one) makes it likely worse (see previous mails for details why) 

> I'm not convinced.  I'm along way from that.

Frankly that's fine for me. I don't really feel any need to convince you. 
I can live with your metal model of CPU physics not being accurate.

-Andi (feeling a bit like a broken record) 
> 
