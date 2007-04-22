Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXDVHD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXDVHD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbXDVHD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:03:26 -0400
Received: from holomorphy.com ([66.93.40.71]:56924 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXDVHDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:03:25 -0400
Date: Sun, 22 Apr 2007 00:02:38 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070422070238.GH2986@holomorphy.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu> <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org> <20070421164241.GF2986@holomorphy.com> <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com> <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com> <alpine.LFD.0.98.0704211634130.9964@woody.linux-foundation.org> <a36005b50704211846g4ed1256fpad6a3a5670318314@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50704211846g4ed1256fpad6a3a5670318314@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> And how the hell do you imagine you'd even *know* what thread holds the
>> futex?

On Sat, Apr 21, 2007 at 06:46:58PM -0700, Ulrich Drepper wrote:
> We know this in most cases.  This is information recorded, for
> instance, in the mutex data structure.  You might have missed my "the
> interface must be extended" part.  This means the PID of the owning
> thread will have to be passed done.  For PI mutexes this is not
> necessary since the kernel already has access to the information.

I'm just looking for what people want the API to be here. With that in
hand we can just go out and do whatever needs to be done.


-- wli
