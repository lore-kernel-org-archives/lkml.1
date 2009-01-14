Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbZANPKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbZANPKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZANPKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:10:36 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:62576 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZANPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:10:36 -0500
Date: Wed, 14 Jan 2009 16:10:24 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ravikiran G Thirumalai <kiran@scalex86.org>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090114151024.GH10720@gambetta>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu> <1231848016.442.112.camel@twins> <20090114090811.GQ23848@one.firstfloor.org> <20090114144115.GF10720@gambetta> <20090114152001.GS23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114152001.GS23848@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:20:01PM +0100, Andi Kleen wrote:
> > To be fair, it also depends on whenever HOTPLUG_CPU is on or not (if it
> > is we allocate NR_CPUS percpu sections).
> 
> not true to my knowledge. Even a !HOTPLUG_CPU kernel doesn't
> allocate more than what is in the possible map. That would be dumb 
> if it was true, but it isn't fortunately.
My point is that possible map == NR_CPUS if HOTPLUG_CPU
> 
> I don't think it does.
>  In that case, which is Ubuntu's
> > and Fedora's, 
> 
> You're saying that Ubuntu and Fedora do not support suspend to ram?
> (suspend to ram requires CPU hotplug). At least my Fedora box
> does S3 just fine so that cannot be correct.
> 
> we do save memory.
> > This would make for a fairly long changelog, how about a link to this
> > thread, and removing the NR_CPUS bit?
> 
> My original paragraph is correct and it's not long. At least your
> claim is just wrong.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
