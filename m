Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYGMPdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYGMPdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYGMPdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:33:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:43501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYGMPdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:33:46 -0400
Date: Sun, 13 Jul 2008 08:33:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Message-ID: <20080713083322.16ebe80c@infradead.org>
In-Reply-To: <874p6t25n5.fsf@basil.nowhere.org>
References: <200807080141.05436.yhlu.kernel@gmail.com>
	<200807080143.27997.yhlu.kernel@gmail.com>
	<200807092015.03004.yhlu.kernel@gmail.com>
	<20080710071640.5035cd70@infradead.org>
	<874p6t25n5.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 16:57:50 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > On Wed, 9 Jul 2008 20:15:02 -0700
> > Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> 
> >> 
> >> fix phys_pmd_init to make sure not to return big value than end.
> >> 
> >> also print out range split:1G/2M/4K
> >> 
> >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> >
> > Making an accurate mapping solves a lot of potentially nasty/tricky
> > corner cases, so I like the approach
> 
> It also means that e.g. on a 1GB system the direct mapping will 
> never use 1GB pages.
> 
> And the CPU has to handle this anyways because all the old 
> kernels overmap and no x86 CPU can drop support for all old
> kernels.

for the 2mb case.. please find me a dimm which isn't a multiple of
2Mb ;-)

