Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXDQNs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXDQNs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXDQNs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:48:28 -0400
Received: from omta02sl.mx.bigpond.com ([144.140.93.154]:34490 "EHLO
	omta02sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXDQNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:48:27 -0400
Message-ID: <4624D027.4040500@bigpond.net.au>
Date: Tue, 17 Apr 2007 23:48:23 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070416110439.GH2986@holomorphy.com> <46237239.1070903@bigpond.net.au> <20070416135915.GK8915@holomorphy.com> <46241677.7060909@bigpond.net.au> <20070417025704.GM8915@holomorphy.com> <462445EC.1060306@bigpond.net.au> <20070417053147.GN8915@holomorphy.com> <46246A7C.8050501@bigpond.net.au> <20070417064109.GP8915@holomorphy.com> <46247E86.5090706@bigpond.net.au> <20070417104141.GV8915@holomorphy.com>
In-Reply-To: <20070417104141.GV8915@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 13:48:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
>>> Comments on which directions you'd like this to go in these respects
>>> would be appreciated, as I regard you as the current "project owner."
> 
> On Tue, Apr 17, 2007 at 06:00:06PM +1000, Peter Williams wrote:
>> I'd do scan through LKML from about 18 months ago looking for mention of 
>> runtime configurable version of plugsched.  Some students at a 
>> university (in Germany, I think) posted some patches adding this feature 
>> to plugsched around about then.
> 
> Excellent. I'll go hunting for that.
> 
> 
> On Tue, Apr 17, 2007 at 06:00:06PM +1000, Peter Williams wrote:
>> I never added them to plugsched proper as I knew (from previous 
>> experience when the company I worked for posted patches with similar 
>> functionality) that Linux would like this idea less than he did the 
>> current plugsched mechanism.
> 
> Odd how the requirements ended up including that. Fickleness abounds.
> If only we knew up-front what the end would be.
> 
> 
> On Tue, Apr 17, 2007 at 06:00:06PM +1000, Peter Williams wrote:
>> Unfortunately, my own cache of the relevant e-mails got overwritten 
>> during a Fedora Core upgrade (I've since moved /var onto a separate 
>> drive to avoid a repetition) or I would dig them out and send them to 
>> you.  I'd provided with copies of the company's patches to use as a 
>> guide to how to overcome the problems associated with changing 
>> schedulers on a running system (a few non trivial locking issues pop up).
>> Maybe if one of the students still reads LKML he will provide a pointer.
> 
> I was tempted to restart from scratch given Ingo's comments, but I
> reconsidered and I'll be working with your code (and the German
> students' as well). If everything has to change, so be it, but it'll
> still be a derived work. It would be ignoring precedent and failure to
> properly attribute if I did otherwise.

I can give you a patch (or set of patches) against the latest git 
vanilla kernel version if that would help.  There have been changes to 
the vanilla scheduler code since 2.6.20 so the latest patch on 
sourceforge won't apply cleanly.  I've found that implementing this as a 
series of patches rather than one big patch makes it easier fro me to 
cope with changes to the underlying code.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
