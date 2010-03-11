Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0CKOSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:18:52 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:50323 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab0CKOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:18:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nszdnl6aIN7tnEjzn44wM/rHJ9PxhaPs1iKishM3+k2J1rNp7K77rwfHV7IIusFEKd
         oi6H1G5RWxTttZFzsWGGgXaSsg30JL2BOplRIoMMthkg/hLFm1brWi20TGB2XvB3npg3
         Jfu19N6OT2RpWnFy6zQ5ln89MuIWBitOAUpIY=
Date: Thu, 11 Mar 2010 15:18:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: export perf_trace_regs and
	perf_arch_fetch_caller_regs
Message-ID: <20100311141841.GA4987@nowhere>
References: <4B989C1B.2090407@cn.fujitsu.com> <20100311090248.GA10904@infradead.org> <1268298651.5279.986.camel@twins> <20100311091444.GA19699@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311091444.GA19699@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 04:14:44AM -0500, Christoph Hellwig wrote:
> On Thu, Mar 11, 2010 at 10:10:51AM +0100, Peter Zijlstra wrote:
> > Pretty much all modular tracepoint users I think, I just got this from a
> > pp64_defconfig build:
> 
> Interesting, that doesn't happen in mainline yet.
> 


Yeah, it's in -tip.

Thanks guys for this fix. I think I'm unable to remind
there are modules in the kernel, I'm not counting anymore
the number of times I forget to export symbols for modules.

May be I should start to stick posters with photos of modules
entitled "I want to believe" everywhere in my flat.
Or perhaps I'm going to buy electronic glasses that display
modules advertizing in the street. I'm not sure yet but I'll
find a way.

