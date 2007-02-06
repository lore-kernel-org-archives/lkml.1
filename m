Return-Path: <linux-kernel-owner+w=401wt.eu-S1751059AbXBFHdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbXBFHdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXBFHdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:33:13 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:32452 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751059AbXBFHdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:33:13 -0500
Subject: Re: One-shot high-resolution POSIX timer periodically late
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: John <shill@free.fr>
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com, mingo@elte.hu,
       johnstul@us.ibm.com, akpm@osdl.org
In-Reply-To: <45C75D2D.9010506@free.fr>
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no>
	 <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no>
	 <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no>
	 <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no>
	 <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no>
	 <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>  <45C75D2D.9010506@free.fr>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 08:31:21 +0100
Message-Id: <1170747081.4672.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 17:37 +0100, John wrote:
> Ingo Molnar wrote:
> 
> > John wrote:
> > 
> >> John Stultz wrote:
> >> 
> >>> Also do check the -rt tree as Ingo suggested. I mis-read your earlier
> >>> email and thought you were running it.
> >> 
> >> I've been pulling my hair over a related issue for the past two days.
> >> 
> >> (I think I may be tickling a -hrt bug...)
> >> 
> >> I'm working with 2.6.18.6 + patch-2.6.18-rt7
> > 
> > 2.6.18-rt7 is pretty old, do you see the problem in 2.6.20-rc6-rt5 too?
> 
> Ingo, Thomas,
> 
> As far as I can tell, the -rt patch set is only updated for the latest 
> kernel version available. Is that correct?
> 
> http://people.redhat.com/mingo/realtime-preempt/older/?M=D
> 
> In other words, once 2.6.20 is released, and work starts on 2.6.21, if a 
> bug is discovered in -rt, the fix will not be back-ported to the 
> 2.6.20.x (and 2.6.19.x, and 2.6.18.x, etc) patch set?

Correct, there is only 1 live branch.

