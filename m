Return-Path: <linux-kernel-owner+w=401wt.eu-S1751291AbXBNXSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbXBNXSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXBNXSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:18:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3856 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXBNXSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:18:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 15:17:59 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
In-Reply-To: <20070214214409.GM32271@kvack.org>
Message-ID: <Pine.LNX.4.64.0702141452240.7796@alien.or.mcafeemobile.com>
References: <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu>
 <20070214110419.GC4241@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
 <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
 <20070214200347.GK32271@kvack.org> <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com>
 <20070214203438.GL32271@kvack.org> <Pine.LNX.4.64.0702141241030.7796@alien.or.mcafeemobile.com>
 <20070214214409.GM32271@kvack.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Benjamin LaHaise wrote:

> On Wed, Feb 14, 2007 at 01:06:59PM -0800, Davide Libenzi wrote:
> > Bear with me Ben, and let's follow this up :) If you are in the middle of 
> > an MMX copy operation, inside the syscall, you are:
> > 
> > - Userspace, on task A, calls sys_async_exec
> > 
> > - Userspace in _not_ doing any MMX stuff before the call
> 
> That's an incorrect assumption.  Every task/thread in the system has FPU 
> state associated with it, in part due to the fact that glibc has to change 
> some of the rounding mode bits, making them different than the default from 
> a freshly initialized state.

IMO I still belive this is not a huge problem. FPU state propagation/copy 
can be done in a clever way, once we detect the in-async condition.



- Davide


