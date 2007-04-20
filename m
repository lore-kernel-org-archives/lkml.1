Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbXDTDLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbXDTDLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 23:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbXDTDLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 23:11:43 -0400
Received: from mail.suse.de ([195.135.220.2]:42515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbXDTDLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 23:11:42 -0400
Date: Fri, 20 Apr 2007 05:11:41 +0200
From: Nick Piggin <npiggin@suse.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rr_interval experiments
Message-ID: <20070420031140.GA8633@wotan.suse.de>
References: <200704200101.49823.kernel@kolivas.org> <200704201047.57539.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704201047.57539.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:47:57AM +1000, Con Kolivas wrote:
> On Friday 20 April 2007 01:01, Con Kolivas wrote:
> > This then allows the maximum rr_interval to be as large as 5000
> > milliseconds.
> 
> Just for fun, on a core2duo make allnoconfig make -j8 here are the build time 
> differences (on a 1000HZ config) machine:
> 
> 16ms:
> 53.68user 4.81system 0:34.27elapsed 170%CPU (0avgtext+0avgdata 0maxresident)k
> 
> 1ms:
> 56.73user 4.83system 0:36.03elapsed 170%CPU (0avgtext+0avgdata 0maxresident)k
> 
> 5000ms:
> 52.88user 4.77system 0:32.37elapsed 178%CPU (0avgtext+0avgdata 0maxresident)k
> 
> For the record, 16ms is what SD v0.43 would choose as the default value on 
> this hardware. A load with a much lower natural context switching rate than a 
> kernel compile, as you said Nick, would show even greater discrepancy in 
> these results.
> 
> Fun eh? Note these are not for any comparison with anything else; just to show 
> the effect rr_interval changes have on throughput.

Yeah very interesting, thanks. I was sure that a more modern CPU and/or
one with more cache (in this case, both!) would show bigger differences
even on kbuild.

In this case, 16ms -> infinite results in almost 6% performance
improvement.

