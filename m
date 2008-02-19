Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYBSXWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYBSXWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYBSXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:21:58 -0500
Received: from ozlabs.org ([203.10.76.45]:57527 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbYBSXV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:21:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18363.25743.402510.695150@cargo.ozlabs.ibm.com>
Date: Wed, 20 Feb 2008 10:21:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland McGrath <roland@redhat.com>, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
	check
In-Reply-To: <20080219110536.GA2683@elte.hu>
References: <47B95C4D.6080000@cn.fujitsu.com>
	<47BA3CAB.30905@cn.fujitsu.com>
	<20080219110536.GA2683@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
> 
> * Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> 
> > We need to check for stack overflow only when the signal is on stack. 
> > So we can improve the patch "http://lkml.org/lkml/2007/11/27/101" as 
> > following.
> 
> thanks, applied.

These patches change the behaviour of programs that longjmp out of a
signal handler on an alternate stack, don't they?

I'm interested to know what gave you confidence that changing that
behaviour won't break existing working programs.

Paul.
