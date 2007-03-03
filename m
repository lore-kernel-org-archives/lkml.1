Return-Path: <linux-kernel-owner+w=401wt.eu-S2992892AbXCCBtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992892AbXCCBtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992896AbXCCBtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:49:08 -0500
Received: from kanga.kvack.org ([66.96.29.28]:52682 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992892AbXCCBtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:49:07 -0500
Date: Fri, 2 Mar 2007 20:48:54 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070303014854.GC26583@kvack.org>
References: <20070301153655.GB8217@2ka.mipt.ru> <20070302105713.GB15576@elte.hu> <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com> <20070302193941.GB8450@elte.hu> <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com> <20070302202931.GA5101@elte.hu> <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com> <1172871820.2999.22.camel@entropy> <Pine.LNX.4.64.0703021615140.2381@alien.or.mcafeemobile.com> <1172885761.2999.32.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172885761.2999.32.camel@entropy>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 05:36:01PM -0800, Nicholas Miell wrote:
> > as an asynchronous context helps alot: the classic gcc convention for 
> > FPU use & function calls should apply: gcc does not call an external 
> > function with an in-use FPU stack/register, it always neatly unuses it, 
> > as no FPU register is callee-saved, all are caller-saved.
> 
> The i386 psABI is ancient (i.e. it predates SSE, so no mention of the
> XMM or MXCSR registers) and a bit vague (no mention at all of the FP
> status word), but I'm fairly certain that Ingo is right.

The FPU status word *must* be saved, as the rounding behaviour and error mode 
bits are assumed to be preserved.  Iow, yes, there is state which is required.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
