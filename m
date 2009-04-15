Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbZDOFfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbZDOFfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZDOFfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:35:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:39339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbZDOFfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:35:04 -0400
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
 inappropriate or CPU is not supported
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090414191622.GA797@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam>
	 <20090414165052.GA2089@elte.hu> <1239728481.2966.21.camel@ht.satnam>
	 <20090414184222.GC11214@elte.hu>
	 <20090414200247.1d0a8667@lxorguk.ukuu.org.uk>
	 <20090414191622.GA797@elte.hu>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 11:04:25 +0530
Message-Id: <1239773665.15436.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 21:16 +0200, Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > > Do you still think that boot_cpu_data.x86_vendor is better option in
> > > > case for multiple CPUs.
> > > 
> > > yes. Assymetric SMP never really happened on x86.
> > 
> > It did but not between vendors. You can get away with a vendor 
> > assumption but cpu type (mixed 486SX/DX, PII/PIII/Celeron) mixed 
> > steppings and mixed speeds do occur. We've never supported the 
> > mixed 486SX cases but the PII/PIII cases work (or at least 
> > worked).
> 
> yeah - but look at the specific purpose here: we are deciding 
> whether to print out state information related to major CPU 
> features. Mixed steppings/speeds might happen, mixed apic / 
> non-lapic not really.
> 

We are trying to debug each CPU, so we should also collect information
from each CPU.

Just reading information from boot CPU and display information for all
CPU is not correct. If we are getting information from boot CPU then we
only need to show information for boot CPU and ignore others.

I am trying to adding more features which will be unique for each
CPU/core.

So it seems current model is correct where I am collecting information
for each CPU and printing information for each CPU.

Thanks,

--
JSR

