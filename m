Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbYKRLpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbYKRLpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYKRLox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:44:53 -0500
Received: from ozlabs.org ([203.10.76.45]:39853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYKRLow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:44:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18722.43694.861169.946743@cargo.ozlabs.ibm.com>
Date: Tue, 18 Nov 2008 22:44:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <200811182124.33141.nickpiggin@yahoo.com.au>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	<18722.2107.970887.768477@cargo.ozlabs.ibm.com>
	<alpine.LFD.2.00.0811171752450.18283@nehalem.linux-foundation.org>
	<200811182124.33141.nickpiggin@yahoo.com.au>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:

> It's much harder to do this with powerpc I think because they would need
> to calculate 8 hashes and touch 8 cachelines to prefill 8 translations,
> wouldn't they?

Yeah, the hashed page table sucks.  Film at 11, as they say. :)

Paul.
