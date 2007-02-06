Return-Path: <linux-kernel-owner+w=401wt.eu-S965581AbXBFXts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581AbXBFXts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965591AbXBFXts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:49:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965590AbXBFXtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:49:46 -0500
Date: Tue, 6 Feb 2007 15:49:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170803900.29759.1040.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702061528370.8424@woody.linux-foundation.org>
References: <1170803900.29759.1040.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, David Woodhouse wrote:
> 
> Out of interest, which people would this be? Not me, certainly.
> I _use_ select, for options which don't have questions. There were two
> such instances in the context of Ingo's mail of $subject, even.
> 
> And the thing Randy was saying "yes" to, which you elided but I've
> restored in the above quotation, was the idea of turning 'select' into
> 'depends on' for _user-visible_ options. NOT for the ones which don't
> have a question.

Example: crypto api. SCSI. firewall "expert mode". Any number of things.

Qutie often, the questions themselves are *conditional*. For example, look 
at the whole INPUT layer thing. It is a real question, but only for 
EMBEDDED - normally, we just assume we'll use it (but it's a classic 
example of where we could have used a "select" from the keyboard driver 
instead).

For normal people, it's a question that simply shouldn't be asked. You 
don't ask normal users whether they want to hook up keyboards and mice 
(and trust me when I say that: we _used_ to ask. It generated tons of 
totally idiotic noise).

		Linus
