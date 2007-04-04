Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbXDDVjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbXDDVjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXDDVjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:39:22 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57192 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbXDDVjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:39:21 -0400
Date: Wed, 4 Apr 2007 14:32:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@muc.de>
Subject: Re: [PATCH -mm] fix jiffies clocksource inittime
Message-Id: <20070404143233.b97eed8f.akpm@linux-foundation.org>
In-Reply-To: <20070404212324.GA19899@elte.hu>
References: <1175716216.17711.59.camel@localhost>
	<20070404134310.12ad3ab8.akpm@linux-foundation.org>
	<20070404212324.GA19899@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 23:23:24 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > If so: worrisome.  Startup ordering issues are fragile and tricky.  
> > Time management is fragile and tricky.  The combination of the two 
> > doesn't get any better ;)
> > 
> > An option would be to test it in 2.6.22-rcX for a while, then backport 
> > to 2.6.21.x.
> 
> is the v2.6.21 release so close?

It's the closest it's ever been!

> From all i can see Adrian Bunk still 
> has a very sizable regressions list, which necessiate a couple of weeks 
> to track down. And the delta since -rc5 is pretty large too, 
> necessiating an -rc6.
> 

yeah, I wouldn't be surprised to see an rc7.
