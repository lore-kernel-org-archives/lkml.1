Return-Path: <linux-kernel-owner+w=401wt.eu-S934844AbYEBNVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbYEBNVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758584AbYEBNV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:21:26 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:36869 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbYEBNVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:21:25 -0400
Date: Fri, 2 May 2008 18:51:17 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Horrendous Audio Stutter - current git
Message-ID: <20080502132117.GA4912@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <200805021337.10809.elendil@planet.nl> <1209728372.13978.147.camel@twins> <200805021406.55038.elendil@planet.nl> <82e4877d0805020522o278ab3f5i21fc820084f85b97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0805020522o278ab3f5i21fc820084f85b97@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 08:22:04AM -0400, Parag Warudkar wrote:
> On Fri, May 2, 2008 at 8:06 AM, Frans Pop <elendil@planet.nl> wrote:
> >  Note (mostly for Parag) that I had GROUP_SCHED disabled for these tests, but
> >  for me that did make not any difference with my 2.6.25-rc tests for this
> >  issue, nor with my tests using sched-devel earlier in the .26 merge window.
> >
> 
> Strange - without the _enqueue patch from Peter, stutter is reduced to
> an almost acceptable level for me if I just disable GROUP_SCHED.
> With Peter's patch - I have tested multiple times and the stutter is
> completely eliminated. So +1 for Peter's patch.
> 

Not really, we can do better. I still see stutters and noticable delays
in keypresses making it to the console even with Peter's patches.

/me tries to fix this one :-/

Peter, any more patches to try out?

thanks,
-- 
regards,
Dhaval
