Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXGGCZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXGGCZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbXGGCY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:24:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53197 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753991AbXGGCY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:24:56 -0400
Date: Sat, 7 Jul 2007 04:25:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       mbligh@google.com
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707022526.GC3492@stusta.de>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706234315.GA19804@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070706234315.GA19804@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 07:43:15PM -0400, Mathieu Desnoyers wrote:
> * Adrian Bunk (bunk@stusta.de) wrote:
> > On Fri, Jul 06, 2007 at 06:14:10PM -0400, Chuck Ebbert wrote:
> > > On 07/06/2007 07:44 AM, Andi Kleen wrote:
> > > > I think the optimization is a good idea, although i dislike it
> > > > that it is complicated for the dynamic markers. If it was just
> > > > static it would be much simpler.
> > > 
> > > Another thing to consider is that there might be hundreds of these
> > > probes/tracepoints active in an instrumented kernel. The overhead
> > > adds up fast, so the gain may be worth all the pain.
> > 
> > Only if you want to squeeze the last bit of performance out of
> > _debugging_ functionality.
> > 
> > You avoid all the pain if you simply don't use debugging functionality 
> > on production systems.
> > 
> 
> Adrian,
> 
> Please have a look at my markers posts, especially:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0707.0/0669.html
> 
> And also look into OLS 2007 proceedings for Martin Bligh's paper on
> Debugging Google sized clusters. It basically makes the case for adding
> functionnality to debug _user space_ problems on production systems that
> can be turned on dynamically.

Using a different kernel for tracing still fulfills all the requirements 
listed in section 5 of your paper...

> Mathieu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

