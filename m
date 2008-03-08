Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbYCHBh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbYCHBh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYCHBht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:37:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYCHBht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:37:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64 ptrace orig_ax on ia32 task
In-Reply-To: Linus Torvalds's message of  Friday, 7 March 2008 15:18:41 -0800 <alpine.LFD.1.00.0803071507240.3013@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080229035707.EAE862700FD@magilla.localdomain>
	<20080307225602.6491B26F990@magilla.localdomain>
	<alpine.LFD.1.00.0803071507240.3013@woody.linux-foundation.org>
X-Windows: the cutting edge of obsolescence.
Message-Id: <20080308013742.9C06F26F990@magilla.localdomain>
Date: Fri,  7 Mar 2008 17:37:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm. Why make this conditional on CONFIG_IA32_EMULATION and TIF_IA32?

I just wasn't touching the case that wasn't broken.

> So I'd suggest just making it entirely unconditionally just do

That is fine by me.


Thanks,
Roland
