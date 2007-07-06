Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbXGFX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbXGFX2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 19:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXGFX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 19:28:15 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53109 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751904AbXGFX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 19:28:14 -0400
Date: Sat, 7 Jul 2007 01:28:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070706232843.GT3492@stusta.de>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <468EBEB2.4070605@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 06:14:10PM -0400, Chuck Ebbert wrote:
> On 07/06/2007 07:44 AM, Andi Kleen wrote:
> > I think the optimization is a good idea, although i dislike it
> > that it is complicated for the dynamic markers. If it was just
> > static it would be much simpler.
> 
> Another thing to consider is that there might be hundreds of these
> probes/tracepoints active in an instrumented kernel. The overhead
> adds up fast, so the gain may be worth all the pain.

Only if you want to squeeze the last bit of performance out of
_debugging_ functionality.

You avoid all the pain if you simply don't use debugging functionality 
on production systems.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

