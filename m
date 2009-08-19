Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZHSTHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZHSTHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 15:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZHSTHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 15:07:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:45330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZHSTHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 15:07:07 -0400
Subject: Re: [PATCH] Add minimal support for software performance counters
 for ia64
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: William Cohen <wcohen@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4A8C4CAA.5070101@redhat.com>
References: <4A8C2290.3040707@redhat.com> <1250698351.8282.106.camel@twins>
	 <4A8C4CAA.5070101@redhat.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 21:06:59 +0200
Message-Id: <1250708819.7154.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 15:04 -0400, William Cohen wrote:
> Peter Zijlstra wrote:
> > On Wed, 2009-08-19 at 12:04 -0400, William Cohen wrote:
> >> +#ifdef __ia64__
> >> +#include "../../arch/ia64/include/asm/unistd.h"
> >> +#define rmb()          asm volatile("" ::: "memory")
> >> +#define cpu_relax()    asm volatile("" ::: "memory");
> >> +#endif
> > 
> > Surely the itanic has a real memory barrier? The kernel seems to use
> > something along the lines of mf.
> > 
> > Also, cpu_relax() seems to end up being asm volatile("hint @pause" :::
> > "memory"), although we don't seem to have an actual user of cpu_relax()
> > in perf atm.
> > 
> > 
> > 
> 
> Peter, thanks for the comment. I took a look at the rmb() and cpu_relax() code
> in the kernel and revised the patch with the appropriate defines

Looks good now, thanks!

