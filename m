Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbZFYMBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbZFYMBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZFYMBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:01:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:34549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZFYMBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:01:33 -0400
Subject: Re: [PATCH -tip] perf_counter x86: fix cache_event_ids table
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245871145.3038.5.camel@localhost.localdomain>
References: <1245869758.3038.1.camel@localhost.localdomain>
	 <1245870469.3038.3.camel@localhost.localdomain>
	 <1245871145.3038.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 17:31:00 +0530
Message-Id: <1245931260.5308.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Thu, 2009-06-25 at 00:49 +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-06-25 at 00:37 +0530, Jaswinder Singh Rajput wrote:
> > On Thu, 2009-06-25 at 00:25 +0530, Jaswinder Singh Rajput wrote:
> > > Fixed followings in cache_event_ids table without changing any
> > logic:
> > > 1. made it easier (3 dimension to 1 dimension array)
> > > 2. made more space for comments
> > > 3. decrease number of lines
> > > 4. fixed style problems
> > > 5. fixed 80 characters issues
> > > 
> > > Style problems in arch/x86/kernel/cpu/perf_counter.c :
> > > 
> > > Before :
> > >   total: 492 errors, 32 warnings, 1713 lines checked
> > > After :
> > >   total: 0 errors, 10 warnings, 1537 lines checked
> > > 
> > > Fixed : 492 errors, 22 warnings and Reduced 176 lines.
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > 
> > Fixed some more issues:
> > 
> > [PATCH] perf_counter x86: fix cache_event_ids table
> 
> Fixed some more issues, and I am tired now going to bed :
> 
> [PATCH] perf_counter x86: fix cache_event_ids table
> 
> Fixed followings in cache_event_ids table without changing any logic:
> 1. made it easier (3 dimension to 1 dimension array)
> 2. make more space for comments
> 3. decrease number of lines
> 4. fixed style problems
> 5. fixed 80 characters issues
> 
> Style problems in arch/x86/kernel/cpu/perf_counter.c :
> 
> Before :
>   total: 492 errors, 32 warnings, 1713 lines checked
> After :
>   total: 0 errors, 10 warnings, 1537 lines checked
> 
> Fixed : 492 errors, 22 warnings and Reduced 176 lines.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |  530 ++++++++++++------------------------
>  1 files changed, 177 insertions(+), 353 deletions(-)
> 

I have tested this patch on AMD. Can you test it for Intel.

Thanks,
--
JSR


