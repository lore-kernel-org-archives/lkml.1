Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZGCKMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZGCKMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZGCKLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:11:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:57784 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbZGCKLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:11:52 -0400
Subject: Re: [PATCH 1/2 -tip] perf_counter: Add generalized hardware
 vectored co-processor support for AMD and Intel Corei7/Nehalem
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703093032.GI3902@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
	 <20090701114928.GI15958@elte.hu> <1246527872.13659.2.camel@hpdv5.satnam>
	 <1246606736.2322.9.camel@jaswinder.satnam>  <20090703093032.GI3902@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 15:40:45 +0530
Message-Id: <1246615845.2322.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 11:30 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > > $ ./perf list shows vector events like :
> > > 
> > >   vec-adds OR add                          [Hardware vector event]
> > >   vec-muls OR multiply                     [Hardware vector event]
> > >   vec-divs OR divide                       [Hardware vector event]
> > >   vec-idle-cycles OR vec-empty-cycles      [Hardware vector event]
> > >   vec-stall-cycles OR vec-busy-cycles      [Hardware vector event]
> > >   vec-ops OR vec-operations                [Hardware vector event]
> 
> btw., why does this printout SHOUT the 'or'? It's certainly not an 
> important piece of information. Something like:
> 
>    vec-adds | add                          [Hardware vector event]
>    vec-muls | multiply                     [Hardware vector event]
>    vec-divs | divide                       [Hardware vector event]
>    vec-idle-cycles | vec-empty-cycles      [Hardware vector event]
>    vec-stall-cycles | vec-busy-cycles      [Hardware vector event]
>    vec-ops | vec-operations                [Hardware vector event]
> 
> looks better on all levels.
> 

'OR' is also used for other events.
If this is the only issue, I request you to accept these 2 patches.

I will send incremental patch which will fix these 'OR's and also avoid
duplicating of these functions.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/


