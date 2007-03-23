Return-Path: <linux-kernel-owner+w=401wt.eu-S1422790AbXCWLCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422790AbXCWLCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXCWLCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:02:44 -0400
Received: from holomorphy.com ([66.93.40.71]:39770 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422790AbXCWLCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:02:43 -0400
Date: Fri, 23 Mar 2007 04:02:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070323110224.GP2986@holomorphy.com>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu> <20070323103243.GE11577@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323103243.GE11577@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 11:04:18AM +0100, Ingo Molnar wrote:
>> isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
>> but it might be a worry for the rest of the world ;-)

On Fri, Mar 23, 2007 at 11:32:44AM +0100, Nick Piggin wrote:
> Hmm, it looks like they have implemented a system where the spinning
> cpu sleeps on a per-CPU variable rather than the lock itself, and
> the releasing cpu writes to that variable to wake it.  They do this
> so that spinners don't continually perform exclusive->shared
> transitions on the lock cacheline. They call these things queued
> spinlocks.  They don't seem to be very patent worthy either, but
> maybe it is what you're thinking of?

Those exclusive-to-shared transitions are among the cacheline transfers
typically accounted to the algorithms in their complexity analyses.


-- wli
