Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbYFSRKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbYFSRKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYFSRKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:10:10 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:51843 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYFSRKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:10:09 -0400
Date: Thu, 19 Jun 2008 12:09:45 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/PATCH 0/3] sched: allow arch override of cpu power
Message-ID: <20080619170945.GB9594@localdomain>
References: <1213835374-10868-1-git-send-email-ntl@pobox.com>
 <20080619095048.GD15228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619095048.GD15228@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 8DF35756-3E22-11DD-A15B-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Nathan Lynch <ntl@pobox.com> wrote:
> > So it would be nice to have the scheduler slightly prefer primary 
> > threads on POWER6 machines.  These patches, which allow the 
> > architecture to override the scheduler's CPU "power" calculation, are 
> > one possible approach, but I'm open to others.  Please note: these 
> > seemed to have the desired effect on 2.6.25-rc kernels (2-3% 
> > improvement in a kernbench-like make -j <nr_cores>), but I'm not 
> > seeing this improvement with 2.6.26-rc kernels for some reason I am 
> > still trying to track down.
> 
> ok, i guess that discrepancy has to be tracked down before we can think 
> about these patches - but the principle is OK.

Great.  I'll keep trying to figure out what's going on there.


> One problem is that the whole cpu-power balancing code in sched.c is a 
> bit ... unclear and under-documented. So any change to this area should 
> begin at documenting the basics: what do the units mean exactly, how are 
> they used in balancing and what is the desired effect.
>
> I'd not be surprised if there were a few buglets in this area, SMT is 
> not at the forefront of testing at the moment. There's nothing 
> spectacularly broken in it (i have a HT machine myself), but the 
> concepts have bitrotten a bit. Patches - even if they just add comments 
> - are welcome :-)

Okay, I'll have a look.  Thanks Ingo.
