Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbXJOXCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbXJOXCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXJOXCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:02:33 -0400
Received: from www.tglx.de ([62.245.132.106]:42085 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbXJOXCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:02:32 -0400
Date: Tue, 16 Oct 2007 01:01:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: asm-x86/* exported headers using CONFIG_X86_32
In-Reply-To: <200710160054.00138.arnd@arndb.de>
Message-ID: <alpine.LFD.0.9999.0710160100420.22612@localhost.localdomain>
References: <200710160054.00138.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Arnd Bergmann wrote:
> While looking through the new header files, I noticed lots of occurences
> of #ifdef CONFIG_X86_32 in headers files exported for glibc.
> 
> This is fundamentally broken because user applications including them
> do not know about any CONFIG_* symbols, and if they did, those
> would incorrectly describe the ABI.
> 
> I guess in most cases, the headers that are interesting to user space
> can simply be merged without any such #ifdef remaining, but those
> that are still needed should be converted to use #ifdef __x86_64__,
> which is set by the compiler.
> This is how the other architectures avoid this particular problem.

Yup, they slipped through. I have fixups in my pile already. Will send
them tomorrow when I'm actually awake.

     tglx

