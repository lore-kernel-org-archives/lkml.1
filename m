Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbXDQIAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbXDQIAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXDQIAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:00:16 -0400
Received: from omta02ps.mx.bigpond.com ([144.140.83.154]:42465 "EHLO
	omta02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXDQIAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:00:15 -0400
Message-ID: <46247E86.5090706@bigpond.net.au>
Date: Tue, 17 Apr 2007 18:00:06 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070416030405.GI8915@holomorphy.com> <4623050B.8020602@bigpond.net.au> <20070416110439.GH2986@holomorphy.com> <46237239.1070903@bigpond.net.au> <20070416135915.GK8915@holomorphy.com> <46241677.7060909@bigpond.net.au> <20070417025704.GM8915@holomorphy.com> <462445EC.1060306@bigpond.net.au> <20070417053147.GN8915@holomorphy.com> <46246A7C.8050501@bigpond.net.au> <20070417064109.GP8915@holomorphy.com>
In-Reply-To: <20070417064109.GP8915@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 08:00:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Tue, Apr 17, 2007 at 04:34:36PM +1000, Peter Williams wrote:
>> This doesn't make any sense to me.
>> For a start, exact simultaneous operation would be impossible to achieve 
>> except with highly specialized architecture such as the long departed 
>> transputer.  And secondly, I can't see why it's necessary.
> 
> We're not going to make any headway here, so we might as well drop the
> thread.

Yes, we were starting to go around in circles weren't we?

> 
> There are other things to talk about anyway, for instance I'm seeing
> interest in plugsched come about from elsewhere and am taking an
> interest in getting it into shape wrt. various design goals therefore.
> 
> Probably the largest issue of note is getting scheduler drivers
> loadable as kernel modules. Addressing the points Ingo made that can
> be addressed are also lined up for this effort.
> 
> Comments on which directions you'd like this to go in these respects
> would be appreciated, as I regard you as the current "project owner."

I'd do scan through LKML from about 18 months ago looking for mention of 
runtime configurable version of plugsched.  Some students at a 
university (in Germany, I think) posted some patches adding this feature 
to plugsched around about then.

I never added them to plugsched proper as I knew (from previous 
experience when the company I worked for posted patches with similar 
functionality) that Linux would like this idea less than he did the 
current plugsched mechanism.

Unfortunately, my own cache of the relevant e-mails got overwritten 
during a Fedora Core upgrade (I've since moved /var onto a separate 
drive to avoid a repetition) or I would dig them out and send them to 
you.  I'd provided with copies of the company's patches to use as a 
guide to how to overcome the problems associated with changing 
schedulers on a running system (a few non trivial locking issues pop up).

Maybe if one of the students still reads LKML he will provide a pointer.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
