Return-Path: <linux-kernel-owner+w=401wt.eu-S936102AbYEBUEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936102AbYEBUEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYEBUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:04:16 -0400
Received: from [194.117.236.238] ([194.117.236.238]:58202 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbYEBUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:04:15 -0400
Date: Fri, 2 May 2008 23:01:41 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Andi Kleen" <andi@firstfloor.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>, "Tim Bird" <tim.bird@am.sony.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Message-ID: <20080502230141.1788f525@linux360.ro>
In-Reply-To: <84144f020805020800w765c5248r6dba93240230b983@mail.gmail.com>
References: <1209577322.25560.402.camel@pmac.infradead.org>
	<87bq3rgq40.fsf@basil.nowhere.org>
	<48190B5F.9010505@am.sony.com>
	<20080501095822.GL20451@one.firstfloor.org>
	<1209636171.25560.508.camel@pmac.infradead.org>
	<20080501104158.GM20451@one.firstfloor.org>
	<84144f020805020800w765c5248r6dba93240230b983@mail.gmail.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm the student working on this. I have already implemented tracing for
SLAB, SLUB and SLOB, and patched relayfs to work early on (just after
kmem_cache_init() runs). Currently, I'm working on the userspace tool,
so much of the coding is largely finished.

I wanted to submit the relay stuff, but couldn't contact its maintainer.

If anyone wants to take a look, I could set up a git repo somewhere
(which has to be done anyway, at some point).


	Cheers,
	Eduard

On Fri, 2 May 2008 18:00:43 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi Andi,
> 
> On Thu, May 1, 2008 at 1:41 PM, Andi Kleen <andi@firstfloor.org>
> wrote:
> > > To a large extent, I agree. I certainly don't want to focus
> > > solely on code size; there's a lot more to embedded Linux than
> > > that. But it _is_
> >
> >  Not only code size, far more important is dynamic memory
> > consumption. [admittedly we right now lack a good instrumentation
> > framework for this]
> 
> There's a Google Summer of Code project going on now to implement such
> instrumentation:
> 
> http://code.google.com/soc/2008/linux/appinfo.html?csaid=E749E676AD70FBB0
> 
> So any suggestions/input on this is obviously welcome.
