Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXGGAJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXGGAJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 20:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXGGAJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 20:09:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53128 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752692AbXGGAJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 20:09:39 -0400
Date: Sat, 7 Jul 2007 02:10:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707001008.GV3492@stusta.de>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706233827.GC13125@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070706233827.GC13125@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 07:38:27PM -0400, Dave Jones wrote:
> On Sat, Jul 07, 2007 at 01:28:43AM +0200, Adrian Bunk wrote:
> 
>  > Only if you want to squeeze the last bit of performance out of
>  > _debugging_ functionality.
>  > 
>  > You avoid all the pain if you simply don't use debugging functionality 
>  > on production systems.
> 
> I think you're mixing up profiling and debugging.   The former is
> extremely valuable under production systems.

profiling = debugging of performance problems

My words were perhaps a bit sloppy, but profiling isn't part of normal 
operation and if people use a separate kernel for such purposes we don't 
need infrastructure for reducing performance penalties of enabled debug 
options.

> 	Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

